@echo off
SetLocal EnableDelayedExpansion
echo #############################################################################################
echo Starting %~n0 %date% %time%
echo #############################################################################################

IF NOT DEFINED ANDROID_NDK_PATH GOTO ANDROID_NDK_UNDEFINED

REM Now set up the CMake command
SET CMAKECMD=%CMAKE_PATH%\bin\cmake.exe

echo Cmake: %CMAKECMD%

REM Generate projects here

SET CMAKE_CMD_LINE_PARAMS=-G "MinGW Makefiles" -DANDROID_STL="c++_static" -DANDROID_ABI="arm64-v8a" -DANDROID_NATIVE_API_LEVEL="android-19" -DCM_ANDROID_FP="softfp" -DCMAKE_TOOLCHAIN_FILE="%ANDROID_NDK_PATH%/build/cmake/android.toolchain.cmake" -DTARGET_BUILD_PLATFORM=android -DPXSHAREDSDK_PATH="%PHYSXSDK_PATH%/pxshared" -DPHYSXSDK_PATH="%PHYSXSDK_PATH%/physx" -DBOOSTMULTIPRECISION_PATH="%BOOSTMULTIPRECISION_PATH%" -DPM_CapnProto_PATH="%CAPNPROTO_PATH%" -DBL_LIB_OUTPUT_DIR="%BLAST_ROOT_DIR%lib/ARM64" -DBL_OUTPUT_DIR="%BLAST_ROOT_DIR%bin/ARM64" -DANDROID_NDK=%ANDROID_NDK_PATH% -DCMAKE_MAKE_PROGRAM="%ANDROID_NDK_PATH%/prebuilt/windows-x86_64/bin/make.exe"

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
    call "%CMAKECMD%" %BLAST_ROOT_DIR% -DCMAKE_BUILD_TYPE=%%Z %CMAKE_CMD_LINE_PARAMS%
    popd
    if !ERRORLEVEL! NEQ 0 exit /b !ERRORLEVEL!
)


GOTO :End

:ANDROID_NDK_UNDEFINED
ECHO "ANDROID NDK Undefined"
PAUSE
GOTO END

:End
