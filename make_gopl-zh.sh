#!/bin/bash

BASEDIR=$(cd $(dirname $0)/; pwd -P)
GOPL_DIR=${BASEDIR}/gopl-zh
GOPL_GIT=https://github.com/gopl-zh/gopl-zh.github.com.git

source /etc/profile
type -a node 2>/dev/null 1>&2
if [[ $? = 0 ]]; then
  echo "[Info] node.js exists, the version is:"
  node -v
else
  echo "[Info] node.js doesn't exist, install it now..."
  curl --silent --location https://rpm.nodesource.com/setup_10.x | bash -
  yum -y install nodejs
  [[ $? = 0 ]] && echo "[Info] node.js has been installed, the version is:"
  node -v
fi

echo
type -a gitbook 2>/dev/null 1>&2
if [[ $? = 0 ]]; then
  echo "[Info] gitbook exists, the version is:"
  gitbook -V
else
  echo "[Info] gitbook doesn't exist, install it now."
  npm install gitbook-cli -g
  [[ $? = 0 ]] && echo "[Info] gitbook has installed, the version is:"
  gitbook -V
fi

echo
type -a go 2>/dev/null 1>&2
if [[ $? = 0 ]]; then
  echo "[Info] go exists, the version is:"
  go version
else
  echo "[Info] go doesn't exist, install it now..."
  while read -p "Input the go version that will be installed: " GO_VERSION; do
    if [[ x"${GO_VERSION}" == "x" ]]; then
      echo "[Info] go version not specified, using default ${GO_VERSION}"
    else
      curl --output /dev/null --silent --head --fail https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz
      [[ $? != 0 ]] && echo "[Warn] Version ${GO_VERSION} not found. See https://github.com/golang/go/releases and input it again"
      continue
    fi
      echo "[Info] Got version ${GO_VERSION}, downloading..."
    break
  done

  GO_VERSION="1.14.15"
  curl -SL -o go${GO_VERSION}.linux-amd64.tar.gz https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz
  [[ $? != 0 ]] && echo "[Error] Download go binary failed." && exit 1
  tar -C /usr/local -xf go${GO_VERSION}.linux-amd64.tar.gz
  echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
  source /etc/profile
  echo "[Info] go installed succuessfully, the version is:"
  go version
  rm -f go${GO_VERSION}.linux-amd64.tar.gz
fi

echo
[[ -d ${GOPL_DIR} ]] && rm -rf ${GOPL_DIR}
mkdir ${GOPL_DIR} && cd $_
git clone ${GOPL_GIT}
if [[ $? != 0 ]]; then
    echo "[Error] git clone ${GOPL_GIT} failed, exit."
    exit 1
else
  echo
  cd ${GOPL_DIR}/gopl-zh.github.com
  gitbook install
  [[ $? != 0 ]] && echo "[Error] gitbook plugins for gopl-zh install failed." && exit 1
  yum -y groupinstall "Development Tools"
  export PATH=$PATH:/usr/local/go/bin
  make
  [[ $? != 0 ]] && echo "[Error] make gopl-zh failed." && exit 1
  mv ${GOPL_DIR}/gopl-zh.github.com/_book /opt/gopl-zh
fi
