FROM itherz/webapp-full:a7

ENV FOLDER=/var/www/html/current

ADD initialize.start /etc/local.d/initialize.start
ADD 01-root.conf /etc/nginx/conf.d/01-root.conf
ADD 05-php.conf /etc/nginx/conf.d/05-php.conf

RUN apk add memcached wget && \
     cd /var/www/html && wget https://wordpress.org/latest.zip && \
     unzip latest.zip && \
     cd /var/www/html/wordpress/wp-content && mkdir /wp-content && cp -r * /wp-content/ &&
     mkdir /wordpress && cp -R /var/www/html/wordpress/* /wordpress

VOLUME /var/www/html/current/wp-content

ENV PHP_MODULES "mysqli gd iconv pdo_mysql opcache memcached ldap"

WORKDIR $FOLDER


