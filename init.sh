#!/bin/bash

if [ -f /tmp/init.pid ]; then
    echo 'is running'
    exit 1
fi
touch /tmp/init.pid &&

ip=$(curl http://ipinfo.io/ip) &&

networkip=`echo ${ip%.*}.0`

yum install -y docker &&
service docker restart &&
docker pull nginx &&
docker network create --subnet=$networkip/16 mynetwork &&
mkdir -p /data/docker/nginx/logs &&
mkdir -p /data/docker/nginx/ssl &&
mkdir -p /data/docker/nginx/conf/conf.d &&
cd /data/docker/nginx/conf &&
wget https://github.com/syy19940213/nginx/raw/master/nginx.conf &&

cd /data/docker/nginx &&
docker run -d -p 80:80 -p 443:443 -v $PWD/conf/nginx.conf:/etc/nginx/nginx.conf -v $PWD/logs:/var/log/nginx -v $PWD/conf/conf.d:/etc/nginx/conf.d -v $PWD/ssl:/ssl   --name mynginx --net mynetwork --ip $ip nginx:latest &&
docker stop mynginx &&

ip=$(curl http://ipinfo.io/ip) &&
curl http://http://118.31.108.209:8999/server/initSuccess?ip=$ip &&

rm -rf /tmp/init.pid &&
echo "init success" 
