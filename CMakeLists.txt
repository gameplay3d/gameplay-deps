cmake_minimum_required(VERSION 2.8)

project(GamePlay-deps)

IF(CMAKE_SYSTEM_NAME STREQUAL "Linux" AND NOT ANDROID)
    SET(LINUX 1)
ENDIF(CMAKE_SYSTEM_NAME STREQUAL "Linux" AND NOT ANDROID)

if(NOT ANDROID AND NOT IOS)
    # Skip any introspection for cross-compiling targets
    include(${PROJECT_SOURCE_DIR}/cmake/TargetArch.cmake)

    set(ARCH "unknown")
    target_architecture(ARCH)
endif(NOT ANDROID AND NOT IOS)

set(CMAKE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/out/external-deps")

if(NOT ANDROID AND NOT IOS)
    # Android and iOS toolchains will set their own output path
    IF(APPLE)
        set(LIBRARY_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/out/external-deps/lib/macosx/${ARCH}")
    ELSE()
        string(TOLOWER ${CMAKE_SYSTEM_NAME} LOWER_SYSTEM_NAME)
        set(LIBRARY_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/out/external-deps/lib/${LOWER_SYSTEM_NAME}/${ARCH}")
    ENDIF(APPLE)
endif(NOT ANDROID AND NOT IOS)

IF(NOT WIN32)
    # For Windows, let the user pick since we need to generate both Debug and
    # Release variants of all the libs.
    SET(CMAKE_BUILD_TYPE "Release")
ENDIF(NOT WIN32)

file(MAKE_DIRECTORY ${LIBRARY_OUTPUT_PATH})
message(STATUS "Directory: ${LIBRARY_OUTPUT_PATH}")

add_subdirectory(libjson-7.6.1)
add_subdirectory(tinyxml2-2.1.0)
add_subdirectory(lua-5.2.3)

if (NOT APPLE)
    add_subdirectory(openal-1.16.0)
endif(NOT APPLE)

if (NOT APPLE AND NOT ANDROID)
    add_subdirectory(glew-1.10.0)
endif (NOT APPLE AND NOT ANDROID)

# zlib must be built before png and curl
add_subdirectory(zlib-1.2.8)
add_subdirectory(png-1.6.15)

if(NOT WIN32 AND BUILD_EXTRA_LIBS)
    add_subdirectory(curl-7.39.0)
endif(NOT WIN32 AND BUILD_EXTRA_LIBS)

# Ogg needs to be built before vorbis
add_subdirectory(ogg-1.3.2)
add_subdirectory(vorbis-1.3.4)

add_subdirectory(bullet-2.82-r2704)
add_subdirectory(base64-1.0.0)

set(BUILD_TARGETS
    BulletDynamics
    LinearMath
    BulletCollision
    vorbisfile
    vorbisenc
    vorbis
    ogg
    png_static
    zlibstatic
    lua
    tinyxml2static
    json
    base64
)

if (NOT APPLE)
    list(APPEND BUILD_TARGETS GLEW)
    IF(WIN32)
        list(APPEND BUILD_TARGETS OpenAL32)
    ELSE(WIN32)
        list(APPEND BUILD_TARGETS openal)
    ENDIF(WIN32)
endif(NOT APPLE)

IF(BUILD_EXTRA_LIBS)
    if(NOT WIN32)
        list(APPEND BUILD_TARGETS libcurl)
    endif(NOT WIN32)
ENDIF(BUILD_EXTRA_LIBS)

if(WIN32)
    set(GAMEPLAY_DEPS gameplay-deps.lib)
else(WIN32)
    set(GAMEPLAY_DEPS libgameplay-deps.a)
endif(WIN32)

if(LINUX OR ANDROID)
    add_custom_command(
        OUTPUT ${GAMEPLAY_DEPS}
        COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/cmake/gnu-amalgamate.sh ${CMAKE_AR} ${LIBRARY_OUTPUT_PATH}
    )
elseif(APPLE)
    add_custom_command(
        OUTPUT ${GAMEPLAY_DEPS}
        COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/cmake/xcode-amalgamate.sh ${LIBRARY_OUTPUT_PATH}
    )
else()
    # Windows
    add_custom_command(
        OUTPUT ${GAMEPLAY_DEPS}
	COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/cmake/msvc-amalgamate.bat ${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}
    )
endif(LINUX OR ANDROID)

add_custom_target(gameplay-deps ALL DEPENDS ${GAMEPLAY_DEPS})
add_dependencies(gameplay-deps ${BUILD_TARGETS})

SET_DIRECTORY_PROPERTIES(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES ${LIBRARY_OUTPUT_PATH}/${GAMEPLAY_DEPS})
