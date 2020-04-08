ARG UBUNTU_VERSION="18.04"
FROM ubuntu:${UBUNTU_VERSION}

# Build environment
ARG DEBIAN_FRONTEND="noninteractive"
ARG LC_ALL="C.UTF-8"

# Prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      apt-utils \
      bash \
      bison \
      coreutils \
      dirmngr \
      file \
      g++ \
      git \
      gnupg \
      libtool \
      make \
      re2c \
    && \
    rm -rf /var/lib/apt/lists/*

# Add PHP
ARG PHP_VERSION="7.3"
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-mark hold php-xml && \
    apt-mark hold php-common && \
    apt-mark hold php7.4-xml && \
    apt-mark hold php7.4-common && \
    apt-mark unhold php${PHP_VERSION}-xml && \
    apt-mark unhold php${PHP_VERSION}-common && \
    apt-get install -y --no-install-recommends \
      php-pear \
      php${PHP_VERSION} \
      php${PHP_VERSION}-dev \
      php${PHP_VERSION}-common \
      php${PHP_VERSION}-cli \
      php${PHP_VERSION}-fpm \
      php${PHP_VERSION}-xml \
    && \
    rm -rf /var/lib/apt/lists/*

# Add installer script
COPY ./container/ /usr/