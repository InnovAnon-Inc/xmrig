#! /bin/bash
#! /usr/bin/env bash
set -euxo pipefail
(( ! UID )) # TODO ?
(( ! $# ))

pgrep xmrig
#curl --fail http://localhost:4048 || exit 1
nmap -p 4048 localhost | grep '^4048/tcp *open'
