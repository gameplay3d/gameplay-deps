# this one is important
SET(CMAKE_SYSTEM_NAME BlackBerry)

#this one not so much
SET(CMAKE_SYSTEM_VERSION 1)

# Point to the BlackBerry NDK directory.  This can be downloaded by first
# downloading Momentics and then running qde.  It will then prompt you to
# download the NDK.
SET(NDK_DIR /home/nlandry/bbndk/target_10_3_1_995/qnx6)
SET(CMAKE_FIND_ROOT_PATH ${NDK_DIR})

# specify the cross compiler
SET(ENV{QNX_HOST} /home/nlandry/bbndk/host_10_3_1_12/linux/x86)
SET(ENV{QNX_TARGET} /home/nlandry/bbndk/target_10_3_1_995/qnx6)

SET(BIN_DIR /home/nlandry/bbndk/host_10_3_1_12/linux/x86/usr/bin)
SET(CMAKE_C_COMPILER   ${BIN_DIR}/qcc -Vgcc_ntoarmv7le)
SET(CMAKE_CXX_COMPILER   ${BIN_DIR}/QCC -Vgcc_ntoarmv7le)
SET(CMAKE_AR "${BIN_DIR}/ntoarmv7-ar" CACHE PATH "archive")
SET(CMAKE_RANLIB "${BIN_DIR}/ntoarmv7-ranlib" CACHE PATH "ranlib")
