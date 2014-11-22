#!/bin/bash

#
# Build for Linux and cross compile for Android and BlackBerry
#

ROOT_DIR=`pwd`

rm -rf build-linux
rm -rf build-android-arm
rm -rf build-bb-arm
rm -rf out

#
# Build Linux x86_64
#
mkdir build-linux
pushd build-linux
cmake ..
make install
popd

#
# Build Android ARM
#
mkdir build-android-arm
pushd build-android-arm
cmake -DCMAKE_TOOLCHAIN_FILE=$ROOT_DIR/cmake/android.toolchain.cmake ..
make install
popd

#
# Build BlackBerry ARM
#
mkdir build-bb-arm
pushd build-bb-arm
cmake -DCMAKE_TOOLCHAIN_FILE=$ROOT_DIR/cmake/blackberry.toolchain.cmake ..
make install
popd

pushd out
zip -r gameplay-deps.zip *
popd
