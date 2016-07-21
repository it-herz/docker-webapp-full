FROM itherz/webapp-full:a7

ENV FOLDER=/var/www/html/current/web

ADD latest.tar.gz /var/www/html
ADD initialize.start /etc/local.d/initialize.start

RUN apk add memcached && cd /var/www/html/wordpress/wp-content && mkdir /wp-content && cp -r * /wp-content/

VOLUME $FOLDER/wp-content

ENV PHP_MODULES "mysqli gd iconv pdo_mysql opcache memcached ldap"

WORKDIR /var/www/html/current/web

