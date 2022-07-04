# - Try to find PhysX binary SDK
# - Sets PHYSXSDK_LIBS_DEBUG, PHYSXSDK_LIBS_RELEASE, PHYSXSDK_LIBS_CHECKED, PHYSXSDK_LIBS_PROFILE - lists of the libraries found
# - Sets PHYSXSDK_INCLUDE_DIRS 
# - Sets PHYSXSDK_DLLS - List of the DLLs to copy to the bin directory of projects that depend on this

include(FindPackageHandleStandardArgs)

MESSAGE("Looking for PhysXSDK ${PhysXSDK_FIND_VERSION} Cached path: ${PHYSXSDK_PATH}")
find_path(PHYSXSDK_PATH include/PxActor.h
	PATHS
	$ENV{PM_physxsdk_PATH}
)

# Is the config defined in the names of binaries or path
option(PHYSX_DEPS_WITH_CONFIG_NAME "Assume that Physx dependencies contain config in their names" OFF)

if(PHYSX_DEPS_WITH_CONFIG_NAME)
	SET(DEBUG_CONFIG_SUFFIX "DEBUG")
	SET(PROFILE_CONFIG_SUFFIX "PROFILE")
	SET(CHECKED_CONFIG_SUFFIX "CHECKED")
	SET(RELEASE_CONFIG_SUFFIX "")
else()
	SET(DEBUG_CONFIG_PATH_SUFFIX "debug")
	SET(PROFILE_CONFIG_PATH_SUFFIX "profile")
	SET(CHECKED_CONFIG_PATH_SUFFIX "checked")
	SET(RELEASE_CONFIG_PATH_SUFFIX "release")
endif()

if (TARGET_BUILD_PLATFORM STREQUAL "Windows")
	# If the project pulling in this dependency needs the static crt, then append that to the path.
	if (STATIC_WINCRT)
		SET(PHYSX_CRT_SUFFIX ".mt")
	else()
		SET(PHYSX_CRT_SUFFIX ".md")
	endif()

	if (CMAKE_CL_64)
		SET(PHYSX_ARCH_FILE "_64")
	else()
		SET(PHYSX_ARCH_FILE "_x86")
	endif()

	SET(PHYSX_ARCH_FOLDER "win.x86_64.")

	# What compiler version do we want?

	if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 19.10.0.0)
		SET(VS_STR "vc141")
	else()
		MESSAGE(FATAL_ERROR "Failed to find compatible PhysXSDK - Only supporting VS2017 and higher")
	endif()
		
	SET(LIB_PATH ${PHYSXSDK_PATH}/bin/${PHYSX_ARCH_FOLDER}${VS_STR}${PHYSX_CRT_SUFFIX})
	# Set library suffix as .lib only since otherwise there would be ambiguity between .dll and .lib files.
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".lib")

elseif(TARGET_BUILD_PLATFORM STREQUAL "PS4")
	SET(LIB_PATH ${PHYSXSDK_PATH}/bin/vc14ps4-cmake)
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
	SET(CMAKE_FIND_LIBRARY_PREFIXES "lib")
elseif(TARGET_BUILD_PLATFORM STREQUAL "XboxOne")
	SET(LIB_PATH ${PHYSXSDK_PATH}/bin/vc14xboxone-cmake)
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a" ".lib")
	SET(CMAKE_FIND_LIBRARY_PREFIXES "lib" "")
elseif(TARGET_BUILD_PLATFORM STREQUAL "linux")
	SET(LIB_PATH ${PHYSXSDK_PATH}/bin/linux.clang)
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
	SET(CMAKE_FIND_LIBRARY_PREFIXES "lib")
	SET(PHYSX_ARCH_FILE "_64")
elseif(TARGET_BUILD_PLATFORM STREQUAL "android")
	SET(LIB_PATH ${PHYSXSDK_PATH}/bin/android.arm64-v8a.fp-soft)
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
	SET(CMAKE_FIND_LIBRARY_PREFIXES "lib")
endif()

# Now find all of the PhysX libs in the lib directory

