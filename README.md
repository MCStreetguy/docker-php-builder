# Docker PHP Builder

A Docker image for multi-stage-builds, designed for building PHP extensions with ease.
It is based upon [alpine](https://alpinelinux.org/) to be as small as possible.
Even though size doesn't matter in a secondary stage container, it allows for much faster builds.

**Contents:**

- [Docker PHP Builder](#docker-php-builder)
  - [Overview](#overview)
    - [Preinstalled software](#preinstalled-software)
    - [Provided tools](#provided-tools)
      - [`pecl-install-extension`](#pecl-install-extension)
      - [`pecl-install-extensions`](#pecl-install-extensions)

## Overview

Use this image as a basis for your Dockerfile builder stage to build and install PHP extensions:

```Dockerfile
FROM mcstreetguy/php-builder:7.3 as builder

# Add depedencies for extensions
RUN apk add --no-cache imagemagick-dev libmemcached-dev

# Install 'igbinary' php extension (dependency)
RUN CFLAGS="-O2 -g" pecl-install-extension igbinary --enable-igbinary

# Install 'apcu' php extension
RUN pecl-install-extension apcu

# Install 'imagick' php extension
RUN pecl-install-extension imagick

# Install 'memcached' php extension
RUN pecl-install-extension memcached --with-libmemcached-dir="/usr" --enable-memcached-igbinary

# Install 'redis' php extension
RUN pecl-install-extension redis --enable-redis-igbinary

```

Then in your main stage you can copy the shared modules from the builder stage:

```Dockerfile
FROM alpine:3.11
COPY --from=builder /usr/lib/php7/modules/* /usr/lib/php7/modules/
COPY --from=builder /usr/include/php7/ext/ /usr/include/php7/ext/
```

### Preinstalled software

The following packages are preinstalled in their latest available version:

- [`bash`](https://pkgs.alpinelinux.org/package/edge/main/x86_64/bash)
- [`bison`](https://pkgs.alpinelinux.org/package/edge/main/x86_64/bison)
- [`coreutils`](https://pkgs.alpinelinux.org/package/edge/main/x86_64/coreutils)
- [`file`](https://pkgs.alpinelinux.org/package/edge/main/x86_64/file)
- [`g++`](https://pkgs.alpinelinux.org/package/edge/main/x86_64/g++)
- [`git`](https://pkgs.alpinelinux.org/package/edge/main/x86_64/git)
- [`libtool`](https://pkgs.alpinelinux.org/package/edge/main/x86_64/libtool)
- [`make`](https://pkgs.alpinelinux.org/package/edge/main/x86_64/make)
- [`re2c`](https://pkgs.alpinelinux.org/package/edge/main/x86_64/re2c)
- [`php7`](https://pkgs.alpinelinux.org/package/edge/community/x86_64/php7)
- [`php7-dev`](https://pkgs.alpinelinux.org/package/edge/community/x86_64/php7-dev)
- [`php7-pear`](https://pkgs.alpinelinux.org/package/edge/community/x86_64/php7-pear)
- [`php7-openssl`](https://pkgs.alpinelinux.org/package/edge/community/x86_64/php7-openssl) _(required by `php7-pear`)_

### Provided tools

#### `pecl-install-extension`

A small helper script, that simplifies the process of installing a PECL extension.
You may just provide an extension name as first parameter if you don't need any further configuration.
In that case, the script will replace it's own process by `pecl install -f <name>`.
If you provide more arguments to the script it will download, unpack, compile and install the extension step by step, passing any further options to the `./configure` command.
This allows for customizing the built extension in several ways, which is currently not possible directly through the `pecl` binary.

```Dockerfile
RUN pecl-install-extension memcached --with-libmemcached-dir="/usr" --enable-memcached-igbinary
```

**Please note** that it is not possible to install multiple packages at once with this script! Attemting to do so will result in errors during the configuration process of the first listed extension! See below for an alternative to this.

#### `pecl-install-extensions`

This tiny script acts as an loop-wrapper to the above `pecl-install-extension`.
Use it if you want to install multiple extensions in one statement without any further configuration.

```Dockerfile
RUN pecl-install-extensions apcu imagick redis
```
