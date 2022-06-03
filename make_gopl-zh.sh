#!/bin/bash

BASEDIR=$(cd $(dirname $0)/; pwd -P)
GOPL_DIR=${BASEDIR}/gopl-zh
GOPL_DIR_TMP=/tmp/gopl-zh
GOPL_GIT=https://github.com/gopl-zh/gopl-zh.github.com.git

source /etc/profile
export PATH=$PATH:/usr/local/go/bin

echo
type -a jq 2>/dev/null 1>&2
if [[ $? = 0 ]]; then
  echo "[Info] jq exists, the version is:"
  jq --version
else
  echo "[Info] jq doesn't exist, install it now."
  yum -y install jq
  [[ $? = 0 ]] && echo "[Info] jq has installed, the version is:"
  jq --version
fi

echo
version=20.10.14-3
type -a docker 2>/dev/null 1>&2
if [[ $? = 0 ]]; then
  echo "[Info] docker-ce exists, the version is:"
  docker -v
else
  echo "[Info] docker-ce doesn't exist, install it now..."
  yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

  curl -o /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo
  yum -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
  if [[ $? = 0 ]]; then
    echo "[Info] docker-ce has been installed, the version is:"
    docker -v
    echo "[Info] start docker now"
    mkdir -p /etc/docker/
    echo '{"bip":"10.0.254.1/20"}' | tee -a /etc/docker/daemon.json
    systemctl enable --now docker
  else
    echo "[Error] docker-ce install failed, exit"
    exit 1
  fi
fi

echo
version=1.29.2
type -a docker-compose 2>/dev/null 1>&2
if [[ $? = 0 ]]; then
  echo "[Info] docker-compose exists, the version is:"
  docker-compose -v
else
  echo "[Info] docker-compose doesn't exist, install it now..."
  curl -SL https://github.com/docker/compose/releases/download/${version}/docker-compose-Linux-x86_64 -o /usr/bin/docker-compose
  chmod +x /usr/bin/docker-compose
fi

echo
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

if [[ -d "${GOPL_DIR_TMP}/gopl-zh.github.com" ]]; then
    cd ${GOPL_DIR_TMP}/gopl-zh.github.com && git pull
else
    git clone ${GOPL_GIT} ${GOPL_DIR_TMP}/gopl-zh.github.com
fi

echo
if [[ -d "${GOPL_DIR_TMP}/gopl-zh.github.com" ]]; then
  cd ${GOPL_DIR_TMP}/gopl-zh.github.com
  gitbook install
  [[ $? != 0 ]] && echo "[Error] gitbook plugins for gopl-zh install failed." && exit 1
  #yum -y groupinstall "Development Tools"
  yum -y install gcc automake autoconf libtool make
  make
  [[ $? != 0 ]] && echo "[Error] make gopl-zh failed." && exit 1
  rm -rf ${GOPL_DIR}
  mkdir -p ${GOPL_DIR}
  mv ${GOPL_DIR_TMP}/gopl-zh.github.com/_book ${GOPL_DIR}/gopl-zh
fi

