FROM itherz/webapp-full:a7

ADD 05-php.conf /etc/nginx/conf.d/05-php.conf
ADD 01-root.conf /etc/nginx/conf.d/01-root.conf

ADD initialize.start /etc/local.d/05-symfony_parameters.start

RUN apk add redis nodejs && RUN npm install -g npm bower --prefix=/usr/local && \
    ln -s -f /usr/local/bin/npm /usr/bin/npm && ln -s -f /usr/local/bin/bower /usr/bin/bower

ENV DB_HOST localhost
ENV DB_PORT 3306
ENV DB_NAME changeme
ENV DB_USER root
ENV DB_PASS root
ENV SECRET secret
