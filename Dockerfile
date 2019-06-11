FROM    nginx:1.15-alpine

LABEL   maintainer="Mage2click"

ENV     NGINX_TYPE=default

COPY    conf/nginx.conf /etc/nginx/
COPY    conf/conf.d/* /etc/nginx/conf.d/
COPY    start.sh /start.sh

RUN     addgroup -S -g 1000 app && \
        adduser -S -g 1000 -u 1000 -h /var/www -s /bin/ash app && \
        touch /var/run/nginx.pid && \
        mkdir -p /etc/nginx/certs/ /sock && \
        apk add --no-cache --virtual .bootstrap-deps openssl && \
        cd /etc/nginx/certs/ && \
        openssl genrsa -out nginx.key 2048 && \
        openssl req -new -nodes -sha256 -key nginx.key -out nginx.csr -subj /CN=\*.test && \
        openssl x509 -req -sha256 -days 3650 -in nginx.csr -signkey nginx.key -out nginx.crt && \
    	chown -R app:app /etc/nginx/certs/ /sock/ /var/cache/nginx/ /var/run/nginx.pid \
    		/etc/nginx/nginx.conf /etc/nginx/conf.d/ && \
		chmod +x /start.sh && \
		apk del .bootstrap-deps && \
        rm -rf /tmp/* && \
        rm -rf /var/cache/apk/*

USER    app:app

VOLUME  /var/www

WORKDIR /var/www/html

CMD     /start.sh