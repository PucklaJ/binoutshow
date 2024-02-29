#! /bin/sh

set -ex
work_dir=$(pwd)
script_dir=$(dirname $0)

echo Building dynareadout ...
cd $script_dir/lib/dynareadout
./build.sh
cd $work_dir

echo Building binoutshow ...
odin build . -out:binoutshow -o:speed "-extra-linker-flags=-Llib/dynareadout/build/linux/x86_64/release"
