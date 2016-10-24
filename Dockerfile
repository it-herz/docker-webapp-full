FROM itherz/webapp-medium:a7

COPY nginx-install.sh /opt/

RUN  /opt/nginx-install.sh && rm /opt/nginx-install.sh

COPY nginx /etc/init.d/

RUN  rc-update add nginx sysinit

ADD nginx.conf /etc/nginx/
ADD 01-root.conf /etc/nginx/conf.d/
ADD 05-php.conf /etc/nginx/conf.d/
ADD 04-add_nginx_tmp_dir_perms.start /etc/local.d/

EXPOSE 80