if ((NOT TARGET_BUILD_PLATFORM STREQUAL "linux") AND (NOT TARGET_BUILD_PLATFORM STREQUAL "android"))
	find_library(PHYSX_LIB
		NAMES PhysX${RELEASE_CONFIG_SUFFIX} PhysX${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOMMON_LIB
		NAMES PhysXCommon${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOOKING_LIB
		NAMES PhysXCooking${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB
		NAMES PhysXFoundation${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)

	find_library(PHYSX_LIB_DEBUG
		NAMES PhysX${DEBUG_CONFIG_SUFFIX} PhysX${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOMMON_LIB_DEBUG
		NAMES PhysXCommon${DEBUG_CONFIG_SUFFIX} PhysXCommon${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOOKING_LIB_DEBUG
		NAMES PhysXCooking${DEBUG_CONFIG_SUFFIX} PhysXCooking${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB_DEBUG
		NAMES PhysXFoundation${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)

	find_library(PHYSX_LIB_CHECKED
		NAMES PhysX${CHECKED_CONFIG_SUFFIX} PhysX${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOMMON_LIB_CHECKED
		NAMES PhysXCommon${CHECKED_CONFIG_SUFFIX} PhysXCommon${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOOKING_LIB_CHECKED
		NAMES PhysXCooking${CHECKED_CONFIG_SUFFIX} PhysXCooking${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB_CHECKED
		NAMES PhysXFoundation${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)

	find_library(PHYSX_LIB_PROFILE
		NAMES PhysX${PROFILE_CONFIG_SUFFIX} PhysX${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOMMON_LIB_PROFILE
		NAMES PhysXCommon${PROFILE_CONFIG_SUFFIX} PhysXCommon${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOOKING_LIB_PROFILE
		NAMES PhysXCooking${PROFILE_CONFIG_SUFFIX} PhysXCooking${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB_PROFILE
		NAMES PhysXFoundation${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)

	find_library(PHYSXTASK_STATIC_LIB
		NAMES PhysXTask_static${RELEASE_CONFIG_SUFFIX} PhysXTask_static${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXTASK_STATIC_LIB_DEBUG
		NAMES PhysXTask_static${DEBUG_CONFIG_SUFFIX} PhysXTask_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXTASK_STATIC_LIB_CHECKED
		NAMES PhysXTask_static${CHECKED_CONFIG_SUFFIX} PhysXTask_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXTASK_STATIC_LIB_PROFILE
		NAMES PhysXTask_static${PROFILE_CONFIG_SUFFIX} PhysXTask_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
elseif (TARGET_BUILD_PLATFORM STREQUAL "android")
	find_library(PHYSX_LIB
		NAMES PhysX_static
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)

	find_library(PHYSXCOMMON_LIB
		NAMES PhysXCommon_static${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)
	find_library(PHYSXCOOKING_LIB
		NAMES PhysXCooking_static${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)
	find_library(PHYSXFOUNDATION_LIB
		NAMES PhysXFoundation_static${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)

	find_library(PHYSX_LIB_DEBUG
		NAMES PhysX_static${DEBUG_CONFIG_SUFFIX} PhysX_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)
	find_library(PHYSXCOMMON_LIB_DEBUG
		NAMES PhysXCommon_static${DEBUG_CONFIG_SUFFIX} PhysXCommon_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)
	find_library(PHYSXCOOKING_LIB_DEBUG
		NAMES PhysXCooking_static${DEBUG_CONFIG_SUFFIX} PhysXCooking_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)
	find_library(PHYSXFOUNDATION_LIB_DEBUG
		NAMES PhysXFoundation_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)

	find_library(PHYSX_LIB_CHECKED
		NAMES PhysX_static${CHECKED_CONFIG_SUFFIX} PhysX_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)
	find_library(PHYSXCOMMON_LIB_CHECKED
		NAMES PhysXCommon_static${CHECKED_CONFIG_SUFFIX} PhysXCommon_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)
	find_library(PHYSXCOOKING_LIB_CHECKED
		NAMES PhysXCooking_static${CHECKED_CONFIG_SUFFIX} PhysXCooking_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)
	find_library(PHYSXFOUNDATION_LIB_CHECKED
		NAMES PhysXFoundation_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)

	find_library(PHYSX_LIB_PROFILE
		NAMES PhysX_static${PROFILE_CONFIG_SUFFIX} PhysX_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)
	find_library(PHYSXCOMMON_LIB_PROFILE
		NAMES PhysXCommon_static${PROFILE_CONFIG_SUFFIX} PhysXCommon_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)
	find_library(PHYSXCOOKING_LIB_PROFILE
		NAMES PhysXCooking_static${PROFILE_CONFIG_SUFFIX} PhysXCooking_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)
	find_library(PHYSXFOUNDATION_LIB_PROFILE
		NAMES PhysXFoundation_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
		NO_CMAKE_FIND_ROOT_PATH
	)
else()
	find_library(PHYSX_LIB
		NAMES PhysX_static${RELEASE_CONFIG_SUFFIX} PhysX_static${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)

	find_library(PHYSXCOMMON_LIB
		NAMES PhysXCommon_static${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOOKING_LIB
		NAMES PhysXCooking_static${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB
		NAMES PhysXFoundation_static${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)

	find_library(PHYSX_LIB_DEBUG
		NAMES PhysX_static${DEBUG_CONFIG_SUFFIX} PhysX_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOMMON_LIB_DEBUG
		NAMES PhysXCommon_static${DEBUG_CONFIG_SUFFIX} PhysXCommon_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOOKING_LIB_DEBUG
		NAMES PhysXCooking_static${DEBUG_CONFIG_SUFFIX} PhysXCooking_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB_DEBUG
		NAMES PhysXFoundation_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)

	find_library(PHYSX_LIB_CHECKED
		NAMES PhysX_static${CHECKED_CONFIG_SUFFIX} PhysX_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOMMON_LIB_CHECKED
		NAMES PhysXCommon_static${CHECKED_CONFIG_SUFFIX} PhysXCommon_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOOKING_LIB_CHECKED
		NAMES PhysXCooking_static${CHECKED_CONFIG_SUFFIX} PhysXCooking_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB_CHECKED
		NAMES PhysXFoundation_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)

	find_library(PHYSX_LIB_PROFILE
		NAMES PhysX_static${PROFILE_CONFIG_SUFFIX} PhysX_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOMMON_LIB_PROFILE
		NAMES PhysXCommon_static${PROFILE_CONFIG_SUFFIX} PhysXCommon_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOOKING_LIB_PROFILE
		NAMES PhysXCooking_static${PROFILE_CONFIG_SUFFIX} PhysXCooking_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB_PROFILE
		NAMES PhysXFoundation_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
endif()

find_library(PHYSXEXTENSIONS_STATIC_LIB
	NAMES PhysXExtensions_static PhysXExtensions_static${RELEASE_CONFIG_SUFFIX} PhysXExtensions_static${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
	PATHS ${LIB_PATH}
	PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	NO_CMAKE_FIND_ROOT_PATH
)
find_library(PHYSXCHARACTERKINEMATIC_STATIC_LIB
	NAMES PhysXCharacterKinematic_static PhysXCharacterKinematic_static${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
	PATHS ${LIB_PATH}
	PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	NO_CMAKE_FIND_ROOT_PATH
)
find_library(PHYSXPVDSDK_STATIC_LIB
	NAMES PhysXPvdSDK_static PhysXPvdSDK_static${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
	PATHS ${LIB_PATH}
	PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	NO_CMAKE_FIND_ROOT_PATH
)

find_library(PHYSXEXTENSIONS_STATIC_LIB_DEBUG
	NAMES PhysXExtensions_static PhysXExtensions_static${DEBUG_CONFIG_SUFFIX} PhysXExtensions_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
	PATHS ${LIB_PATH}
	PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	NO_CMAKE_FIND_ROOT_PATH
)
find_library(PHYSXCHARACTERKINEMATIC_STATIC_LIB_DEBUG
	NAMES PhysXCharacterKinematic_static PhysXCharacterKinematic_static${DEBUG_CONFIG_SUFFIX} PhysXCharacterKinematic_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
	PATHS ${LIB_PATH}
	PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	NO_CMAKE_FIND_ROOT_PATH
)
find_library(PHYSXPVDSDK_STATIC_LIB_DEBUG
	NAMES PhysXPvdSDK_static PhysXPvdSDK_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
	PATHS ${LIB_PATH}
	PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	NO_CMAKE_FIND_ROOT_PATH
)

find_library(PHYSXEXTENSIONS_STATIC_LIB_CHECKED
	NAMES PhysXExtensions_static PhysXExtensions_static${CHECKED_CONFIG_SUFFIX} PhysXExtensions_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
	PATHS ${LIB_PATH}
	PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	NO_CMAKE_FIND_ROOT_PATH
)
find_library(PHYSXCHARACTERKINEMATIC_STATIC_LIB_CHECKED
	NAMES PhysXCharacterKinematic_static PhysXCharacterKinematic_static${CHECKED_CONFIG_SUFFIX} PhysXCharacterKinematic_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
	PATHS ${LIB_PATH}
	PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	NO_CMAKE_FIND_ROOT_PATH
)
find_library(PHYSXPVDSDK_STATIC_LIB_CHECKED
	NAMES PhysXPvdSDK_static PhysXPvdSDK_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
	PATHS ${LIB_PATH}
	PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	NO_CMAKE_FIND_ROOT_PATH
)

find_library(PHYSXEXTENSIONS_STATIC_LIB_PROFILE
	NAMES PhysXExtensions_static PhysXExtensions_static${PROFILE_CONFIG_SUFFIX} PhysXExtensions_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
	PATHS ${LIB_PATH}
	PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	NO_CMAKE_FIND_ROOT_PATH
)
find_library(PHYSXCHARACTERKINEMATIC_STATIC_LIB_PROFILE
	NAMES PhysXCharacterKinematic_static PhysXCharacterKinematic_static${PROFILE_CONFIG_SUFFIX} PhysXCharacterKinematic_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
	PATHS ${LIB_PATH}
	PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	NO_CMAKE_FIND_ROOT_PATH
)
find_library(PHYSXPVDSDK_STATIC_LIB_PROFILE
	NAMES PhysXPvdSDK_static PhysXPvdSDK_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
	PATHS ${LIB_PATH}
	PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	NO_CMAKE_FIND_ROOT_PATH
)


if (TARGET_BUILD_PLATFORM STREQUAL "Windows")

	find_library(PHYSXGPU_LIB
		NAMES PhysXGpu${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXGPU_LIB_DEBUG
		NAMES PhysXGpu${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${LIB_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)

	SET(DLL_PATH ${PHYSXSDK_PATH}/bin/${PHYSX_ARCH_FOLDER}${VS_STR}${PHYSX_CRT_SUFFIX})
	# Set library suffix as .dll only since otherwise there would be ambiguity between .dll and .lib files.
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".dll")

	find_library(PHYSX_DLL
		NAMES PhysX${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOMMON_DLL
		NAMES PhysXCommon${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOOKING_DLL
		NAMES PhysXCooking${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_DLL
		NAMES PhysXFoundation${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXGPU_DLL
		NAMES PhysXGpu${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)


	find_library(PHYSX_DLL_DEBUG
		NAMES PhysX${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOMMON_DLL_DEBUG
		NAMES PhysXCommon${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOOKING_DLL_DEBUG
		NAMES PhysXCooking${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_DLL_DEBUG
		NAMES PhysXFoundation${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
	# NOTE - GPU dlls not included in required dlls or libs as they're optional.
	find_library(PHYSXGPU_DLL_DEBUG
		NAMES PhysXGpu${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
		

	find_library(PHYSX_DLL_PROFILE
		NAMES PhysX${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOMMON_DLL_PROFILE
		NAMES PhysXCommon${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOOKING_DLL_PROFILE
		NAMES PhysXCooking${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_DLL_PROFILE
		NAMES PhysXFoundation${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
	# NOTE - GPU dlls not included in required dlls or libs as they're optional.
	find_library(PHYSXGPU_DLL_PROFILE
		NAMES PhysXGpu${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
	

	find_library(PHYSX_DLL_CHECKED
		NAMES PhysX${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOMMON_DLL_CHECKED
		NAMES PhysXCommon${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXCOOKING_DLL_CHECKED
		NAMES PhysXCooking${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_DLL_CHECKED
		NAMES PhysXFoundation${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)
	# NOTE - GPU dlls not included in required dlls or libs as they're optional.
	find_library(PHYSXGPU_DLL_CHECKED
		NAMES PhysXGpu${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${DLL_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)

	# Restore library suffixes to both .dll and .lib so that it doesn't affect other packages.
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".dll" ".lib")
	

	# Create this list to check for found dlls below
	SET(DLL_VAR_LIST 
		PHYSX_DLL 
		PHYSXCOMMON_DLL
		PHYSXCOOKING_DLL 
		PHYSXFOUNDATION_DLL

		PHYSX_DLL_DEBUG 
		PHYSXCOMMON_DLL_DEBUG
		PHYSXCOOKING_DLL_DEBUG
		PHYSXFOUNDATION_DLL_DEBUG

		PHYSX_DLL_PROFILE 
		PHYSXCOMMON_DLL_PROFILE
		PHYSXCOOKING_DLL_PROFILE
		PHYSXFOUNDATION_DLL_PROFILE

		PHYSX_DLL_CHECKED 
		PHYSXCOMMON_DLL_CHECKED
		PHYSXCOOKING_DLL_CHECKED
		PHYSXFOUNDATION_DLL_CHECKED
	)
endif()

if (TARGET_BUILD_PLATFORM STREQUAL "linux")
	SET(BIN_PATH ${PHYSXSDK_PATH}/bin/linux64-cmake ${PHYSXSDK_PATH}/../Bin)
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".so")


    find_library(PHYSX_LIB
        NAMES PhysX${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOOKING_LIB
        NAMES PhysXCooking${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCHARACTERKINEMATIC_STATIC_LIB
        NAMES PhysXCharacterKinematic_static${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOMMON_LIB
        NAMES PhysXCommon${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB
		NAMES PhysXFoundation${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
	)

    find_library(PHYSX_LIB_DEBUG
        NAMES PhysX${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOOKING_LIB_DEBUG
        NAMES PhysXCooking${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCHARACTERKINEMATIC_STATIC_LIB_DEBUG
        NAMES PhysXCharacterKinematic_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOMMON_LIB_DEBUG
        NAMES PhysXCommon${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB_DEBUG
		NAMES PhysXFoundation${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
	)

    find_library(PHYSX_LIB_CHECKED
        NAMES PhysX${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOOKING_LIB_CHECKED
        NAMES PhysXCooking${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCHARACTERKINEMATIC_STATIC_LIB_CHECKED
        NAMES PhysXCharacterKinematic_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOMMON_LIB_CHECKED
        NAMES PhysXCommon${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB_CHECKED
		NAMES PhysXFoundation${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
	)

    
    find_library(PHYSX_LIB_PROFILE
        NAMES PhysX${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOOKING_LIB_PROFILE
        NAMES PhysXCooking${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCHARACTERKINEMATIC_STATIC_LIB_PROFILE
        NAMES PhysXCharacterKinematic_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOMMON_LIB_PROFILE
        NAMES PhysXCommon${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB_PROFILE
		NAMES PhysXFoundation${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
	)
elseif (TARGET_BUILD_PLATFORM STREQUAL "android")
	SET(BIN_PATH ${PHYSXSDK_PATH}/bin/android.arm64-v8a.fp-soft ${PHYSXSDK_PATH}/../Bin)
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")


    find_library(PHYSX_LIB
        NAMES PhysX${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOOKING_LIB
        NAMES PhysXCooking${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCHARACTERKINEMATIC_STATIC_LIB
        NAMES PhysXCharacterKinematic_static${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOMMON_LIB
        NAMES PhysXCommon${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${RELEASE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB
		NAMES PhysXFoundation${RELEASE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
	)

    find_library(PHYSX_LIB_DEBUG
        NAMES PhysX${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOOKING_LIB_DEBUG
        NAMES PhysXCooking${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCHARACTERKINEMATIC_STATIC_LIB_DEBUG
        NAMES PhysXCharacterKinematic_static${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOMMON_LIB_DEBUG
        NAMES PhysXCommon${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${DEBUG_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB_DEBUG
		NAMES PhysXFoundation${DEBUG_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
	)

    find_library(PHYSX_LIB_CHECKED
        NAMES PhysX${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOOKING_LIB_CHECKED
        NAMES PhysXCooking${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCHARACTERKINEMATIC_STATIC_LIB_CHECKED
        NAMES PhysXCharacterKinematic_static${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOMMON_LIB_CHECKED
        NAMES PhysXCommon${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${CHECKED_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB_CHECKED
		NAMES PhysXFoundation${CHECKED_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
	)

    
    find_library(PHYSX_LIB_PROFILE
        NAMES PhysX${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOOKING_LIB_PROFILE
        NAMES PhysXCooking${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCHARACTERKINEMATIC_STATIC_LIB_PROFILE
        NAMES PhysXCharacterKinematic_static${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
    )
    find_library(PHYSXCOMMON_LIB_PROFILE
        NAMES PhysXCommon${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
		PATH_SUFFIXES ${PROFILE_CONFIG_PATH_SUFFIX}
	)
	find_library(PHYSXFOUNDATION_LIB_PROFILE
		NAMES PhysXFoundation${PROFILE_CONFIG_SUFFIX}${PHYSX_ARCH_FILE}
		PATHS ${BIN_PATH}
	)
endif()


if ((NOT TARGET_BUILD_PLATFORM STREQUAL "linux") AND (NOT TARGET_BUILD_PLATFORM STREQUAL "android"))
	FIND_PACKAGE_HANDLE_STANDARD_ARGS(PHYSXSDK
		DEFAULT_MSG
		PHYSXSDK_PATH
		
		PHYSX_LIB
		PHYSXEXTENSIONS_STATIC_LIB
		PHYSXCHARACTERKINEMATIC_STATIC_LIB
		PHYSXCOMMON_LIB
		PHYSXCOOKING_LIB
		PHYSXFOUNDATION_LIB
		PHYSXPVDSDK_STATIC_LIB
		PHYSXTASK_STATIC_LIB

		PHYSX_LIB_DEBUG
		PHYSXEXTENSIONS_STATIC_LIB_DEBUG
		PHYSXCHARACTERKINEMATIC_STATIC_LIB_DEBUG
		PHYSXCOMMON_LIB_DEBUG
		PHYSXCOOKING_LIB_DEBUG
		PHYSXFOUNDATION_LIB_DEBUG
		PHYSXPVDSDK_STATIC_LIB_DEBUG
		PHYSXTASK_STATIC_LIB_DEBUG

		PHYSX_LIB_CHECKED
		PHYSXEXTENSIONS_STATIC_LIB_CHECKED
		PHYSXCHARACTERKINEMATIC_STATIC_LIB_CHECKED
		PHYSXCOMMON_LIB_CHECKED
		PHYSXCOOKING_LIB_CHECKED
		PHYSXFOUNDATION_LIB_CHECKED
		PHYSXPVDSDK_STATIC_LIB_CHECKED
		PHYSXTASK_STATIC_LIB_CHECKED

		PHYSX_LIB_PROFILE
		PHYSXEXTENSIONS_STATIC_LIB_PROFILE
		PHYSXCHARACTERKINEMATIC_STATIC_LIB_PROFILE
		PHYSXCOMMON_LIB_PROFILE
		PHYSXCOOKING_LIB_PROFILE
		PHYSXFOUNDATION_LIB_PROFILE
		PHYSXPVDSDK_STATIC_LIB_PROFILE
		PHYSXTASK_STATIC_LIB_PROFILE
		
		${DLL_VAR_LIST}
	)
else()
	FIND_PACKAGE_HANDLE_STANDARD_ARGS(PHYSXSDK
		DEFAULT_MSG
		PHYSXSDK_PATH
		
		PHYSX_LIB
		PHYSXEXTENSIONS_STATIC_LIB
		PHYSXCHARACTERKINEMATIC_STATIC_LIB
		PHYSXCOMMON_LIB
		PHYSXCOOKING_LIB
		PHYSXFOUNDATION_LIB
		PHYSXPVDSDK_STATIC_LIB

		PHYSX_LIB_DEBUG
		PHYSXEXTENSIONS_STATIC_LIB_DEBUG
		PHYSXCHARACTERKINEMATIC_STATIC_LIB_DEBUG
		PHYSXCOMMON_LIB_DEBUG
		PHYSXCOOKING_LIB_DEBUG
		PHYSXFOUNDATION_LIB_DEBUG
		PHYSXPVDSDK_STATIC_LIB_DEBUG

		PHYSX_LIB_CHECKED
		PHYSXEXTENSIONS_STATIC_LIB_CHECKED
		PHYSXCHARACTERKINEMATIC_STATIC_LIB_CHECKED
		PHYSXCOMMON_LIB_CHECKED
		PHYSXCOOKING_LIB_CHECKED
		PHYSXFOUNDATION_LIB_CHECKED
		PHYSXPVDSDK_STATIC_LIB_CHECKED

		PHYSX_LIB_PROFILE
		PHYSXEXTENSIONS_STATIC_LIB_PROFILE
		PHYSXCHARACTERKINEMATIC_STATIC_LIB_PROFILE
		PHYSXCOMMON_LIB_PROFILE
		PHYSXCOOKING_LIB_PROFILE
		PHYSXFOUNDATION_LIB_PROFILE
		PHYSXPVDSDK_STATIC_LIB_PROFILE
		
		${DLL_VAR_LIST}
	)
endif()

if (PHYSXSDK_FOUND)
	
	SET(PHYSXSDK_INCLUDE_DIRS
		${PHYSXSDK_PATH}/include
		${PHYSXSDK_PATH}/include/characterdynamic
		${PHYSXSDK_PATH}/include/characterkinematic
		${PHYSXSDK_PATH}/include/common 
		${PHYSXSDK_PATH}/include/cooking
		${PHYSXSDK_PATH}/include/deformable
		${PHYSXSDK_PATH}/include/extensions 
		${PHYSXSDK_PATH}/include/filebuf
		${PHYSXSDK_PATH}/include/foundation
		${PHYSXSDK_PATH}/include/geometry
		${PHYSXSDK_PATH}/include/gpu
		${PHYSXSDK_PATH}/include/particles
		${PHYSXSDK_PATH}/include/pvd
		${PHYSXSDK_PATH}/include/task
		${PHYSXSDK_PATH}/include/vehicle
		${PHYSXSDK_PATH}/source/fastxml/include
		${PHYSXSDK_PATH}/source/foundation/include
	)
	
	if ((NOT TARGET_BUILD_PLATFORM STREQUAL "linux") AND (NOT TARGET_BUILD_PLATFORM STREQUAL "android"))
		SET(PHYSXSDK_LIBS_RELEASE ${PHYSX_LIB} ${PHYSXEXTENSIONS_STATIC_LIB} ${PHYSXCHARACTERKINEMATIC_STATIC_LIB} ${PHYSXCOMMON_LIB} ${PHYSXCOOKING_LIB} ${PHYSXFOUNDATION_LIB} ${PHYSXPVDSDK_STATIC_LIB} ${PHYSXTASK_STATIC_LIB} ${PHYSXGPU_LIB}
			CACHE STRING ""
		)
		SET(PHYSXSDK_LIBS_DEBUG ${PHYSX_LIB_DEBUG} ${PHYSXEXTENSIONS_STATIC_LIB_DEBUG} ${PHYSXCHARACTERKINEMATIC_STATIC_LIB_DEBUG} ${PHYSXCOMMON_LIB_DEBUG} ${PHYSXCOOKING_LIB_DEBUG} ${PHYSXFOUNDATION_LIB_DEBUG} ${PHYSXPVDSDK_STATIC_LIB_PROFILE} ${PHYSXTASK_STATIC_LIB_PROFILE} ${PHYSXGPU_LIB_DEBUG}
			CACHE STRING ""
		)
		SET(PHYSXSDK_LIBS_CHECKED ${PHYSX_LIB_CHECKED} ${PHYSXEXTENSIONS_STATIC_LIB_CHECKED} ${PHYSXCHARACTERKINEMATIC_STATIC_LIB_CHECKED} ${PHYSXCOMMON_LIB_CHECKED} ${PHYSXCOOKING_LIB_CHECKED} ${PHYSXFOUNDATION_LIB_CHECKED} ${PHYSXPVDSDK_STATIC_LIB_CHECKED} ${PHYSXTASK_STATIC_LIB_CHECKED} ${PHYSXGPU_LIB_CHECKED}
			CACHE STRING ""
		)
		SET(PHYSXSDK_LIBS_PROFILE ${PHYSX_LIB_PROFILE} ${PHYSXEXTENSIONS_STATIC_LIB_PROFILE} ${PHYSXCHARACTERKINEMATIC_STATIC_LIB_PROFILE} ${PHYSXCOMMON_LIB_PROFILE} ${PHYSXCOOKING_LIB_PROFILE} ${PHYSXFOUNDATION_LIB_PROFILE} ${PHYSXPVDSDK_STATIC_LIB_PROFILE} ${PHYSXTASK_STATIC_LIB_PROFILE} ${PHYSXGPU_LIB_PROFILE}
			CACHE STRING ""
		)

		#NOTE: This is all dll configs, might need to be split.
		SET(PHYSXSDK_DLLS 
			$<$<CONFIG:debug>:${PHYSX_DLL_DEBUG}>
			$<$<CONFIG:debug>:${PHYSXCHARACTERKINEMATIC_DLL_DEBUG}>
			$<$<CONFIG:debug>:${PHYSXCOMMON_DLL_DEBUG}>
			$<$<CONFIG:debug>:${PHYSXCOOKING_DLL_DEBUG}>
			$<$<CONFIG:debug>:${PHYSXFOUNDATION_DLL_DEBUG}>
			$<$<CONFIG:debug>:${PHYSXGPU_DLL_DEBUG}>
			$<$<CONFIG:checked>:${PHYSX_DLL_CHECKED}>
			$<$<CONFIG:checked>:${PHYSXCHARACTERKINEMATIC_DLL_CHECKED}>
			$<$<CONFIG:checked>:${PHYSXCOMMON_DLL_CHECKED}>
			$<$<CONFIG:checked>:${PHYSXCOOKING_DLL_CHECKED}>
			$<$<CONFIG:checked>:${PHYSXFOUNDATION_DLL_CHECKED}>
			$<$<CONFIG:checked>:${PHYSXGPU_DLL_CHECKED}>
			$<$<CONFIG:profile>:${PHYSX_DLL_PROFILE}>
			$<$<CONFIG:profile>:${PHYSXCHARACTERKINEMATIC_DLL_PROFILE}>
			$<$<CONFIG:profile>:${PHYSXCOMMON_DLL_PROFILE}>
			$<$<CONFIG:profile>:${PHYSXCOOKING_DLL_PROFILE}>
			$<$<CONFIG:profile>:${PHYSXFOUNDATION_DLL_PROFILE}>
			$<$<CONFIG:profile>:${PHYSXGPU_DLL_PROFILE}>
			$<$<CONFIG:release>:${PHYSX_DLL}>
			$<$<CONFIG:release>:${PHYSXCHARACTERKINEMATIC_DLL}>
			$<$<CONFIG:release>:${PHYSXCOMMON_DLL}>
			$<$<CONFIG:release>:${PHYSXCOOKING_DLL}>
			$<$<CONFIG:release>:${PHYSXFOUNDATION_DLL}>
			$<$<CONFIG:release>:${PHYSXGPU_DLL}>
		)
	else()
		SET(PHYSXSDK_LIBS_RELEASE ${PHYSX_LIB} ${PHYSXEXTENSIONS_STATIC_LIB} ${PHYSXCHARACTERKINEMATIC_STATIC_LIB} ${PHYSXCOMMON_LIB} ${PHYSXCOOKING_LIB} ${PHYSXFOUNDATION_LIB} ${PHYSXPVDSDK_STATIC_LIB} ${PHYSXGPU_LIB}
			CACHE STRING ""
		)
		SET(PHYSXSDK_LIBS_DEBUG ${PHYSX_LIB_DEBUG} ${PHYSXEXTENSIONS_STATIC_LIB_DEBUG} ${PHYSXCHARACTERKINEMATIC_STATIC_LIB_DEBUG} ${PHYSXCOMMON_LIB_DEBUG} ${PHYSXCOOKING_LIB_DEBUG} ${PHYSXFOUNDATION_LIB_DEBUG} ${PHYSXPVDSDK_STATIC_LIB_PROFILE} ${PHYSXGPU_LIB_DEBUG}
			CACHE STRING ""
		)
		SET(PHYSXSDK_LIBS_CHECKED ${PHYSX_LIB_CHECKED} ${PHYSXEXTENSIONS_STATIC_LIB_CHECKED} ${PHYSXCHARACTERKINEMATIC_STATIC_LIB_CHECKED} ${PHYSXCOMMON_LIB_CHECKED} ${PHYSXCOOKING_LIB_CHECKED} ${PHYSXFOUNDATION_LIB_CHECKED} ${PHYSXPVDSDK_STATIC_LIB_CHECKED} ${PHYSXGPU_LIB_CHECKED}
			CACHE STRING ""
		)
		SET(PHYSXSDK_LIBS_PROFILE ${PHYSX_LIB_PROFILE} ${PHYSXEXTENSIONS_STATIC_LIB_PROFILE} ${PHYSXCHARACTERKINEMATIC_STATIC_LIB_PROFILE} ${PHYSXCOMMON_LIB_PROFILE} ${PHYSXCOOKING_LIB_PROFILE} ${PHYSXFOUNDATION_LIB_PROFILE} ${PHYSXPVDSDK_STATIC_LIB_PROFILE} ${PHYSXGPU_LIB_PROFILE}
			CACHE STRING ""
		)

		SET(PHYSXSDK_DLLS 
			$<$<CONFIG:debug>:${PHYSXGPU_DLL_DEBUG}>
			$<$<CONFIG:checked>:${PHYSXGPU_DLL_CHECKED}>
			$<$<CONFIG:profile>:${PHYSXGPU_DLL_PROFILE}>
			$<$<CONFIG:release>:${PHYSXGPU_DLL}>
		)
	endif()

	SET(PHYSXSDK_LIBRARIES "" CACHE STRING "")
	
	foreach(x ${PHYSXSDK_LIBS_RELEASE})
		list(APPEND PHYSXSDK_LIBRARIES optimized ${x})
	endforeach()
	
	foreach(x ${PHYSXSDK_LIBS_DEBUG})
		list(APPEND PHYSXSDK_LIBRARIES debug ${x})
	endforeach()
endif()
