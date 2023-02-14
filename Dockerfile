FROM php:7.3.9-fpm-alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk add zip libzip-dev libpng-dev autoconf build-base libevent-dev gcc libc-dev libwebp-dev libjpeg-turbo-dev jpeg-dev freetype-dev make g++ rabbitmq-c-dev libsodium-dev libmcrypt-dev gmp-dev libpq-dev libmemcached-dev ca-certificates openssl-dev --no-cache && \
    apk update && apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    update-ca-certificates && \
    apk del tzdata

RUN docker-php-ext-configure gd --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-freetype-dir=/usr/include/ --with-webp-dir=/usr/include/ && \
    docker-php-ext-install gd sockets pcntl pdo_mysql mysqli gmp zip bcmath

RUN pecl install redis && \
    pecl install amqp && \
    pecl install mongodb && \
    docker-php-ext-enable redis amqp mongodb opcache

RUN pecl install event && \
    docker-php-ext-enable --ini-name zz-event.ini event

RUN docker-php-ext-install pdo_pgsql pgsql

RUN curl -sS https://getcomposer.org/installer | php && \
	mv ./composer.phar /usr/bin/composer && \
	composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

VOLUME /var/www
WORKDIR /var/www
