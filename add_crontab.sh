#!/usr/bin/env bash
/bin/cp -f build_gopl_daily.sh /usr/bin/

sed -i '/build_gopl_daily.sh*/d' /etc/crontab 2>&1
echo "0 2 * * * root /bin/bash /usr/bin/build_gopl_daily.sh >> /var/log/gopl-zh_build.log 2>&1" >> /etc/crontab

systemctl restart crond
