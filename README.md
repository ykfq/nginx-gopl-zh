# Things will be done
- Build a image of nginx that server nginx-gopl-zh
- Run a nginx-gopl-zh container
- Build gopl-zh from source (install go node.js gitbook etc.)
- Add crontab to build gopl-zh daily

# Build docker image
```
docker build -t nginx-gopl-zh .
```

# Run docker container
```
docker run -itd --name nginx-gopl-zh -p 80:80 nginx-gopl-zh
```

# Build gopl-zh from source for the first time
```
bash make_gopl-zh.sh
```

# Auto build gopl-zh daily
```
bash add_crontab.sh
```
# Access
```
http://ip:80

```



