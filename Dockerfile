FROM centos:7.4.1708

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ARG APP_VERSION=1.12.2
ENV APP_VERSION=${APP_VERSION}

RUN \
    echo "Asia/shanghai" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    yum -y install epel-release net-tools iproute bind-utils telnet wget

RUN yum -y install nginx-${APP_VERSION} && \
    rm -rf /var/cache/yum && \
    rm -rf /root/*

ADD conf/nginx.conf /etc/nginx/
ADD conf/conf.d/ /etc/nginx/conf.d/
ADD conf/conf.d.stream /etc/nginx/conf.d.stream/

EXPOSE 80

WORKDIR /root

#run squid when container created
CMD ["nginx", "-g", "daemon off;"]

