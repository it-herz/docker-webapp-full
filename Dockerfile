FROM itherz/webapp-tiny:a7

RUN  apk update && \
     apk add openssh sudo nodejs \
             nginx && \
     rc-update add sshd sysinit && \
     rc-update add nginx sysinit && \
     umask 002 && \
     sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/ig' /etc/ssh/sshd_config && \
     sed -i 's/#RSAAuthentication.*/RSAAuthentication yes/ig' /etc/ssh/sshd_config && \
     npm install -g bower

ADD nginx.conf /etc/nginx/
ADD 01-root.conf /etc/nginx/conf.d/
ADD 05-php.conf /etc/nginx/conf.d/
ADD apply_key.start /etc/local.d/

EXPOSE 80 22
