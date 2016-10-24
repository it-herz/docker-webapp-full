FROM itherz/webapp-tiny:a7

COPY nginx-install.sh /opt

RUN  apk update && \
     apk add openssh sudo nodejs rsync && \
     /opt/nginx-install.sh && rm /opt/nginx-install.sh
     rc-update add sshd sysinit && \
     rc-update add nginx sysinit && \
     umask 002 && \
     sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/ig' /etc/ssh/sshd_config && \
     sed -i 's/#RSAAuthentication.*/RSAAuthentication yes/ig' /etc/ssh/sshd_config && \
     npm install -g bower && \
     # Dirty hack to share envs for ssh
     sed -i '1s/^/mkdir -p \/var\/www\/html\/.ssh \&\& env | grep _ >> \/var\/www\/html\/.ssh\/environment\n/' /root/rc && \
     sed -i 's/#\(PermitUserEnvironment\) no/\1 yes/g' /etc/ssh/sshd_config

ADD nginx.conf /etc/nginx/
ADD 01-root.conf /etc/nginx/conf.d/
ADD 05-php.conf /etc/nginx/conf.d/
ADD 03-apply_key.start /etc/local.d/
ADD 04-add_nginx_tmp_dir_perms.start /etc/local.d/

EXPOSE 80 22
