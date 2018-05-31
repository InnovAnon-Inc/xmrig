#! /bin/bash
set -exo nounset

[ -x build/xmrig ] || ./build.sh

sudo nice -n -20 \
	build/xmrig --donate-level=0 \
	--config=./laptop.json
