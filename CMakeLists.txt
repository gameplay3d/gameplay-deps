cmake_minimum_required(VERSION 2.8)

project(GamePlay-deps)


IF(CMAKE_SYSTEM_NAME STREQUAL "Linux" AND NOT ANDROID)
    SET(LINUX 1)
ENDIF(CMAKE_SYSTEM_NAME STREQUAL "Linux" AND NOT ANDROID)
if(NOT ANDROID AND NOT IOS)
    include(${PROJECT_SOURCE_DIR}/cmake/TargetArch.cmake)
    set(ARCH "unknown")
    target_architecture(ARCH)
endif(NOT ANDROID AND NOT IOS)
set(CMAKE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/out/external-deps")
if(NOT ANDROID AND NOT IOS)
    IF(APPLE)
        set(LIBRARY_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/out/external-deps/lib/macos/${ARCH}")
    ELSE()
        string(TOLOWER ${CMAKE_SYSTEM_NAME} LOWER_SYSTEM_NAME)
        set(LIBRARY_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/out/external-deps/lib/${LOWER_SYSTEM_NAME}/${ARCH}")
    ENDIF(APPLE)
endif(NOT ANDROID AND NOT IOS)
IF(NOT WIN32)
    SET(CMAKE_BUILD_TYPE "Release")
ENDIF(NOT WIN32)
file(MAKE_DIRECTORY ${LIBRARY_OUTPUT_PATH})
message(STATUS "Directory: ${LIBRARY_OUTPUT_PATH}")

add_subdirectory(freetype-2.7.1)
add_subdirectory(json-7.6.1)
add_subdirectory(tinyxml2-4.0.1)
add_subdirectory(lua-5.3.4)
if (NOT APPLE)
    add_subdirectory(openal-1.17.2)
endif(NOT APPLE)
add_subdirectory(zlib-1.2.8)
add_subdirectory(png-1.6.15)
add_subdirectory(ogg-1.3.2)
add_subdirectory(vorbis-1.3.5)
add_subdirectory(assimp-3.3.1)

set(BUILD_TARGETS
    freetype
    json
    vorbisfile
    vorbisenc
    vorbis
    ogg
    png
    zlib
    lua
    tinyxml2
)
if (NOT APPLE)
    IF(WIN32)
        list(APPEND BUILD_TARGETS OpenAL32)
    ELSE(WIN32)
        list(APPEND BUILD_TARGETS openal)
    ENDIF(WIN32)
endif(NOT APPLE)

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
