FROM itherz/webapp-tiny:d7

RUN  apt-get update && \
     apt-get install -y openssh-server git \
             nginx && mkdir -p /var/run/sshd && \
     umask 002

ADD nginx.conf /etc/nginx/
ADD 01-root.conf /etc/nginx/conf.d/
ADD 05-php.conf /etc/nginx/conf.d/
ADD supervisord.conf /etc/
ADD applykey /etc/container-run.d/

EXPOSE 80 22

VOLUME /var/www/html
