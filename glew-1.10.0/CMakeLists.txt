cmake_minimum_required(VERSION 2.8)

add_library(GLEW src/glew.c)
include_directories(include)
add_definitions(-DGLEW_NO_GLU)
add_definitions(-DGLEW_STATIC)

IF(WIN32)
    add_definitions(-DWIN32_LEAN_AND_MEAN)
ENDIF(WIN32)

install(FILES include/GL/wglew.h DESTINATION include/GL)
install(FILES include/GL/glew.h DESTINATION include/GL)
install(FILES include/GL/glxew.h DESTINATION include/GL)
