# Use from xcode buildscript:
# Build phases / New Run Script Phase
#   shell:
#     /bin/sh Tools/check_cocoapods.sh
#
#
export LANG=en_US.UTF-8

EXPECTED_VERSION="1.5.3"
VERSION=`pod --version`

if which pod >/dev/null; then
  if [ "${VERSION}" != "${EXPECTED_VERSION}" ]; then
    echo "ERROR: incorrect Cocoapods version installed. Expected '${EXPECTED_VERSION}', found '${VERSION}'"
    exit 42
  else
    echo "Correct Cocoapods version installed: '${VERSION}'"
  fi
else
  echo "ERROR: cocopoads not installed"
  exit 42
fi
