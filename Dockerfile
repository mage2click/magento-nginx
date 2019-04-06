FROM 	nginx:1.15-alpine 

LABEL	maintainer="Dmitry Shkolair @shkoliar"

COPY 	conf/nginx.conf /etc/nginx/nginx.conf
COPY 	conf/default.conf /etc/nginx/conf.d/default.conf.sample
COPY 	conf/proxy.conf /etc/nginx/conf.d/proxy.conf.sample
COPY 	conf/under-proxy.conf /etc/nginx/conf.d/under-proxy.conf.sample
COPY	start.sh /start.sh

RUN 	addgroup -S -g 1000 app && \
 		adduser -S -g 1000 -u 1000 -h /var/www -s /bin/sh app

RUN 	touch /var/run/nginx.pid
RUN 	mkdir /sock

RUN 	apk update && \
    	apk upgrade && \
    	apk add --no-cache --upgrade varnish && \
    	rm -rf /tmp/* /var/cache/apk/*

RUN 	apk upgrade --update-cache --available && \
    	apk add openssl && \
    	rm -rf /var/cache/apk/*

RUN 	mkdir /etc/nginx/certs && \
    	echo -e "\n\n\n\n\n\n\n" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/nginx.key -out /etc/nginx/certs/nginx.crt

RUN 	chown -R app:app /etc/nginx/certs/ /sock/ /var/cache/nginx/ /var/run/nginx.pid /etc/nginx/conf.d/
RUN 	chmod +x /start.sh

ENV		NGINX_TYPE=default

USER 	app:app

VOLUME	/var/www

WORKDIR	/var/www/html

CMD 	/start.sh