#!/bin/bash

mkdir -p /run/php-fpm
chown -R nginx:nginx /run/php-fpm

php-fpm &
exec nginx -g "daemon off;"

