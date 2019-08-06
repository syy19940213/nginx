#!/bin/bash

if [ -f /tmp/init.pid ]; then
    echo 'is running'
    exit 1
fi
touch /tmp/init.pid 

ip=$(curl http://ipinfo.io/ip) 

networkip=`echo ${ip%.*}.0` 

ddd=`yum install -y docker` 
echo $ddd

sleep 5

nohup service docker restart >/dev/null 2>&1 &

sleep 10
docker network create --subnet=$networkip/24 mynetwork 

mkdir -p /data/docker
cd /data/docker
curl -O https://raw.githubusercontent.com/syy19940213/nginx/master/Dockerfile
docker build -t nginx:v1 .

curl -O https://raw.githubusercontent.com/syy19940213/nginx/master/nginx.tar.gz
tar -xvf nginx.tar.gz 

cd /data/docker/nginx 
docker run -d -p 80:80 -p 443:443 -v $PWD/conf/nginx.conf:/etc/nginx/nginx.conf -v $PWD/logs:/var/log/nginx -v $PWD/conf/conf.d:/etc/nginx/conf.d -v $PWD/ssl:/ssl  -v /etc/localtime:/etc/localtime -v /etc/timezone:/etc/timezone:ro  -v $PWD/www:/www  --net mynetwork --ip $ip   --name mynginx  nginx:v1 
docker stop mynginx 

ip=$(curl http://ipinfo.io/ip) 
curl http://http://118.31.108.209:8999/server/initSuccess?ip=$ip 

rm -rf /tmp/init.pid 
echo "init success"
