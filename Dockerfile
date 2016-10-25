FROM itherz/webapp-full:d7

RUN apt install sudo

ADD 03-add_ssh_sudoer /etc/container-run.d/
ADD 01-root.conf /etc/nginx/conf.d/
ADD 05-php.conf /etc/nginx/conf.d/

EXPOSE 80 22

VOLUME /var/www/html
