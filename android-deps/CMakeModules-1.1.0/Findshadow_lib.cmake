# - Try to find shadow_lib
# Once done this will define
#  SHADOW_LIB_FOUND - System has shadow_lib
#  SHADOW_LIB_INCLUDE_DIRS - The shadow_lib include directories
#  SHADOW_LIB_LIB - The lib needed to use shadow_lib
#  SHADOW_LIB_DLL - The dll needed to use shadow_lib

INCLUDE(FindPackageHandleStandardArgs)

FIND_PATH(		SHADOW_LIB_PATH include/GFSDK_ShadowLib.h
				PATHS 
				$ENV{PM_shadow_lib_PATH}
				)

MESSAGE("shadow_lib: " ${SHADOW_LIB_PATH})
				
IF(TARGET_BUILD_PLATFORM STREQUAL "Windows")
	if (CMAKE_CL_64)
		SET(SHADOW_LIB_ARCH_FOLDER "win64")
		SET(SHADOW_LIB_ARCH_FILE ".win64")
	else()
		SET(SHADOW_LIB_ARCH_FOLDER "win32")
		SET(SHADOW_LIB_ARCH_FILE ".win32")
	endif()		

	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".lib" ".dll")
			
					
	FIND_LIBRARY(	SHADOW_LIB_LIB
					NAMES GFSDK_ShadowLib_DX11${SHADOW_LIB_ARCH_FILE}
					PATHS
					${SHADOW_LIB_PATH}/lib/${SHADOW_LIB_ARCH_FOLDER}
					)
	
	find_library(	SHADOW_LIB_DLL
					NAMES GFSDK_ShadowLib_DX11${SHADOW_LIB_ARCH_FILE}
					PATHS 
					${SHADOW_LIB_PATH}/bin/${SHADOW_LIB_ARCH_FOLDER}
	)

	
	SET(SHADOW_LIB_INCLUDE_DIRS
		${SHADOW_LIB_PATH}/include
	)
ENDIF()
	
FIND_PACKAGE_HANDLE_STANDARD_ARGS(shadow_lib DEFAULT_MSG SHADOW_LIB_LIB SHADOW_LIB_DLL SHADOW_LIB_INCLUDE_DIRS)

mark_as_advanced(SHADOW_LIB_INCLUDE_DIRS SHADOW_LIB_DLL SHADOW_LIB_LIB)