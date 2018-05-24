#! /bin/bash
set -exo nounset

[ -x build/xmrig ] || ./build.sh

sudo nice -n -20 \
	./xmrig --donate-level=1 \
	-u 43To46Y9AxNFkY5rsMQaLwbRNaxLZVvc4LJZt7Cx9Dt23frL6aut2uC3PsMiwGY5C5fKLSn6sWyoxRQTK1dhdBpKAX8bsUW \
	-p work01 -o us-backup.supportxmr.com
