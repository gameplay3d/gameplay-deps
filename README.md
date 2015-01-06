GamePlay-deps
=============

External dependencies for GamePlay 3D framework.

We are using CMake to create a single, consistent way of compiling all the
libraries that GamePlay uses.  CMake with toolchain files are used to support
cross-compiling.

| Host     | Target Platform             | Target Arch                            
|----------|-----------------------------|----------------------------------------
| MacOSX   | macosx                      | x86_64                                 
|          | ios                         | arm (armv7, armv7s, arm64 combined) 
|          |                             | x86 (i386, x86_64 combined)
|          | android                     | armeabi-v7a
|          |                             | x86
| Linux    | linux                       | x86_64
|          | android                     | armeabi-v7a
|          |                             | x86
| Windows  | windows                     | x86_64


# Compiling (Host and Target are the same)

## Linux and MacOSX

For the simple case (not cross-compiling):

```
$ cd GamePlay-deps
$ mkdir build
$ cd build
$ cmake ..
$ make install
```

This will build all the libraries and place them into a new "out" directory
with the following structure:

* All public headers are copied to out/external-deps/include
* Libraries are built in out/external-deps/lib/\<target platform\>/\<target arch\>

When building for multiple targets, only one of those targets requires a "make
install".  The install step will copy the public headers, which are the same
regardless of the target.  So it's only needed once.

## Windows

For Windows, we generate Visual Studio project files.  It should be done from
within a Visual Studio command prompt.  You should also have the DirectX SDK
installed because OpenAL should use the DirectSound back-end.  We also build
both the Debug and Release variants.

```
> cd GamePlay-deps
> mkdir build
> cd build
> cmake -G"Visual Studio 12 Win64" ..
> msbuild GamePlay-deps.sln /property:Configuration=Debug
> msbuild GamePlay-deps.sln /property:Configuration=Release
```

# Cross-Compiling (Host and Target are different)

For cross-compiling we need a properly setup target SDK and we need to make use
of either cmake/ios.toolchain.cmake or cmake/android.toolchain.cmake

## iOS Setup

Install XCode 6.1

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

## Android Setup

Install the Android NDK (available here:
https://developer.android.com/tools/sdk/ndk/index.html).  Once installed you'll
need to setup a standalone toolchain directory for each of the architectures
you want to build.  To do that:

```
$ cd android-ndk-r10c
$ ./build/tools/make-standalone-toolchain.sh --platform=android-16 --arch=armeabi-v7a --install-dir=/path/to/android-arm
$ ./build/tools/make-standalone-toolchain.sh --platform=android-16 --arch=x86 --install-dir=/path/to/android-x86
```

This will install the standalone toolchain directories in 
/path/to/android-arm (for armeabi-v7a) and /path/to/android-x86 (for x86, usually simulator).

## Android Compiling

With the standalone toolchain directories in place, we can run cmake using the
android.toolchain.cmake.  For this toolchain file we set the
ANDROID_STANDALONE_TOOLCHAIN environment variable to the appropriate standalone
toolchain directory.  We do this prior to running cmake.

```
$ cd GamePlay-deps
$ mkdir build
$ export ANDROID_STANDALONE_TOOLCHAIN=/path/to/android-arm
$ cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/android.toolchain.cmake ..
$ make
```

For building the simulator version (or any other arch) just change the
environment variable:

` $ export ANDROID_STANDALONE_TOOLCHAIN=/path/to/android-x86 `

# Building Extra Libs

There's a set of additional libs that can be built by providing `cmake
-DBUILD_EXTRA_LIBS=1 ..` The extra libraries are for roadmap items, and so
these libs aren't needed for existing functionality.
