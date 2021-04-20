# Things will be done
- Build nginx container that serve nginx-gopl-zh
- Build gopl-zh from source and mount `_book` to nginx container
- Add daily crontab settings

# Build docker image
```
docker-compose up --build -d
```

# Build gopl-zh from source for the first time
```
bash make_gopl-zh.sh
```

# Auto build gopl-zh daily
```
scp make_gopl-zh.sh /etc/cron.daily
chmod +x /etc/cron.daily
```
# Access
```
http://server_name:80

# server_name can be found in nginx/conf.d/gopl.conf
```

