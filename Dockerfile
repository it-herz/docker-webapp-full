FROM itherz/webapp-medium:d7

ENV NGINX_VERSION 1.10.2

#Changed - get LUA (jit, module, nginx_ndk) and dependencies
ENV LUA_VERSION 5.3.3
ENV NGX_DEVEL_KIT_VERSION 0.3.0
ENV LUAJIT_VERSION 2.0.4
ENV LUA_NGINX_MODULE_VERSION 0.10.6

ENV LUAJIT_LIB=/usr/local/lib/lua/5.1
ENV LUAJIT_INC=/usr/local/include/luajit-2.0

RUN apt update && apt install -y git pax-utils && mkdir -p /opt && cd /opt && git clone https://github.com/simpl/ngx_devel_kit && cd ngx_devel_kit && git checkout -b v$NGX_DEVEL_KIT_VERSION && \
    apt install -y make g++ && cd /opt && git clone https://github.com/luajit/luajit && cd luajit && git checkout -b v$LUAJIT_VERSION && make && make install && cd .. && \
    cd /opt && git clone https://github.com/openresty/lua-nginx-module && cd lua-nginx-module && git checkout -b v$LUA_NGINX_MODULE_VERSION && \
    cd /opt && git clone https://github.com/kvspb/nginx-auth-ldap.git && apt remove -y git && \ 
    GPG_KEYS=B0F4253373F8F6F510D42178520A9993A1C052F8 \
	&& CONFIG="\
		--prefix=/etc/nginx \
		--sbin-path=/usr/sbin/nginx \
		--modules-path=/usr/lib/nginx/modules \
		--conf-path=/etc/nginx/nginx.conf \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/run/nginx.lock \
		--http-client-body-temp-path=/var/cache/nginx/client_temp \
		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
		--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
		--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
		--user=nginx \
		--group=nginx \
                --with-ld-opt="-Wl,-rpath,/usr/local/lib/lua/5.1" \
                --add-module=/opt/ngx_devel_kit \
                --add-module=/opt/lua-nginx-module \
                --add-module=/opt/nginx-auth-ldap \
		--with-http_ssl_module \
		--with-http_realip_module \
		--with-http_addition_module \
		--with-http_sub_module \
		--with-http_dav_module \
		--with-http_flv_module \
		--with-http_mp4_module \
		--with-http_gunzip_module \
		--with-http_gzip_static_module \
		--with-http_random_index_module \
		--with-http_secure_link_module \
		--with-http_stub_status_module \
		--with-http_auth_request_module \
		--with-http_xslt_module=dynamic \
		--with-http_image_filter_module=dynamic \
		--with-http_geoip_module=dynamic \
		--with-http_perl_module=dynamic \
		--with-threads \
		--with-stream \
		--with-stream_ssl_module \
		--with-http_slice_module \
		--with-mail \
		--with-mail_ssl_module \
		--with-file-aio \
		--with-http_v2_module \
		--with-ipv6 \
	" \
	&& groupadd -r nginx \
	&& useradd -d /var/cache/nginx -s /sbin/nologin -g nginx nginx \
	&& apt update && apt install -y \
		build-essential \
		libssl-dev \
		libpcre3-dev \
	        zlib1g-dev \
		linux-headers-amd64 \
		curl \
		gnupg \
		libxslt-dev \
		libgd-dev \
		libgeoip-dev \
		libperl-dev \
                libldap-dev \
	&& curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
	&& curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz.asc  -o nginx.tar.gz.asc \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys "$GPG_KEYS" \
	&& gpg --batch --verify nginx.tar.gz.asc nginx.tar.gz \
	&& rm -r "$GNUPGHOME" nginx.tar.gz.asc \
	&& mkdir -p /usr/src \
	&& tar -zxC /usr/src -f nginx.tar.gz \
	&& rm nginx.tar.gz \
	&& cd /usr/src/nginx-$NGINX_VERSION \
	&& ./configure $CONFIG --with-debug \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& mv objs/nginx objs/nginx-debug \
	&& mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so \
	&& mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so \
	&& mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so \
	&& mv objs/ngx_http_perl_module.so objs/ngx_http_perl_module-debug.so \
	&& ./configure $CONFIG \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& make install \
	&& rm -rf /etc/nginx/html/ \
	&& mkdir /etc/nginx/conf.d/ \
	&& mkdir -p /usr/share/nginx/html/ \
	&& install -m644 html/index.html /usr/share/nginx/html/ \
	&& install -m644 html/50x.html /usr/share/nginx/html/ \
	&& install -m755 objs/nginx-debug /usr/sbin/nginx-debug \
	&& install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module-debug.so \
	&& install -m755 objs/ngx_http_image_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_image_filter_module-debug.so \
	&& install -m755 objs/ngx_http_geoip_module-debug.so /usr/lib/nginx/modules/ngx_http_geoip_module-debug.so \
	&& install -m755 objs/ngx_http_perl_module-debug.so /usr/lib/nginx/modules/ngx_http_perl_module-debug.so \
	&& ln -s ../../usr/lib/nginx/modules /etc/nginx/modules \
	&& strip /usr/sbin/nginx* \
	&& strip /usr/lib/nginx/modules/*.so \
	&& rm -rf /usr/src/nginx-$NGINX_VERSION \
	\
	# Bring in gettext so we can get `envsubst`, then throw
	# the rest away. To do this, we need to install `gettext`
	# then move `envsubst` out of the way so `gettext` can
	# be deleted completely, then move `envsubst` back.
	&& apt install -y gettext \
	&& mv /usr/bin/envsubst /tmp/ \
	\
	&& runDeps="$( \
		scanelf --needed --nobanner /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
			| awk '{ gsub(/,/, "\nso:", $2); print $2 }' \
			| sort -u | xargs -r dpkg -S | awk -F':' '{ print $1 }' | sort -u \
	)" \
	&& apt install -y $runDeps \
	&& mv /tmp/envsubst /usr/local/bin/ \
	\
	# forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
        # some cleanup 
        && apt purge -y build-essential git pax-utils libxslt-dev libgd-dev libperl-dev libldap-dev libssl-dev libpcre3-dev zlib1g-dev linux-headers-amd64 libgd-dev && apt-get autoremove -y && mkdir -p /var/cache/nginx/

ADD nginx.conf /etc/nginx/
ADD 01-root.conf /etc/nginx/conf.d/
ADD 00-stub.conf /etc/nginx/conf.d/
ADD 05-php.conf /etc/nginx/conf.d/
ADD supervisord.conf /etc/

EXPOSE 80

VOLUME /var/www/html
