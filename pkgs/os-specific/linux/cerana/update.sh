#!/usr/bin/env nix-shell
#!nix-shell -i bash --pure -p curl gnugrep jq gnused nix

set -o xtrace
set -o errexit

HERE=$(cd $(dirname $0); pwd)

if [[ -n ${1} ]]; then
    HEAD=${1}
else
    HEAD=master
fi

REV=$(curl --cacert /etc/ssl/certs/ca-certificates.crt https://api.github.com/repos/cerana/cerana/git/refs/heads/${HEAD} | jq -r .object.sha)

sed -e "/rev/{s|\"[^\"]*\"|\"${REV}\"|}" -i ${HERE}/default.nix
sed -e "/sha256/{s|\"..........|\"1111111111|}" -i ${HERE}/default.nix

HASH=$(nix-build -A cerana-scripts ${HERE}/../../../../default.nix 2>&1 | grep hash | sed 's|.* hash ‘||;s|’ .*||')

[[ -n ${HASH} ]] \
    && sed -e "/sha256/{s|\"[^\"]*\"|\"${HASH}\"|}" -i ${HERE}/default.nix
