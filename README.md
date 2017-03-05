GamePlay-deps
=============

Open-source dependencies for GamePlay.

| Host     | Target Platform             | Target Arch                            
|----------|-----------------------------|----------------------------------------
| Windows  | windows                     | x86_64
| Linux    | linux                       | x86_64
|          | android                     | armeabi-v7a
|          |                             | x86
| MacOS    | macos                       | x86_64                                 
|          | ios                         | arm (armv7, armv7s, arm64 combined) 
|          |                             | x86 (i386, x86_64 combined)
|          | android                     | armeabi-v7a
|          |                             | x86


# Compiling (Host and Target are the same)

## Windows

Generates Visual Studio project files. 
Run commands from Visual Studio 2015 x64 command prompt. 
Builds x86_64(x64) Debug and Release. 

```
> cd GamePlay-deps
> mkdir build
> cd build
> cmake -G "Visual Studio 14 Win64" ..
> msbuild GamePlay-deps.sln /property:Configuration=Debug
> msbuild GamePlay-deps.sln /property:Configuration=Release
```


## Linux and MacOS

Generates makefile project files.
Run commands from Terminal console.
Builds x86_64(x64) Release. 

```
$ cd GamePlay-deps
$ mkdir build
$ cd build
$ cmake ..
$ make install
```

Build outputs

* Header ----->     out/external-deps/include
* Libraries -->     out/external-deps/lib/\<target platform\>/\<target arch\>

# Cross-Compiling (Host and Target are different)

For cross-compiling we need a properly setup target SDK and we need to make use
of either cmake/android.toolchain.cmake or cmake/ios.toolchain.cmake

## Android Setup

Install the Android NDK r12e (available here:
https://developer.android.com/tools/sdk/ndk/index.html).  Once installed you'll
need to setup a standalone toolchain directory for each of the architectures
you want to build.  To do that:

```
$ cd android-ndk-r12e
$ ./build/tools/make-standalone-toolchain.sh --platform=android-16 --arch=arm --install-dir=/path/to/android-toolchain-arm
$ ./build/tools/make-standalone-toolchain.sh --platform=android-16 --arch=x86 --install-dir=/path/to/android-toolchain-x86
```

This will install the standalone toolchain directories in 
/path/to/android-toolchain-arm (for armeabi-v7a) and /path/to/android-toolchain-x86 (for x86, usually simulator).

## Android Compiling

With the standalone toolchain directories in place, we can run cmake using the
android.toolchain.cmake.  For this toolchain file we set the
ANDROID_STANDALONE_TOOLCHAIN environment variable to the appropriate standalone
toolchain directory.  We do this prior to running cmake.

```
$ cd GamePlay-deps
$ mkdir build
$ cd build
$ export ANDROID_STANDALONE_TOOLCHAIN=/path/to/android-toolchain-arm
$ cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/android.toolchain.cmake ..
$ make
```

For building the simulator version (or any other arch) just change the
environment variable:

` $ export ANDROID_STANDALONE_TOOLCHAIN=/path/to/android-toolchain-x86 `


## iOS Setup

Install XCode

## iOS Compiling

For arm architecture:

```
$ cd GamePlay-deps
$ mkdir build
$ cd build
$ cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DIOS_PLATFORM=OS ..
$ make install
```

For x86 we change the IOS_PLATFORM flag:

` $ cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DIOS_PLATFORM=SIMULATOR .. `
