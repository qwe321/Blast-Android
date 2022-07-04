@ECHO OFF

SET ANDROID_NDK_PATH="G:\SDK\android-ndk-r21d"
SET MAKE_CMD="%ANDROID_NDK_PATH%/prebuilt/windows-x86_64/bin/make.exe"

echo "building release"
cd compiler\arm64-release
%MAKE_CMD% 
