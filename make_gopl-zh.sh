#!/bin/bash

GOPL_DIR=/data/nginx-gopl/gopl-zh.github.com
GOPL_GIT=git@github.com:gopl-zh/gopl-zh.github.com.git

type -a node 2>/dev/null 1>&2
if [[ $? = 0 ]]; then
	echo "node.js exist, the version is:"
	node -v
else
    echo "node.js doesn't exist, install it now..."
    curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
    sudo yum -y install nodejs
    [[ $? = 0 ]] && echo "node.js has installed, the version is:"
	node -v
fi

type -a gitbook 2>/dev/null 1>&2
if [[ $? = 0 ]]; then
	echo "gitbook exist, the version is:"
	gitbook -V
else
    echo "gitbook doesn't exist, install it now..."
    npm install gitbook-cli -g
    [[ $? = 0 ]] && echo "gitbook has installed, the version is:"
	gitbook -V
fi

echo
[[ -d ${GOPL_DIR} ]] && rm -rf ${GOPL_DIR}

echo
cd /data/nginx-gopl
git clone ${GOPL_GIT}
if [[ $? != 0 ]]; then
    echo "git clone ${GOPL_GIT} failed, exit."
    exit 1
else
	echo
	cd ${GOPL_DIR}
	gitbook install
	[[ $? != 0 ]] && echo "gitbook plugins for gopl-zh install failed." && exit 1
	
	yum -y groupinstall "Development Tools"
    make
	[[ $? != 0 ]] && echo "make failed." && exit 1
fi

docker cp _book/ nginx-gopl-zh:/opt/
[[ $? != 0 ]] && echo "docker cp _book to nginx-gopl-zh:/opt/ failed." && exit 1

