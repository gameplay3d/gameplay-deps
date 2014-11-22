# this one is important
SET(CMAKE_SYSTEM_NAME Android)

#this one not so much
SET(CMAKE_SYSTEM_VERSION 1)

# Point to an Android toolchain directory.  I created this by making use of the
# make-standalone-toolchain.sh available the in Android NDK bundle.
SET(NDK_DIR /home/nlandry/arm-linux-androideabi-4.8)
SET(CMAKE_FIND_ROOT_PATH ${NDK_DIR})

# specify the cross compiler
SET(CMAKE_C_COMPILER   ${NDK_DIR}/bin/arm-linux-androideabi-gcc)
SET(CMAKE_CXX_COMPILER   ${NDK_DIR}/bin/arm-linux-androideabi-g++)
