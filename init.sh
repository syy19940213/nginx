#!/bin/bash
yum install -y docker
service docker start
docker pull nginx
mkdir -p /data/docker/nginx/logs
mkdir -p /data/docker/nginx/ssl
mkdir -p /data/docker/nginx/conf/conf.d
cd /data/docker/nginx/conf
wget https://github.com/syy19940213/nginx/raw/master/nginx.conf

echo "init success"
