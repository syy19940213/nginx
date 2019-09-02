FROM centos

RUN ping -c 1 www.baidu.com
RUN yum -y install openssl openssl-devel  wget gcc make pcre-devel zlib-devel tar zlib

RUN mkdir /nginx
WORKDIR /nginx
RUN wget https://raw.githubusercontent.com/syy19940213/nginx/master/GeoLite2-Country.mmdb

RUN mkdir /data
WORKDIR /data
RUN wget https://github.com/maxmind/libmaxminddb/releases/download/1.3.2/libmaxminddb-1.3.2.tar.gz
RUN tar -xzf libmaxminddb-1.3.2.tar.gz
WORKDIR libmaxminddb-1.3.2
RUN ./configure
RUN make && make install
RUN sh -c "echo /usr/local/lib  >> /etc/ld.so.conf.d/local.conf"
RUN ldconfig
RUN  mkdir -p /var/cache/nginx/
WORKDIR /data
RUN wget https://github.com/TravelEngineers/ngx_http_geoip2_module/archive/3.2.tar.gz
RUN  tar -zxvf 3.2.tar.gz
RUN wget https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz
RUN tar -zxvf 2.3.tar.gz 
RUN wget https://people.freebsd.org/~osa/ngx_http_redis-0.3.9.tar.gz
RUN tar -zxvf ngx_http_redis-0.3.9.tar.gz 



RUN wget http://nginx.org/download/nginx-1.17.2.tar.gz
RUN tar -zxvf nginx-1.17.2.tar.gz
WORKDIR nginx-1.17.2
RUN ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --add-dynamic-module=/data/ngx_http_geoip2_module-3.2 --add-module=/data/ngx_cache_purge-2.3 --add-dynamic-module=/data/ngx_http_redis-0.3.9  --with-cc-opt='-g -O2 -fdebug-prefix-map=/data/builder/debuild/nginx-1.17.2/debian/debuild-base/nginx-1.17.2=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie'
RUN make && make install

RUN useradd -s /sbin/nologin -M nginx
RUN mkdir -p /var/tmp/nginx/client/
EXPOSE 443
EXPOSE 80
CMD /bin/sh -c 'nginx -g "daemon off;"'
