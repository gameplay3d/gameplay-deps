cmake_minimum_required(VERSION 2.8)

project(external-dep)

include(${PROJECT_SOURCE_DIR}/cmake/TargetArch.cmake)

set(ARCH "unknown")
target_architecture(ARCH)
set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/out)

add_subdirectory(sqlite)

set(CPACK_GENERATOR ZIP)
include(CPack)
