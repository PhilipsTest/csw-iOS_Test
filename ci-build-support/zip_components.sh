#!/bin/bash -xl
PODSPEC_PATH="ci-build-support/Versions.rb"
VERSION_REGEX="VersionCSWPlatform[^'|\\"]*['|\\"]([^'|\\"]*)['|\\"]"
COMPONENT_VERSION=`cat $PODSPEC_PATH | egrep -o $VERSION_REGEX | sed -E "s/$VERSION_REGEX/\\1/"`
COMMIT_HASH=`git rev-parse HEAD`

export ZIPFOLDER="Zips"
cd Source
mkdir -p "${ZIPFOLDER}"
mkdir -p "${ZIPFOLDER}/Source"
echo "Zipping started"

for i in */; do
    if [ "$i" == "Library/" ] ; then
        export ZIPPATH="${ZIPFOLDER}/${i%/}_${COMMIT_HASH}.zip"
        echo "Creating zip for Component ${i} in path ${ZIPPATH}"
        cp -R "${i}" "${ZIPFOLDER}/Source/${i}"
        cd ${ZIPFOLDER}
        zip -r "../${ZIPPATH}" "Source/${i}"
        rm -rf Source/*
        cd -
    fi
done
echo "Zipping ended"
