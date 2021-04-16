#!/bin/bash

#BASEDIR=$(cd $(dirname $0)/../; pwd -P)
GOPL_DIR=/tmp/gopl-zh
GOPL_GIT=https://github.com/gopl-zh/gopl-zh.github.com.git

export PATH=$PATH:/usr/local/go/bin

echo
[[ -d ${GOPL_DIR} ]] && rm -rf ${GOPL_DIR}
mkdir ${GOPL_DIR} && cd $_
git clone ${GOPL_GIT}
if [[ $? != 0 ]]; then
    echo "git clone ${GOPL_GIT} failed, exit."
    exit 1
else
    cd ${GOPL_DIR}/gopl-zh.github.com
    gitbook install
    [[ $? != 0 ]] && echo "gitbook plugins for gopl-zh install failed." && exit 1
    make
    [[ $? != 0 ]] && echo "make failed." && exit 1
fi
