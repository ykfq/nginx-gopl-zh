FROM centos:7.5.1804

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ARG APP_VERSION=1.14.2-1.el7_4
ENV APP_VERSION=${APP_VERSION}

RUN \
    echo "Asia/shanghai" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    yum -y install epel-release net-tools iproute bind-utils telnet wget

RUN yum -y install https://nginx.org/packages/centos/7/x86_64/RPMS/nginx-${APP_VERSION}.ngx.x86_64.rpm && \
    rm -rf /var/cache/yum && \
    rm -rf /root/*

ADD conf/nginx.conf /etc/nginx/
ADD conf/conf.d/ /etc/nginx/conf.d/

EXPOSE 80

WORKDIR /root

#run squid when container created
CMD ["nginx", "-g", "daemon off;"]

