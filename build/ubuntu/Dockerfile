ARG UBUNTU_VERSION="18.04"
FROM ubuntu:${UBUNTU_VERSION}

# Prerequisites
ENV LC_ALL C
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
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
    rm -rf /var/lib/apt/lists/*

# Add PHP
ARG PHP_VERSION="7.3"
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    LC_ALL=C.UTF-8 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      php-pear \
      php${PHP_VERSION} \
      php${PHP_VERSION}-dev \
    && \
    rm -rf /var/lib/apt/lists/*

# Add installer script
COPY ./container/ /usr/