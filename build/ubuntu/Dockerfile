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

# Add PHP repository
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    rm -rf /var/lib/apt/lists/*

# Add PHP
ARG PHP_VERSION="7.3"
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      php${PHP_VERSION} \
      php${PHP_VERSION}-dev \
      php${PHP_VERSION}-openssl \
      php${PHP_VERSION}-pear \
    && \
    rm -rf /var/lib/apt/lists/*

# Add installer script
COPY ./container/ /usr/