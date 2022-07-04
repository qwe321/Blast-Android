# - Try to find hbao+
# Once done this will define
#  HBAO_PLUS_FOUND - System has hbao+
#  HBAO_PLUS_INCLUDE_DIRS - The hbao+ include directories
#  HBAO_PLUS_LIB - The lib needed to use hbao+
#  HBAO_PLUS_DLL - The dll needed to use hbao+

INCLUDE(FindPackageHandleStandardArgs)

FIND_PATH(		HBAO_PLUS_PATH include/GFSDK_SSAO.h
				PATHS 
				$ENV{PM_hbao_plus_PATH}
				${GW_DEPS_ROOT}/hbao_plus/${hbao_plus_FIND_VERSION}
				)

MESSAGE("hbao+: " ${HBAO_PLUS_PATH})
				
IF(TARGET_BUILD_PLATFORM STREQUAL "Windows")
	if (CMAKE_CL_64)
		SET(HBAO_PLUS_ARCH_FOLDER "win64")
		SET(HBAO_PLUS_ARCH_FILE ".win64")
	else()
		SET(HBAO_PLUS_ARCH_FOLDER "win32")
		SET(HBAO_PLUS_ARCH_FILE ".win32")
	endif()		

	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".lib" ".dll")
			
					
	FIND_LIBRARY(	HBAO_PLUS_LIB
					NAMES GFSDK_SSAO_D3D11${HBAO_PLUS_ARCH_FILE}
					PATHS
					${HBAO_PLUS_PATH}/lib/${HBAO_PLUS_ARCH_FOLDER}
					)
	
	find_library(	HBAO_PLUS_DLL
					NAMES GFSDK_SSAO_D3D11${HBAO_PLUS_ARCH_FILE}
					PATHS 
					${HBAO_PLUS_PATH}/bin/${HBAO_PLUS_ARCH_FOLDER}
	)

	
	SET(HBAO_PLUS_INCLUDE_DIRS
		${HBAO_PLUS_PATH}/include
	)
ENDIF()
	
FIND_PACKAGE_HANDLE_STANDARD_ARGS(hbao_plus DEFAULT_MSG HBAO_PLUS_LIB HBAO_PLUS_DLL HBAO_PLUS_INCLUDE_DIRS)

mark_as_advanced(HBAO_PLUS_INCLUDE_DIRS HBAO_PLUS_DLL HBAO_PLUS_LIB)