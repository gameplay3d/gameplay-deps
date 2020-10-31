##############################################################################
# Packaging script for building and packaging gameplay-deps-<platform>.zip 
##############################################################################
import os
import glob
import platform
import subprocess
import shutil
import sys
import time
import zipfile
from pathlib import Path

# constants
##############################################################################

CMAKE_WINDOWS_GENERATOR = "Visual Studio 16 2019"
CMAKE_UNIX_GENERATOR = "Unix Makefiles"

BUILD_FOLDER = "_build"
PACKAGE_FOLDER = "_package"
DEPS_FOLDER = "_deps"


# function utils
##############################################################################

def clear_dir(dir_path):
    if os.path.exists(dir_path):
        shutil.rmtree(dir_path, ignore_errors=True)
    path = Path(dir_path)
    path.mkdir(parents=True)

def init_vsvars():
    vswhere_path = r"%ProgramFiles(x86)%/Microsoft Visual Studio/Installer/vswhere.exe"
    vswhere_path = os.path.expandvars(vswhere_path)
    if not os.path.exists(vswhere_path):
        raise EnvironmentError("vswhere.exe not found at: %s", vswhere_path)
    vs_path = os.popen('"{}" -latest -property installationPath'.format(vswhere_path)).read().rstrip()
    vsvars_path = os.path.join(vs_path, "VC\\Auxiliary\\Build\\vcvars64.bat")
    output = os.popen('"{}" && set'.format(vsvars_path)).read()
    for line in output.splitlines():
        pair = line.split("=", 1)
        if(len(pair) >= 2):
            os.environ[pair[0]] = pair[1]

def cmake_generator_args():
    if sys.platform == "win32":
        return f"-G \"{CMAKE_WINDOWS_GENERATOR}\""
    else:
        return f"-G \"{CMAKE_UNIX_GENERATOR}\""

def cmake_build(folder, generator_args, solution, **kwargs):
    project_dir = os.getcwd() + os.path.sep + folder
    build_dir = project_dir + os.path.sep + BUILD_FOLDER
    clear_dir(build_dir)
    cmake_proc = subprocess.Popen(f"cmake {generator_args} ..", cwd=build_dir)
    cmake_proc.wait()
    caller_dir = os.getcwd()
    os.chdir(build_dir)
    if sys.platform == "win32":
        init_vsvars()
        cmd = f"msbuild {solution}.sln /property:Configuration=Debug"
        subprocess.run(cmd)
        cmd = f"msbuild {solution}.sln /property:Configuration=Release"
        subprocess.run(cmd)
    else:
        pass
    os.chdir(caller_dir)

def copy_files(src_dir, dst_dir, match_exp):
    clear_dir(dst_dir)
    for filename in glob.glob(os.path.join(src_dir, match_exp)):
        shutil.copy(filename, dst_dir)

def create_package(src_dir, dst_file):
    package = zipfile.ZipFile(dst_file, 'w', zipfile.ZIP_DEFLATED)
    for root, dirs, files in os.walk(src_dir):
        for file in files:
            full_path = os.path.join(root, file)
            package.write(full_path, os.path.relpath(full_path, src_dir))
    package.close()


# package output locations
##############################################################################

# package dest.
package_dir = os.getcwd() + os.path.sep + PACKAGE_FOLDER
clear_dir(package_dir)

# package bin dirs
package_windows_bin_dir = package_dir + os.path.sep + "windows-x86_64"
package_linux_bin_dir = package_dir + os.path.sep + "linux-x86_64"
package_macos_bin_dir = package_dir + os.path.sep + "macos-x86_64"

# glfw
##############################################################################
dep_folder = "glfw-3.3.2"
print(f"Preparing {dep_folder}...")
cmake_build(dep_folder, cmake_generator_args(), "GLFW")
src_dir = dep_folder + os.path.sep + "include" + os.path.sep + "GLFW"
dst_dir = package_dir + os.path.sep + "include" + os.path.sep + "glfw"
copy_files(src_dir, dst_dir, "*.*")
if sys.platform == "win32":
    src_dir = dep_folder + os.path.sep + BUILD_FOLDER + os.path.sep + "src" + os.path.sep + "Debug"
    dst_dir = package_windows_bin_dir + os.path.sep + "debug"
    copy_files(src_dir, dst_dir, "*.*")
    src_dir = dep_folder + os.path.sep + BUILD_FOLDER + os.path.sep + "src" + os.path.sep + "Release"
    dst_dir = package_windows_bin_dir + os.path.sep + "release"
    copy_files(src_dir, dst_dir, "*.*")
elif sys.platform == "darwin":
    pass
else:
    pass

# glm
##############################################################################
dep_folder = "glm-0.9.9.8"
print(f"Preparing {dep_folder}...")
src_dir = dep_folder + os.path.sep + "glm"
dst_dir = package_dir + os.path.sep + "include" + os.path.sep + "glm"
shutil.copytree(src_dir, dst_dir, ignore=shutil.ignore_patterns('*.txt'))

# deps zip file
#############################################################################3
zip_dir = DEPS_FOLDER
clear_dir(zip_dir)

zip_filename = ""
if sys.platform == "win32":
    zip_filename = "gameplay-deps-windows.zip"
elif sys.platform == "darwin":
    zip_filename = "gameplay-deps-macos.zip"
else:
    zip_filename = "gameplay-deps-macos.zip"

print(f"Packaging {zip_filename}...")
create_package(package_dir, os.path.join(zip_dir, zip_filename))
