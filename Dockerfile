FROM itherz/webapp-full:a7

ENV FOLDER=/var/www/html/current

ADD latest.tar.gz /var/www/html
ADD initialize.start /etc/local.d/initialize.start
ADD 01-root.conf /etc/nginx/conf.d/01-root.conf
ADD 05-php.conf /etc/nginx/conf.d/05-php.conf

RUN apk add memcached && cd /var/www/html/wordpress/wp-content && mkdir /wp-content && cp -r * /wp-content/

VOLUME $FOLDER/wp-content

ENV PHP_MODULES "mysqli gd iconv pdo_mysql opcache memcached ldap"

WORKDIR $FOLDER


