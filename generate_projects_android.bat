@echo off
:: Reset errorlevel status so we are not inheriting this state from the calling process:
@call :CLEAN_EXIT

:: Set the blast root to the current directory so that included solutions that aren't Blast know where the root is without having to
:: guess or hardcode a relative path.
:: Use the "short" path so that we don't have to quote paths in that calls below. If we don't do that spaces can break us.
SET BLAST_ROOT_DIR=%~sdp0

SET ANDROID_NDK_PATH=G:\SDK\android-ndk-r21d
SET PHYSXSDK_PATH=H:\workspace\lightness_physx4\Engine\Engine\Source\ThirdParty\PhysX4

SET ANDROID_DEPS_DIR=%BLAST_ROOT_DIR%android-deps
SET BOOSTMULTIPRECISION_PATH=%ANDROID_DEPS_DIR%\multiprecision-1.79
SET CMAKE_PATH=%ANDROID_DEPS_DIR%\cmake-3.7.0
SET CAPNPROTO_PATH=%ANDROID_DEPS_DIR%\CapnProto-0.6.1.4
SET CMAKE_MODULES_PATH=%ANDROID_DEPS_DIR%\CMakeModules-1.1.0

@call %~dp0buildtools\cmake_projects_android.bat
@if %ERRORLEVEL% neq 0 (
    @exit /b %errorlevel%
) else (
    @echo Success!
)

:CLEAN_EXIT
@exit /b 0