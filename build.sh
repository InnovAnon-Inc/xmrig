#! /bin/bash
set -exo nounset

rm -rf build
mkdir build
cd build
cmake ..
