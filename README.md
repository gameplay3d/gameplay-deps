GamePlay-deps
=============

External dependencies for GamePlay 3D framework.

We are using CMake to create a single, consistent way of compiling all the
libraries that GamePlay uses.  CMake with toolchain files are used to support
cross-compiling.

| Host     | Target Platform             | Target Arch                            |
|----------|-----------------------------|----------------------------------------|
| MacOSX   | Darwin                      | x86_64                                 |
|          | iOS                         | arm (armv7, armv7s, arm64 as fat libs) |
|          |                             | x86 (i386, x86_64 as fat libs)         |
|          | Android                     | armeabi-v7a                            |
|          |                             | x86 (simulator)                        | 
| Linux    | Linux                       | x86_64                                 |
|          | Android                     | armeabi-v7a                            |
|          |                             | x86 (simulator)                        |
| Windows  | Windows                     | x86_64                                 |


# Compiling (Host and Target are the same)

## Linux and Mac

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
* Libraries are built in out/external-deps/targets/\<target platform\>/\<target arch\>

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

Install XCode 5.1

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

This will install the standalone toolchain directories in /path/to/android-arm
for armeabi-v7a and /path/to/android-x86 for x86 (usually for the simulator).

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

# Creating a Single Lib

To prevent having everyone constantly update their linker flags, everything
gets amalgamated into a single static lib.  One for each platform/arch
combination.

For GNU-based toolchains, you need to provide a path to "ar", and the target
directory containing all the .a files:

```
$ cd GamePlay-deps
$ ./cmake/gnu-amalgamate.sh /usr/bin/ar ./out/external-deps/targets/Linux/x86_64
```

The result will be a libgameplay-deps.a file created in the target directory
and all .a files removed.

The path to "ar" is necessary to support cross-compiling toolchains.  You will
want to use the appropriate "ar" for the target you want to amalgamate.

On Mac, use mac-amalgamate.sh along with a target directory:

```
$ cd GamePlay-deps
$ ./cmake/mac-amalgamate.sh ./out/external-deps/targets/Darwin/x86_64
```

The mac-amalgamate.sh is good for Darwin as well as iOS cross-compiling.  The
Mac version makes use of libtool.  It also works fine for amalgamating fat
libraries.

Windows also has its own msvc-amalgamate.bat which uses LIB.EXE.  It is Windows
only, and can't be used for any other targets.  Should be executed from the
GamePlay-deps root directory after both Release and Debug builds.

# Building Extra Libs

There's a set of additional libs that can be built by providing `cmake
-DBUILD_EXTRA_LIBS=1 ..` The extra libraries are for roadmap items, and so
these libs aren't needed for existing functionality.
