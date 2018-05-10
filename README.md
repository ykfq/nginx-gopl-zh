# Build docker image
```
docker build -t nginx-gopl-zh .
```
# run docker container
```
docker run -itd --name -p 80:80 nginx-gopl-zh nginx-gopl-zh
```

# Build gopl-zh from source
```
bash make_gopl-zh.sh
```

# Access
```
http://ip:80

```



