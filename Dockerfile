FROM itherz/webapp-tiny:d5

RUN  apt-get update && \
     cd /tmp && \
     wget http://ftp.ru.debian.org/debian/pool/main/n/ncurses/libncurses5_6.0+20160917-1_amd64.deb && \
     wget http://ftp.ru.debian.org/debian/pool/main/n/ncurses/libncursesw5_6.0+20160917-1_amd64.deb && \
     dpkg -i *.deb && \
     rm -rf /tmp/* && \
     apt-get install -y openssh-server nginx && \
             mkdir -p /var/run/sshd && \
     umask 002

ADD nginx.conf /etc/nginx/
ADD 01-root.conf /etc/nginx/conf.d/
ADD 00-stub.conf /etc/nginx/conf.d/
ADD 05-php.conf /etc/nginx/conf.d/
ADD supervisord.conf /etc/
ADD 02-applykey /etc/container-run.d/

EXPOSE 80 22

VOLUME /var/www/html
