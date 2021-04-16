FROM centos:7.9.2009
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

ADD make_gopl-zh.sh /etc/cron.daily/

RUN \
    echo "Asia/shanghai" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    rm -f /etc/yum.repos.d/* && \
    echo "ip_resolve=4" >> /etc/yum.conf && \
    sed -e 's!enabled=1!enabled=0!g' -i /etc/yum/pluginconf.d/fastestmirror.conf && \
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo && \
    sed -e 's!gpgkey=http://mirrors.aliyun.com/centos!gpgkey=file:///etc/pki/rpm-gpg!g' \
        -e '/aliyuncs/d' \
        -i /etc/yum.repos.d/CentOS-Base.repo \
        -i /etc/yum.repos.d/epel.repo && \
    yum -y install net-tools iproute bind-utils telnet wget less jq && \
    rm -rf /var/cache/yum && \
    rm -f /root/*

RUN \
    yum -y install nginx git && \
    rm -rf /var/cache/yum && \
    bash /etc/cron.daily/make_gopl-zh.sh && \
    chmod +x /etc/cron.daily/make_gopl-zh.sh

CMD ["nginx", "-g", "daemon off;"]
