#!/bin/bash

touch /tmp/init.pid
yum install -y docker
service docker start
docker pull nginx
mkdir -p /data/docker/nginx/logs
mkdir -p /data/docker/nginx/ssl
mkdir -p /data/docker/nginx/conf/conf.d
cd /data/docker/nginx/conf
wget https://github.com/syy19940213/nginx/raw/master/nginx.conf

ip=$(curl http://ipinfo.io/ip)
curl http://168.63.143.99:8999/server/initSuccess?ip=$ip

rm -rf /tmp/init.pid
echo "init success"
