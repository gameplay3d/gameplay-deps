if( BGFX_CUSTOM_TARGETS )
	add_custom_target( tools )
	set_target_properties( tools PROPERTIES FOLDER "bgfx/tools" )
endif()

include( cmake/tools/geometryc.cmake )
include( cmake/tools/shaderc.cmake )
include( cmake/tools/texturec.cmake )
include( cmake/tools/texturev.cmake )
