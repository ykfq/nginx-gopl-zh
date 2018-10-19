#!/usr/bin/env bash
/bin/cp -f build_gopl.sh /usr/bin/

sed -i '/build_gopl.sh*/d' /etc/crontab 2>&1
echo "0 2 * * * root /bin/bash /usr/bin/build_gopl.sh >> /var/log/gopl-zh_build.log 2>&1" >> /etc/crontab

systemctl restart crond
