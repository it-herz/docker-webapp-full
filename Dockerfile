FROM itherz/webapp-full:d7

ADD 01-root.conf /etc/nginx/conf.d/
ADD 05-php.conf /etc/nginx/conf.d/

EXPOSE 80 22

VOLUME /var/www/html
