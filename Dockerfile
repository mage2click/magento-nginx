FROM 	nginx:1.13

LABEL	maintainer="Dmitry Shkolair @shkoliar"

COPY 	conf/nginx.conf /etc/nginx/nginx.conf
COPY 	conf/default.conf /etc/nginx/conf.d/default.conf.sample
COPY 	conf/proxy.conf /etc/nginx/conf.d/proxy.conf.sample
COPY 	conf/under-proxy.conf /etc/nginx/conf.d/under-proxy.conf.sample
COPY	start.sh /start.sh

RUN 	groupadd -g 1000 app && \
 		useradd -g 1000 -u 1000 -d /var/www -s /bin/bash app

RUN 	touch /var/run/nginx.pid
RUN 	mkdir /sock

RUN 	apt-get update && apt-get install -y openssl
RUN 	mkdir /etc/nginx/certs && \
  		echo -e "\n\n\n\n\n\n\n" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/nginx.key -out /etc/nginx/certs/nginx.crt

RUN 	chown -R app:app /etc/nginx/certs /sock /var/cache/nginx/ /var/run/nginx.pid /sock /etc/nginx/conf.d/
RUN 	chmod +x /start.sh

ENV		NGINX_TYPE=default

USER 	app:app

VOLUME	/var/www

WORKDIR	/var/www/html

CMD 	/start.sh