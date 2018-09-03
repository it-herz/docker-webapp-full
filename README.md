# docker-webapp-full
Full Web Application (with nginx / ssh)
##### Переменные окружения PHP-FPM меняем через конфиг nginx  => 05-php.conf,
 `fastcgi_param PHP_ADMIN_VALUE "max_execution_time=600";`

**PHPCI в 05-php.conf и 01-root.conf дописывает /web**
` root	/var/www/html/current/web;`
