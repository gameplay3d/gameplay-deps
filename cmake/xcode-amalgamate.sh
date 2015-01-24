#!/bin/bash

if [ $# -ne 1 ];
then
    echo "Usage: mac-amalgamate.sh <target directory>"
    exit 1
fi

CWD=`pwd`
LIBTOOL=`which libtool`
TARGET="$1"

if [ ! -e $LIBTOOL ];
then
    echo "No such file: $LIBTOOL"
    exit 1
fi

if [ ! -d $TARGET ];
then
    echo "No such target directory: $AR"
    exit 1
fi

echo "Using libtool : $LIBTOOL"
echo "Amalgamating target static libs $TARGET"

cd $TARGET
mkdir tmp

# Remove any old library still hanging around
rm -f libgameplay-deps.a
mv *.a ./tmp

# Now use libtool to combine all the .a libs
# You can use:
#   xcrun -sdk iphoneos lipo -info libgameplay-deps.a
# To validate all the correct architectures are present.
$LIBTOOL -static `find . -name "*.a" | xargs` -o libgameplay-deps.a

# Clean up
rm -rf ./tmp

cd $CWD
