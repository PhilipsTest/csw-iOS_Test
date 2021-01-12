#!/bin/sh

set -e

PODSPEC_REPO_ALIAS=""
PODSPEC_REPO_URL=""
PODSPEC_PATH=""
ARTIFACTORY_REPO=""
BRANCH=""
COMMIT_HASH=""

checkArgs() {
	test -n "$1" || usage
	PODSPEC_PATH="$1"
	test -n "$2" || usage
	BRANCH="$2"

	if [ ! -f "$PODSPEC_PATH" ]
	then 
		echo "[$PODSPEC_PATH] does not exist."
		exit 1
	fi
}

usage() {
	echo "Usage:"
	echo ""
	echo "$0 [pathToPodspec] [develop|release|master|plf-fb]"
	exit 1
}

selectArtifactoryRepo() {
	ARTIFACTORY_REPO="iet-mobile-ios-release-local"
}
selectPodspecRepo() {
	if [[ "$BRANCH" == develop* ]]
	then
		PODSPEC_REPO_ALIAS="PI-cocoapod-specs-develop"
		PODSPEC_REPO_URL="git@github.com:PhilipsTest/csw-iOS-podspecs.git"
	elif [[ "$BRANCH" == release/*  ||  "$BRANCH" == master* ]]
	then
		PODSPEC_REPO_ALIAS="EHPMAT-cocoapod-specs"
		PODSPEC_REPO_URL="git@github.com:PhilipsTest/csw-iOS-podspecs.git"
	else
		echo "[fatal] please check your selected branch! Must be one of the following: develop, release or master!"
		exit 1
	fi
	
	echo "Using the following repo for publish: '${PODSPEC_REPO_URL}'"
}

injectCommitHashArtifactoryVersion() {
	COMMIT_HASH=`git rev-parse HEAD`
	COMMIT_HASH_PLACEHOLDER="#commithash#"
	ARTIFACTORY_REPO_PLACEHOLDER="#artifactoryrepo#"
	VERSION_EPOCH_PLACEHOLDER="#version_epoch#"
	VERSION_REGEX="s.version[^\'|\"]*[\'|\"]([^\'|\"]*)[\'|\"]"
	VERSION_EPOCH=`cat $PODSPEC_PATH | egrep -o $VERSION_REGEX | sed -E "s/$VERSION_REGEX/\1/"`
	
	grep -q -E $COMMIT_HASH_PLACEHOLDER $PODSPEC_PATH || { echo "could not find commit hash placeholder! [Regex for placeholder: $COMMIT_HASH_PLACEHOLDER]"; exit 1; }
	sed -i '' -E "s/$COMMIT_HASH_PLACEHOLDER/$COMMIT_HASH/" $PODSPEC_PATH || exit ${PIPESTATUS[0]}
	
	grep -q -E $ARTIFACTORY_REPO_PLACEHOLDER $PODSPEC_PATH || { echo "could not find artifactory repo placeholder! [Regex for placeholder: $ARTIFACTORY_REPO_PLACEHOLDER]"; exit 1; }
	sed -i '' -E "s/$ARTIFACTORY_REPO_PLACEHOLDER/$ARTIFACTORY_REPO/" $PODSPEC_PATH || exit ${PIPESTATUS[0]}
	
	grep -q -E $VERSION_EPOCH_PLACEHOLDER $PODSPEC_PATH || { echo "could not find epoch version placeholder! [Regex for placeholder: $VERSION_EPOCH_PLACEHOLDER]"; exit 1; }
	sed -i '' -E "s/$VERSION_EPOCH_PLACEHOLDER/$VERSION_EPOCH/" $PODSPEC_PATH || exit ${PIPESTATUS[0]}

	echo "-------------------- podspec after setting commit hash: -----------------------"
	cat $PODSPEC_PATH
	echo "-------------------------------------------------------------------------------"
}

publishUsingGit() {

	VERSION_REGEX="s.version[^\'|\"]*[\'|\"]([^\'|\"]*)[\'|\"]"
	NAME_REGEX="s.name[^\'|\"]*[\'|\"]([^\'|\"]*)[\'|\"]"
	
	COMPONENT_VERSION=`cat $PODSPEC_PATH | egrep -o $VERSION_REGEX | sed -E "s/$VERSION_REGEX/\1/"`
	COMPONENT_NAME=`cat $PODSPEC_PATH | egrep -o $NAME_REGEX | sed -E "s/$NAME_REGEX/\1/"`
	
	echo "$COMPONENT_NAME"
	echo "$COMPONENT_VERSION"
	
	if [ ! -d "$PODSPEC_REPO_ALIAS" ]
	then
	{
		mkdir $PODSPEC_REPO_ALIAS
		git clone $PODSPEC_REPO_URL -b master $PODSPEC_REPO_ALIAS
	}
	else
	{
		cd $PODSPEC_REPO_ALIAS
		git reset --hard
		git clean -xfd
		git pull --rebase origin master
		cd -
	}
	fi
	
	mkdir -p "$PODSPEC_REPO_ALIAS/$COMPONENT_NAME/$COMPONENT_VERSION"
	cp $PODSPEC_PATH "$PODSPEC_REPO_ALIAS/$COMPONENT_NAME/$COMPONENT_VERSION/."
	
	cd $PODSPEC_REPO_ALIAS
	
	git pull origin master
	git add -A
	git commit -m "[Update] $COMPONENT_NAME ($COMPONENT_VERSION)"
	git push origin master
	
	cd -
}

main() {
    checkArgs $* || usage

selectArtifactoryRepo
    injectCommitHashArtifactoryVersion
    selectPodspecRepo
    publishUsingGit
}

main $*
