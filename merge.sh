#! /usr/bin/env bash
set -euxo nounset
(( $#   ))
(( $UID ))
[[ "$*" ]]
git add .
git commit -m "$*" || :
#git pull      origin
git branch    "$*"
git checkout  "$*"
git checkout  main
git merge     "$*"
git push origin HEAD:main

