# Third party libs
include( cmake/3rdparty/edtaa3.cmake )
include( cmake/3rdparty/etc1.cmake )
include( cmake/3rdparty/etc2.cmake )
include( cmake/3rdparty/iqa.cmake )
include( cmake/3rdparty/libsquish.cmake )
include( cmake/3rdparty/nvtt.cmake )
include( cmake/3rdparty/pvrtc.cmake )

# Ensure the directory exists
if( NOT IS_DIRECTORY ${BIMG_DIR} )
	message( SEND_ERROR "Could not load bimg, directory does not exist. ${BIMG_DIR}" )
	return()
endif()

# Grab the bimg source files
file( GLOB BIMG_SOURCES ${BIMG_DIR}/src/*.cpp )

# Create the bimg target
add_library( bimg STATIC ${BIMG_SOURCES} )

# Add include directory of bimg
target_include_directories( bimg PUBLIC ${BIMG_DIR}/include )

# bimg dependencies
target_link_libraries( bimg bx edtaa3 etc1 etc2 iqa squish nvtt pvrtc )

# Put in a "bgfx" folder in Visual Studio
set_target_properties( bimg PROPERTIES FOLDER "bgfx" )

# Export debug build as "bimgd"
set_target_properties( bimg PROPERTIES OUTPUT_NAME_DEBUG "bimg" )
