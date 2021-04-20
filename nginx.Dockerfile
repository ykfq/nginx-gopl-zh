FROM ykfq/base-centos:7.9.2009

USER root

RUN \
    yum -y install nginx && \
    rm -rf /var/cache/yum
WORKDIR root

CMD ["nginx", "-g", "daemon off;"]


