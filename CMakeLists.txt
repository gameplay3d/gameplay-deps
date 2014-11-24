cmake_minimum_required(VERSION 2.8)

project(GamePlay-deps)

include(${PROJECT_SOURCE_DIR}/cmake/TargetArch.cmake)

set(ARCH "unknown")
target_architecture(ARCH)
set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/out/external-deps/${CMAKE_SYSTEM_NAME}/${ARCH})

add_subdirectory(sqlite-3.8.7)
add_subdirectory(zlib-1.2.8)
add_subdirectory(Box2D-2.3.0)
add_subdirectory(tinyxml2-2.1.0)
add_subdirectory(glew-1.10.0)
add_subdirectory(lua-5.2.3)

# Ogg needs to be built before vorbis
add_subdirectory(ogg-1.3.2)
add_subdirectory(vorbis-1.3.4)
