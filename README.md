GamePlay-deps
=============

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
* Install dev tools
```
sudo apt-get install build-essential gcc cmake libopenal-dev libgtk2.0-dev curl libpcrecpp0:i386 lib32z1-dev
```
* Run commands from terminal console.
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
* Run commands from terminal console.
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

* Install NVIDIA CodeWorks for Android 1R6 (includes Android SDK and NDK):

https://developer.nvidia.com/codeworks-android

This installs to C:\NVPACK on Windows or ~\NVPACK (Linux)

On Windows host:
* Run following in 'VS2015 x64 Native Tools Command Prompt':

```
> cd C:\NVPACK\android-ndk-r12b/build/tools
> python make_standalone_toolchain.py --arch arm --api 24 --install-dir C:\android-toolchain-arm
> cd GamePlay-deps
> mkdir build
> cd build
> set ANDROID_STANDALONE_TOOLCHAIN=C:\android-toolchain-arm
> cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/android.toolchain.cmake ..
> msbuild GamePlay-deps.sln /property:Configuration=Release
```

On Linux host:
* Run following in terminal console:

```
$ cd ~/NVPACK/android-ndk-r12b/build/tools
$ python make_standalone_toolchain.py --arch arm --api 24 --install-dir ~/android-toolchain-arm
$ cd GamePlay-deps
$ mkdir build
$ cd build
$ export ANDROID_STANDALONE_TOOLCHAIN=~/android-toolchain-arm
$ cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/android.toolchain.cmake ..
$ make
```

## iOS Setup

* Install XCode
* Run from terminal console.
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
