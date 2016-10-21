FROM itherz/webapp-full:d7

ADD nginx.conf /etc/nginx/
ADD 01-root.conf /etc/nginx/conf.d/
ADD 00-stub.conf /etc/nginx/conf.d/
ADD 05-php.conf /etc/nginx/conf.d/
ADD supervisord.conf /etc/
ADD 02-applykey /etc/container-run.d/

EXPOSE 80 22

VOLUME /var/www/html
