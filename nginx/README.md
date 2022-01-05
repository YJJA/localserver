# Nginx Docker Commond

```sh
export NGINX_HOME=$HOME/localserver/nginx

docker run \
  --name nginx \
  --network nginx-proxy \
  -p 80:80 \
  -v $NGINX_HOME/nginx.conf:/etc/nginx/nginx.conf \
  -v $NGINX_HOME/conf.d:/etc/nginx/conf.d \
  -v $NGINX_HOME/log:/var/log/nginx \
  -d nginx
```

## Nginx Conf

https://www.nginx.com/resources/wiki/start/topics/examples/full/#nginx-conf
