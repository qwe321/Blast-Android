# - Try to find tinyObjLoader
# Once done this will define
#  TINYOBJLOADER_FOUND - System has tinyObjLoader
#  TINYOBJLOADER_INCLUDE_DIRS - The tinyObjLoader include directories

INCLUDE(FindPackageHandleStandardArgs)

FIND_PATH(		TINYOBJLOADER_PATH tiny_obj_loader.h
				PATHS 
				$ENV{PM_tinyObjLoader_PATH}
				)

MESSAGE("Tiny Obj Loader: " ${TINYOBJLOADER_PATH})
	
SET(TINYOBJLOADER_INCLUDE_DIRS
	${TINYOBJLOADER_PATH}
)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(tclap DEFAULT_MSG TINYOBJLOADER_INCLUDE_DIRS)

mark_as_advanced(TINYOBJLOADER_INCLUDE_DIRS)