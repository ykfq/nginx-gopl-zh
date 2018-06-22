# Build docker image
```
docker build -t nginx-gopl-zh .
```
# Run docker container
```
docker run -itd --name nginx-gopl-zh -p 81:80 nginx-gopl-zh
```

# Build gopl-zh from source
```
bash make_gopl-zh.sh
```

# Access
```
http://ip:80

```



