cmake_minimum_required(VERSION 2.8)

project(GamePlay-deps)

if(NOT ANDROID AND NOT IOS)
    # Skip any introspection for cross-compiling targets
    include(${PROJECT_SOURCE_DIR}/cmake/TargetArch.cmake)

    set(ARCH "unknown")
    target_architecture(ARCH)
endif(NOT ANDROID AND NOT IOS)

set(CMAKE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/out/external-deps")

if(NOT ANDROID AND NOT IOS)
    # Android and iOS toolchains will set their own output path
    set(LIBRARY_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/out/external-deps/targets/${CMAKE_SYSTEM_NAME}/${ARCH}")
endif(NOT ANDROID AND NOT IOS)

file(MAKE_DIRECTORY ${LIBRARY_OUTPUT_PATH})
message(STATUS "Direcotry: ${LIBRARY_OUTPUT_PATH}")

add_subdirectory(sqlite-3.8.7)
add_subdirectory(Box2D-2.3.0)
add_subdirectory(tinyxml2-2.1.0)
add_subdirectory(lua-5.2.3)

if (NOT APPLE)
    # We can safely skip GLEW and OpenAL for any Apple based platforms
    add_subdirectory(glew-1.10.0)
    add_subdirectory(openal-1.16.0)
endif(NOT APPLE)

# zlib must be built before png
add_subdirectory(zlib-1.2.8)
add_subdirectory(png-1.6.15)

# Ogg needs to be built before vorbis
add_subdirectory(ogg-1.3.2)
add_subdirectory(vorbis-1.3.4)

add_subdirectory(bullet-2.82-r2704)
