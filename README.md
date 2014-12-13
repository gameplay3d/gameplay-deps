GamePlay-deps
=============

External dependencies for GamePlay 3D framework.

We are using CMake to create a single, consistent way of compiling all the
libraries that GamePlay uses.  CMake with toolchain files are used to support
cross-compiling.

| Host     | Target Platform             | Target Arch                   |
|----------|-----------------------------|-------------------------------|
| MacOSX   | Darwin                      | x86_64                        |
|          | iOS                         | arm (armv6, armv7 as fat libs)|
|          |                             | x86 (simulator)               |
|          | Android                     | armeabi-v7a                   |
|          |                             | x86 (simulator)               |
| Linux    | Linux                       | x86_64                        |
|          | Android                     | armeabi-v7a                   |
|          |                             | x86 (simulator)               |
| Windows  | Windows                     | x86_64                        |


# Compiling (Host and Target are the same)

## Not Windows

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
* Libraries are built in out/external-deps/targets/<target platform>/<target arch>

When building for multiple targets, only one of those targets requires a "make
install".  The install step will copy the public headers, which are the same
regardless of the target.  So it's only needed once.

## Windows

For Windows, we generate Visual Studio project files:

```
> cd GamePlay-deps
> mkdir build
> cd build
> cmake -G"Visual Studio 12 Win64" ..
> start ALL_BUILD.vcxproj
```

Switch the active configuration to "Release".  Then build the solution.

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
$ ./build/tools/make-standalone-toolchain.sh --platform=android-16 --arch=x86_64 --install-dir=/path/to/android-x86_64
```

This will install the standalone toolchain directories in /path/to/android-arm
for armeabi-v7a and /path/to/android-x86_64 for x86_64 (usually for the
simulator).

## Android Compiling

With the standalone toolchain directories in place, we can run cmake using the
android.toolchain.cmake.  For this toolchain file we set the ANDROID_NDK
environment variable to the appropriate standalone toolchain directory.  We do
this prior to running cmake.

```
$ cd GamePlay-deps
$ mkdir build
$ export ANDROID_NDK=/path/to/android-arm
$ cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/android.toolchain.cmake ..
$ make
```

For building the simulator version (or any other arch) just change the
environment variable:

` $ export ANDROID_NDK=/path/to/android-x86_64 `
