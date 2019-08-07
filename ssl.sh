#!/bin/bash
if [ -f /tmp/ssl.pid ]; then
    echo 'is running'
    exit 1
fi
touch /tmp/ssl.pid
DIRNAME=''
DOMAIN=''
domains=''
firstdomain=''
i=0
for args in $@
do
   case $args in
        --domain=*)
	  if [ "$firstdomain" = '' ]; then
	  	firstdomain=${args#*=}
	  fi
          DOMAIN=${args#*=}
          domains=$domains' -d '$DOMAIN
        ;;
	--dirname=*)
	  DIRNAME=${args#*=}
	;;
   esac
done
echo $domains

if [ "$domains" = '' ]; then
    echo 'pleas use --domain to set domain'
    rm -rf /tmp/ssl.pid
    exit 1
fi

if [ "$DIRNAME" = '' ]; then
    echo 'pleas use --dirname to set dirname'
    rm -rf /tmp/ssl.pid
    exit 1
fi


ddd=`yum install -y unzip zip`
echo $ddd
mkdir -p /data/docker/nginx/ssl/ 
mkdir -p /data/docker/nginx/www
cd /data/docker/nginx/ssl/ 
if [ ! -d /data/docker/nginx/ssl/certbot-master ]; then
     echo 'exec wget'
     curl -O "https://raw.githubusercontent.com/syy19940213/nginx/master/master.zip"
     sleep 10
     echo 'unzip file'
     unzip master.zip  
fi

cd certbot-master/ 
./certbot-auto certonly --text  --webroot -w /data/docker/nginx/www  --email 137688788@qq.com  $domains --non-interactive --agree-tos

mkdir -p /data/docker/nginx/ssl/$DIRNAME 
cp /etc/letsencrypt/archive/$firstdomain/fullchain1.pem /data/docker/nginx/ssl/$DIRNAME 
cp /etc/letsencrypt/archive/$firstdomain/privkey1.pem /data/docker/nginx/ssl/$DIRNAME 
cd /data/docker/nginx/ssl/$DIRNAME 
mv privkey1.pem privkey.pem 
mv fullchain1.pem fullchain.pem 
chmod 777 privkey.pem 
chmod 777 fullchain.pem 


ip=$(curl http://ipinfo.io/ip) 
log=`tail -n 10 /var/log/letsencrypt/letsencrypt.log | grep 'Your certificate and chain have been saved'` 
if [ "$log" == "" ] ; then
	log=`tail -n 10 /var/log/letsencrypt/letsencrypt.log` 
	echo $log
	echo "init error"
else
	echo "init success"
fi

rm -rf /tmp/ssl.pid

