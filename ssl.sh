#!/bin/bash
if [ -f /tmp/ssl.pid ]; then
    echo 'is running'
    exit 1
fi
touch /tmp/ssl.pid

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
    rm -rf /tmp/ssl.pid
    exit 1
fi

yum install -y unzip zip &&
mkdir -p /data/docker/nginx/ssl/ &&
cd /data/docker/nginx/ssl/ &&
if [ ! -d /data/docker/nginx/ssl/certbot-master ]; then
     wget https://github.com/certbot/certbot/archive/master.zip &&
     unzip master.zip  
fi

cd certbot-master/ &&
./certbot-auto certonly --standalone --email 137688788@qq.com  -d $DOMAIN --non-interactive --agree-tos &&

mkdir -p /data/docker/nginx/ssl/$DOMAIN &&
cp /etc/letsencrypt/archive/$DOMAIN/fullchain1.pem /data/docker/nginx/ssl/$DOMAIN &&
cp /etc/letsencrypt/archive/$DOMAIN/privkey1.pem /data/docker/nginx/ssl/$DOMAIN &&
cd /data/docker/nginx/ssl/$DOMAIN &&
mv privkey1.pem privkey.pem &&
mv fullchain1.pem fullchain.pem &&
chmod 777 privkey.pem &&
chmod 777 fullchain.pem &&


ip=$(curl http://ipinfo.io/ip) &&
log=`tail -n 10 /var/log/letsencrypt/letsencrypt.log | grep 'Your certificate and chain have been saved'` &&
if [ "$log" == "" ] ; then
	curl http://118.31.108.209:8999/server/initSsl?ip=$ip&status=2
	echo "init error"
else
	curl http://118.31.108.209:8999/server/initSsl?ip=$ip&status=1
	echo "init success"
fi

rm -rf /tmp/ssl.pid

