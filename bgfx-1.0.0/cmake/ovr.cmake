# The ovr location is customizable via cache variable BGFX_OVR_DIR
if( NOT BGFX_OVR_DIR )
	set( BGFX_OVR_DIR "${CMAKE_CURRENT_SOURCE_DIR}/LibOVR" CACHE STRING "Location of LibOVR." )
endif()

# Ensure the directory exists
if( NOT IS_DIRECTORY ${BGFX_OVR_DIR} )
	message( SEND_ERROR "Could not load LibOVR, directory does not exist. ${BGFX_OVR_DIR}" )
	return()
endif()

# Create the ovr target
add_library( ovr INTERFACE )

# Add include directory of ovr
target_include_directories( ovr INTERFACE ${BGFX_OVR_DIR}/Include )

# Add bgfx configuration define
target_compile_definitions( ovr INTERFACE "BGFX_CONFIG_USE_OVR=1" )

# Build system specific configurations
if( CMAKE_SIZEOF_VOID_P EQUAL 8 )
	set( ARCH "x64" )
else()
	set( ARCH "Win32" )
endif()
if( MSVC10 )
	target_link_libraries( ovr INTERFACE ${BGFX_OVR_DIR}/Lib/Windows/${ARCH}/Release/VS2010/LibOVR.lib )
elseif( MSVC11 )
	target_link_libraries( ovr INTERFACE ${BGFX_OVR_DIR}/Lib/Windows/${ARCH}/Release/VS2012/LibOVR.lib )
elseif( MSVC12 )
	target_link_libraries( ovr INTERFACE ${BGFX_OVR_DIR}/Lib/Windows/${ARCH}/Release/VS2013/LibOVR.lib )
elseif( MSVC14 )
	target_link_libraries( ovr INTERFACE ${BGFX_OVR_DIR}/Lib/Windows/${ARCH}/Release/VS2015/LibOVR.lib )
else()
	message( STATUS "OVR not supported on this platform." )
endif()
