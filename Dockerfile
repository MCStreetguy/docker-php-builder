ARG ALPINE_VERSION="3.11"
FROM alpine:${ALPINE_VERSION}

# Prerequisites
ENV LC_ALL C
RUN apk add --no-cache \
      bash \
      bison \
      coreutils \
      file \
      g++ \
      git \
      libtool \
      make \
      re2c \
    && \
    rm -rf /var/cache/apk/*

# Add PHP
ARG PHP_VERSION="7.3"
RUN apk add --no-cache \
      "php7=~${PHP_VERSION}" \
      "php7-dev=~${PHP_VERSION}" \
      "php7-openssl=~${PHP_VERSION}" \
      "php7-pear=~${PHP_VERSION}" \
    && \
    rm -rf /var/cache/apk/*

# Add installer script
COPY ./container/pecl-install-extension /usr/local/bin/