FROM php:fpm-alpine

LABEL maintainer="trinami <github.com/trinami>"

RUN set -xe && \
        apk add --no-cache --virtual .build-deps \
            autoconf \
            g++ \
            make \
            jq \
        && \
        docker-php-source extract && \
	LATEST_PHALCON_VERSION=$(curl  "https://api.github.com/repos/phalcon/cphalcon/tags" | jq -r '.[0].name') && \
        # Install ext-phalcon
        cd /tmp && \
        curl -LO https://github.com/phalcon/cphalcon/releases/download/${LATEST_PHALCON_VERSION}/phalcon-pecl.tgz && \
        tar xzf phalcon-pecl.tgz && \
        docker-php-ext-install -j $(getconf _NPROCESSORS_ONLN) \
            /tmp/phalcon-${LATEST_PHALCON_VERSION#v} \
        && \
        # Remove all temp files
        rm -r /tmp/phalcon-* && \
        docker-php-source delete && \
        apk del .build-deps && \
        php -m
