@echo off

echo Building dynareadout ...
pushd lib\dynareadout
call build.cmd
popd

echo Building binoutshow ...
odin build . -out:binoutshow.exe -o:speed "-extra-linker-flags=/libpath:lib\dynareadout\build\windows\x64\release"
