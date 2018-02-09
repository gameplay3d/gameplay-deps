include( CMakeParseArguments )

include( cmake/3rdparty/forsyth-too.cmake )
include( cmake/3rdparty/ib-compress.cmake )

add_executable( geometryc ${BGFX_DIR}/tools/geometryc/geometryc.cpp )
target_compile_definitions( geometryc PRIVATE "-D_CRT_SECURE_NO_WARNINGS" )
set_target_properties( geometryc PROPERTIES FOLDER "bgfx/tools" )
target_link_libraries( geometryc bx bgfx-bounds bgfx-vertexdecl forsyth-too ib-compress )
if( BGFX_CUSTOM_TARGETS )
	add_dependencies( tools geometryc )
endif()
