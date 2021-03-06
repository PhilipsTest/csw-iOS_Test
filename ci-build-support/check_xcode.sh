# Use from xcode buildscript:
# Build phases / New Run Script Phase
#   shell:
#     /bin/sh Tools/check_xcode_version.sh
#
# Example of variables that can be used to check against:
#    XCODE_VERSION_ACTUAL = 0731
#    XCODE_VERSION_MAJOR = 0700
#    XCODE_VERSION_MINOR = 0730

EXPECTED_VERSION="1000"
VERSION=${XCODE_VERSION_ACTUAL}

if [ "${VERSION}" != "${EXPECTED_VERSION}" ]; then
  echo "ERROR: incorrect Xcode version installed. Expected '${EXPECTED_VERSION}', found '${VERSION}'"
  exit 42
else
  echo "Correct Xcode version installed: '${VERSION}'"
fi
