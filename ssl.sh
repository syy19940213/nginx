#!/bin/bash

DOMAIN=''
for args in $@
do
   case $args in
	--domain=*)
          DOMAIN=`echo $args | awk -F "=" '{print $NF}'`
   esac
done

if [ "$DOMAIN" = '' ]; then
    echo 'pleas use --domain to set domain'
fi


mkdir -p /data/docker/nginx/ssl/
cd /data/docker/nginx/ssl/
wget https://github.com/certbot/certbot/archive/master.zip
unzip master.zip 
cd certbot-master/
./certbot-auto certonly --standalone --email 137688788@qq.com  -d $DOMAIN --non-interactive --agree-tos

