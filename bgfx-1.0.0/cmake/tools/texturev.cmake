include( CMakeParseArguments )

add_executable( texturev ${BGFX_DIR}/tools/texturev/texturev.cpp )
set_target_properties( texturev PROPERTIES FOLDER "bgfx/tools" )
target_link_libraries( texturev example-common )
if( BGFX_CUSTOM_TARGETS )
	add_dependencies( tools texturev )
endif()
