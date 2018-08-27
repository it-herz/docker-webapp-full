# docker-webapp-full
Full Web Application (with nginx / ssh)
##### Переменные окружения PHP-FPM меняем через конфиг nginx  => 05-php.conf,
 `fastcgi_param PHP_ADMIN_VALUE "max_execution_time=300";`
##### Отладка через замену файла / подключение тома (volumes):
`-v /root/05-php.conf:/etc/nginx/conf.d/05-php.conf`