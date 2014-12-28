set ROOTDIR=%CD%
set LIBDIR=%1

echo "Amalgamating target dir: %LIBDIR%"

cd %LIBDIR%
mkdir tmp
move *.lib tmp

LIB.EXE /OUT:gameplay-deps.lib tmp\*

rmdir /s /q "tmp\"
cd %ROOTDIR%
