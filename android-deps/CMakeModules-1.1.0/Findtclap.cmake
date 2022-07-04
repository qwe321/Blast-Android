# - Try to find tclap
# Once done this will define
#  TCLAP_FOUND - System has tclap
#  TCLAP_INCLUDE_DIRS - The tclap include directories

INCLUDE(FindPackageHandleStandardArgs)

FIND_PATH(		TCLAP_PATH include/tclap/CmdLineInterface.h
				PATHS 
				$ENV{PM_tclap_PATH}
				)

MESSAGE("TClap: " ${TCLAP_PATH})
	
SET(TCLAP_INCLUDE_DIRS
	${TCLAP_PATH}/include
	${TCLAP_PATH}/include/tclap
)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(tclap DEFAULT_MSG TCLAP_INCLUDE_DIRS)

mark_as_advanced(TCLAP_INCLUDE_DIRS)