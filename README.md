GamePlay-deps
=============
<img src="https://png.icons8.com/material/1600/mac-os.png" width=20 height=20><img src="https://png.icons8.com/metro/1600/linux.png" width=20 height=20> [![Build Status](https://travis-ci.org/louis-mclaughlin/GamePlay-deps.svg?branch=ci)](https://travis-ci.org/louis-mclaughlin/GamePlay-deps) <img src="https://png.icons8.com/material/1600/windows-logo.png" width=20 height=20> [![Build status](https://ci.appveyor.com/api/projects/status/s9k41xf016w6qbo0?svg=true)](https://ci.appveyor.com/project/louis-mclaughlin/gameplay-deps)

Open-source dependencies for GamePlay.

| Host     | Target Platform             | Target Arch                            
|----------|-----------------------------|----------------------------------------
| Windows  | windows                     | x86_64 (x64)
|          | android                     | arm (armeabi-v7a)
|          |                             | x86
| Linux    | linux                       | x86_64
|          | android                     | arm (armeabi-v7a)
|          |                             | x86
| MacOS    | macos                       | x86_64                                 
|          | ios                         | arm (armv7, armv7s, arm64) 
|          |                             | x86 (i386, x86_64)

Build outputs:

* Header ----->     out/external-deps/include
* Libraries -->     out/external-deps/lib/\<target platform\>/\<target arch\>

# Compiling (Host and Target are the same)

## Windows setup
* Install Visual Studio 2015 with Windows 10 platform SDK.
* Run 'VS2015 x64 Native Tools Command Prompt'.
* Builds x86_64 (x64) Debug and Release targets with the following commands:

```
> cd GamePlay-deps
> mkdir build
> cd build
> cmake -G "Visual Studio 14 Win64" ..
> msbuild GamePlay-deps.sln /property:Configuration=Debug
> msbuild GamePlay-deps.sln /property:Configuration=Release
```

## Linux setup
* Install CMake
```
sudo apt-get install cmake
```
* Install Build SDKs
```
sudo apt-get install build-essential clang gcc g++ curl
```
* Install Platform SDKs
```
sudo apt-get install libx11-xcb-dev libgtk2.0-dev libogg-dev libopenal-dev libtool libasound2-dev libpulse-dev libaudio-dev libx11-dev libxext-dev libxrandr-dev libxcursor-dev libxi-dev libxinerama-dev libxxf86vm-dev libxss-dev libgl1-mesa-dev libesd0-dev
```
* Run commands from terminal shell.
* Builds x86_64 Release target with the following commands:

```
$ cd GamePlay-deps
$ mkdir build
$ cd build
$ cmake ..
$ make install
```

## MacOS setup

* Install Xcode
* Run commands from terminal shell.
* Build x86_64 Release target with the following commands:

```
$ cd GamePlay-deps
$ mkdir build
$ cd build
$ cmake ..
$ make install
```

# Cross-Compiling (Host and Target are different)

## Android Setup

* Install NVIDIA CodeWorks for Android 1R7 (includes Android SDK and NDK)

https://developer.nvidia.com/codeworks-android

Installs to C:\NVPACK (Windows) or ~/NVPACK (Linux)

On Windows host:
* Install MinGW
https://sourceforge.net/projects/mingw/files/Installer/mingw-get-setup.exe/download

* Run following in MinGW shell:

On Linux host:
* Run following in terminal shell:

```
$ cd /path/to/NVPACK/android-ndk-r12b/build/tools
$ python make_standalone_toolchain.py --arch arm --api 24 --install-dir ~/android-toolchain-arm
$ cd GamePlay-deps
$ mkdir build
$ cd build
$ export ANDROID_STANDALONE_TOOLCHAIN=~/android-toolchain-arm
$ cmake -G"Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=../cmake/android.toolchain.cmake ..
$ make
```


## iOS Setup

* Install XCode
* Run from terminal shell.
* Builds arm target with the following commands:

```
$ cd GamePlay-deps
$ mkdir build
$ cd build
$ cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DIOS_PLATFORM=OS ..
$ make install
```

* Alternatively: Build simulator x86 target by changing the IOS_PLATFORM parameter:

` $ cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DIOS_PLATFORM=SIMULATOR .. `
