include( CMakeParseArguments )

add_executable( texturec ${BIMG_DIR}/tools/texturec/texturec.cpp )
set_target_properties( texturec PROPERTIES FOLDER "bgfx/tools" )
target_link_libraries( texturec bimg )
if( BGFX_CUSTOM_TARGETS )
	add_dependencies( tools texturec )
endif()
