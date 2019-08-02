#!/bin/bash

mkdir -p /data
cd /data
curl -O "https://raw.githubusercontent.com/syy19940213/nginx/master/filebeat.tar.gz"
tar -zxvf filebeat.tar.gz 
cd filebeat-7.2.0-linux-x86_64/
nohup ./filebeat >/dev/null 2>&1 &

