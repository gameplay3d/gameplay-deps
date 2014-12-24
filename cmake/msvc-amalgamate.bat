set ROOTDIR=%CD%

pushd out\external-deps\targets\Windows\x86_64\Debug
mkdir tmp
move *.lib tmp

LIB.EXE /OUT:gameplay-deps.lib tmp\BulletCollision.lib tmp\BulletDynamics.lib tmp\GLEW.lib tmp\LinearMath.lib tmp\lua.lib tmp\ogg.lib tmp\OpenAL32.lib tmp\png.lib tmp\tinyxml2.lib tmp\vorbis.lib tmp\vorbisenc.lib tmp\vorbisfile.lib tmp\z.lib

rmdir /s /q "tmp\"
popd

pushd out\external-deps\targets\Windows\x86_64\Release
mkdir tmp
move *.lib tmp

LIB.EXE /OUT:gameplay-deps.lib tmp\BulletCollision.lib tmp\BulletDynamics.lib tmp\GLEW.lib tmp\LinearMath.lib tmp\lua.lib tmp\ogg.lib tmp\OpenAL32.lib tmp\png.lib tmp\tinyxml2.lib tmp\vorbis.lib tmp\vorbisenc.lib tmp\vorbisfile.lib tmp\z.lib

rmdir /s /q "tmp\"
popd
