# - Try to find d3dcompiler
# Once done this will define
#  D3DCOMPILER_FOUND - System has d3dcompiler
#  D3DCOMPILER_DLL - The dll needed to use d3dcompiler

INCLUDE(FindPackageHandleStandardArgs)

#TODO: Proper version support
FIND_PATH(		D3DCOMPILER_PATH bin/x86
				PATHS
				$ENV{PM_d3dcompiler_PATH}
				${GW_DEPS_ROOT}/d3dcompiler/${d3dcompiler_FIND_VERSION}
				)

MESSAGE("d3dcompiler: " ${D3DCOMPILER_PATH})
				
IF(TARGET_BUILD_PLATFORM STREQUAL "Windows")
	if (CMAKE_CL_64)
		SET(D3DCOMPILER_ARCH_FOLDER "x64")
	else()
		SET(D3DCOMPILER_ARCH_FOLDER "x86")
	endif()		

	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".dll")
			
					
	find_library(	D3DCOMPILER_DLL
					NAMES d3dcompiler_47
					PATHS 
					${D3DCOMPILER_PATH}/bin/${D3DCOMPILER_ARCH_FOLDER}
					NO_DEFAULT_PATH
	)
ENDIF()
	
FIND_PACKAGE_HANDLE_STANDARD_ARGS(d3dcompiler DEFAULT_MSG D3DCOMPILER_DLL)

mark_as_advanced(D3DCOMPILER_DLL)