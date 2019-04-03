#!/bin/sh

set -e

if [ "${NGINX_TYPE}" = "proxy" ]; then 
	cp /etc/nginx/conf.d/proxy.conf.sample /etc/nginx/conf.d/default.conf;
else 
	cp /etc/nginx/conf.d/default.conf.sample /etc/nginx/conf.d/default.conf;
fi

nginx -g 'daemon off;'
