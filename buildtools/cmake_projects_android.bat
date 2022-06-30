@echo off
SetLocal EnableDelayedExpansion
echo #############################################################################################
echo Starting %~n0 %date% %time%
echo #############################################################################################

echo PM_CMakeModules_VERSION %PM_CMakeModules_VERSION%

if NOT DEFINED PM_CMakeModules_VERSION GOTO DONT_RUN_STEP_2

IF NOT DEFINED PM_PACKAGES_ROOT GOTO PM_PACKAGES_ROOT_UNDEFINED

IF NOT DEFINED PM_Android_NDK_PATH GOTO ANDROID_NDK_UNDEFINED

REM Now set up the CMake command
SET CMAKECMD=%PM_cmake_PATH%\bin\cmake.exe

echo Cmake: %CMAKECMD%

REM Generate projects here

SET CMAKE_CMD_LINE_PARAMS=-G "MinGW Makefiles" -DANDROID_STL="c++_static" -DANDROID_ABI="arm64-v8a" -DANDROID_NATIVE_API_LEVEL="android-19" -DCM_ANDROID_FP="softfp" -DCMAKE_TOOLCHAIN_FILE="%PM_Android_NDK_PATH%/build/cmake/android.toolchain.cmake" -DTARGET_BUILD_PLATFORM=android -DPXSHAREDSDK_PATH="%PM_PHYSXSDK_PATH%/pxshared" -DPHYSXSDK_PATH="%PM_PHYSXSDK_PATH%/physx"  -DBL_LIB_OUTPUT_DIR="%BLAST_ROOT_DIR%lib/ARM64" -DBL_OUTPUT_DIR="%BLAST_ROOT_DIR%bin/ARM64" -DANDROID_NDK=%PM_Android_NDK_PATH% -DCMAKE_MAKE_PROGRAM="%PM_Android_NDK_PATH%/prebuilt/windows-x86_64/bin/make.exe"

echo %CMAKE_CMD_LINE_PARAMS%

if not exist "%BLAST_ROOT_DIR%bin/ARM64" ( 
    mkdir "%BLAST_ROOT_DIR%/bin/ARM64"
)

if not exist "%BLAST_ROOT_DIR%lib/ARM64" (
    mkdir "%BLAST_ROOT_DIR%/lib/ARM64"
)


FOR %%Z IN (debug, release, checked, profile) DO (
    SET CMAKE_OUTPUT_DIR=%BLAST_ROOT_DIR%\compiler\arm64-%%Z\
    IF EXIST !CMAKE_OUTPUT_DIR! rmdir /S /Q !CMAKE_OUTPUT_DIR!
    mkdir !CMAKE_OUTPUT_DIR!
    pushd !CMAKE_OUTPUT_DIR!
    "%CMAKECMD%" %BLAST_ROOT_DIR% -DCMAKE_BUILD_TYPE=%%Z %CMAKE_CMD_LINE_PARAMS%
    popd
    if !ERRORLEVEL! NEQ 0 exit /b !ERRORLEVEL!
)


GOTO :End

:PM_PACKAGES_ROOT_UNDEFINED
ECHO PM_PACKAGES_ROOT has to be defined, pointing to the root of the dependency tree.
PAUSE
GOTO END

:ANDROID_NDK_UNDEFINED
ECHO "ANDROID NDK Undefined"
PAUSE
GOTO END

:DONT_RUN_STEP_2
ECHO Don't run this batch file directly. Run generate_projects_(platform).bat instead
PAUSE
GOTO END

:End
