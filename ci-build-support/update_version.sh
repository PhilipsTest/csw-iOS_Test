#!/bin/bash

EPOCH_TIME=`date +%s`
echo "Epoch time is ${EPOCH_TIME}"

sed -i "" "s/1111111111/$EPOCH_TIME/g" ./ci-build-support/Versions.rb
