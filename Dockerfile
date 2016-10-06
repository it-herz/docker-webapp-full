FROM itherz/webapp-full:a7

ADD 05-php.conf /etc/nginx/conf.d/05-php.conf
ADD 01-root.conf /etc/nginx/conf.d/01-root.conf

ADD initialize.start /etc/local.d/05-symfony_parameters.start

RUN apk add redis nodejs && npm install -g npm bower --prefix=/usr/local && \
    ln -s -f /usr/local/bin/npm /usr/bin/npm && ln -s -f /usr/local/bin/bower /usr/bin/bower

ENV SYMF_DATABASE_HOST localhost
ENV SYMF_DATABASE_PORT 3306
ENV SYMF_DATABASE_NAME changeme
ENV DATABASE_USER root
ENV SYMF_DATABASE_PASSWORD root
ENV SYMF_SECRET secret
