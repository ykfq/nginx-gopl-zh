#!/bin/bash

BASEDIR=$(cd $(dirname $0)/../; pwd -P)
GOPL_DIR=${BASEDIR}/gopl-zh
GOPL_GIT=git@github.com:gopl-zh/gopl-zh.github.com.git

type -a node 2>/dev/null 1>&2
if [[ $? = 0 ]]; then
    echo "node.js exists, the version is:"
    node -v
else
    echo "node.js doesn't exist, install it now..."
    curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
    sudo yum -y install nodejs
    [[ $? = 0 ]] && echo "node.js has installed, the version is:"
    node -v
fi

echo
type -a gitbook 2>/dev/null 1>&2
if [[ $? = 0 ]]; then
    echo "gitbook exists, the version is:"
    gitbook -V
else
    echo "gitbook doesn't exist, install it now..."
    npm install gitbook-cli -g
    [[ $? = 0 ]] && echo "gitbook has installed, the version is:"
    gitbook -V
fi

echo
type -a go 2>/dev/null 1>&2
if [[ $? = 0 ]]; then
    echo "go exists, the version is:"
    go version
else
    echo "go doesn't exist, install it now..."
    echo "go-linux-amd64_v1.10.3 will be installed."
    curl -L -o go1.10.3.linux-amd64.tar.gz https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
    [[ $? != 0 ]] && echo "Download go binary failed." && exit 1
    tar -C /usr/local -xzf go1.10.3.linux-amd64.tar.gz
    echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
    source /etc/profile
    go version
    rm -f go1.10.3.linux-amd64.tar.gz
fi

echo
[[ -d ${GOPL_DIR} ]] && rm -rf ${GOPL_DIR}
mkdir ${GOPL_DIR} && cd $_
git clone ${GOPL_GIT}
if [[ $? != 0 ]]; then
    echo "git clone ${GOPL_GIT} failed, exit."
    exit 1
else
    echo
    cd ${GOPL_DIR}/gopl-zh.github.com
    gitbook install
    [[ $? != 0 ]] && echo "gitbook plugins for gopl-zh install failed." && exit 1
    yum -y groupinstall "Development Tools"
    make
    [[ $? != 0 ]] && echo "make failed." && exit 1
fi

echo
docker cp _book/ nginx-gopl-zh:/opt/
if [[ $? != 0 ]]; then
    echo "docker cp _book to nginx-gopl-zh:/opt/ failed."
    exit 1
else
    echo "docker cp succuessfully."
fi

