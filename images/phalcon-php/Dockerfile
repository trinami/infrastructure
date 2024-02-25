FROM php:fpm-alpine

LABEL maintainer="trinami <github.com/trinami>"

# User/Group globals
ENV MY_USER="phalcon" \
	MY_GROUP="phalcon" \
	MY_UID="1000" \
	MY_GID="1000" \
	LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# User and Group
RUN addgroup -S ${MY_GROUP} && adduser -S ${MY_USER} -G ${MY_GROUP}

RUN set -xe && \
	apk add --no-cache \
		yaml-dev \
		zlib-dev \
		libmemcached-dev \
		gmp-dev \
		icu-dev \
		libpq-dev \
		libxpm-dev \
		libzip-dev \
		imagemagick-dev \
		libpng-dev \
		libwebp-dev \
		jpeg-dev \
		freetype-dev \
		gettext-dev && \
        apk add --no-cache --virtual .build-deps \
            autoconf \
            g++ \
            make \
        && \
	# PECL Packages \
	pecl install -o -f redis && \
	      pecl install igbinary \
	      msgpack \
	      apcu \
	      yaml \
	      memcached \
	      zephir_parser \
	      phalcon && \
	# Install PHP extensions \
	docker-php-ext-configure gd --with-freetype  \
	    --with-jpeg=/usr/include/  \
	    --with-xpm \
	    --with-webp \
	    --enable-gd && \
	docker-php-ext-install \
		gd \
		gettext \
		gmp \
		intl \
		pdo_mysql \
		pdo_pgsql \
		zip && \
	# Install PHP extensions \
	docker-php-ext-enable \
		redis \
		igbinary \
		msgpack \
		apcu \
		yaml \
		memcached \
		zephir_parser \
		phalcon && \
        # Remove all temp files
        docker-php-source delete && \
        apk del .build-deps && \
        php -m

WORKDIR /app

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN echo "date.timezone=GMT" >> /usr/local/etc/php/php.ini

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

EXPOSE 9000
CMD ["php-fpm"]
