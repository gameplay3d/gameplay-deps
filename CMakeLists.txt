cmake_minimum_required(VERSION 2.8)

project(GamePlay-deps)

include(${PROJECT_SOURCE_DIR}/cmake/TargetArch.cmake)

set(ARCH "unknown")
target_architecture(ARCH)
set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/out/external-deps/${CMAKE_SYSTEM_NAME}/${ARCH})

add_subdirectory(sqlite-3.8.7.2)
add_subdirectory(zlib-1.2.8)


add_subdirectory(Box2D-2.3.1)
set(BOX2D_INSTALL ON)
set(BOX2D_BUILD_EXAMPLES OFF)
