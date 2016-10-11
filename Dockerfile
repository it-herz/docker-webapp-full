FROM itherz/webapp-full:a7

ADD 05-php.conf /etc/nginx/conf.d/05-php.conf
ADD 01-root.conf /etc/nginx/conf.d/01-root.conf

RUN apk add redis nodejs && npm install -g npm bower --prefix=/usr/local && \
    ln -s -f /usr/local/bin/npm /usr/bin/npm && ln -s -f /usr/local/bin/bower /usr/bin/bower && \
    # Dirty hack to share envs for ssh
    sed -i '1s/^/env | grep _ >> \/var\/www\/html\/.ssh\/environment\n/' /root/rc && \
    sed -i 's/#\(PermitUserEnvironment\) no/\1 yes/g' /etc/ssh/sshd_config

ENV SYMFONY__DATABASE_HOST localhost
ENV SYMFONY__DATABASE_PORT 3306
ENV SYMFONY__DATABASE_NAME changeme
ENV SYMFONY__DATABASE_USER root
ENV SYMFONY__DATABASE_PASSWORD root
ENV SYMFONY__SECRET secret
