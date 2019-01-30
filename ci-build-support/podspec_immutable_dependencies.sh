#!/bin/sh

set -e

PODSPEC_PATH=""
PODFILE_LOCK_PATH=""
BRANCH=""

checkArgs() {
	test -n "$1" || usage
	PODSPEC_PATH="$1"
	test -n "$2" || usage
	PODFILE_LOCK_PATH="$2"
	test -n "$3" || usage
	BRANCH="$3"

	if [ ! -f "$PODSPEC_PATH" ]
	then 
		echo "[$PODSPEC_PATH] does not exist."
		exit 1
	elif [ ! -f "$PODFILE_LOCK_PATH" ]
	then
		echo "[$PODFILE_LOCK_PATH] does not exist."
		exit 1
	fi

}

usage() {
	echo "Usage:"
	echo ""
	echo "$0 [pathTo .podspec] [path To Podfile.lock] [develop|release|master|plf-fb]"
	exit 1
}

makeDependenciesImmutable() {
	
	echo "-------------------- fixing dependencies of $PODSPEC_PATH: --------------------"
	
	DEPENDENCY_REGEX=".dependency[^\'|\"]*[\'|\"]([^\'|\"]*)[\'|\"]"
	
	egrep -o $DEPENDENCY_REGEX $PODSPEC_PATH | while read -r line ; do
    	
    	COMPONENT_NAME=`echo $line | sed -E "s/$DEPENDENCY_REGEX/\1/"`
    	FIXED_VERSION_REGEX="$COMPONENT_NAME \(([0-9\)].*)\)"
    	FIXED_VERSION=`egrep -o "$FIXED_VERSION_REGEX" $PODFILE_LOCK_PATH | sed -E "s/$FIXED_VERSION_REGEX/\1/"`

		if [[ "$FIXED_VERSION" == "" ]]
		then
			continue
		fi
		
		echo "Fixing dependency on [$COMPONENT_NAME] to version [$FIXED_VERSION]"
		
		sed -i '' -E "s/.dependency.*[\'\"]$COMPONENT_NAME[\'\"].*/.dependency \'$COMPONENT_NAME\', \'$FIXED_VERSION\'/" $PODSPEC_PATH || exit ${PIPESTATUS[0]}
	done
	
	echo "-------------------- podspec after making dependencies immutable: --------------------"
	cat $PODSPEC_PATH
	echo "--------------------------------------------------------------------------------------"
}

main() {
    checkArgs $* || usage
	
	./ci-build-support/substitute_version.groovy $PODSPEC_PATH
  
	if [[ "$BRANCH" == release/* || "$BRANCH" == master* || "$BRANCH" == support/* || "$BRANCH" == develop ]]
	then
		makeDependenciesImmutable
	fi
}

main $*
