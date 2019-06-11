#!/bin/sh

set -e

NGINX_TYPE=${NGINX_TYPE:-default}

if [[ "$NGINX_TYPE" != "proxy" ]] && [[ "$NGINX_TYPE" != "under-proxy" ]] && [[ "$NGINX_TYPE" != "default" ]]; then
	NGINX_TYPE=default
fi

cp /etc/nginx/conf.d/${NGINX_TYPE}.conf.sample /etc/nginx/conf.d/default.conf;

nginx -g 'daemon off;'