# Docker PHP Builder

A Docker image for multi-stage-builds, designed for building PHP extensions with ease.

**Contents:**

- [Docker PHP Builder](#docker-php-builder)
  - [Usage](#usage)
  - [Overview](#overview)
    - [Supported Versions](#supported-versions)
      - [PHP](#php)
      - [Alpine](#alpine)
    - [Tag Naming Schemes](#tag-naming-schemes)
      - [Version Compatibility Map](#version-compatibility-map)
  - [Reference](#reference)
    - [Preinstalled Software](#preinstalled-software)
    - [Provided Tools](#provided-tools)
      - [`pecl-install-extension`](#pecl-install-extension)
      - [`pecl-install-extensions`](#pecl-install-extensions)
  - [Contributing](#contributing)
  - [Authors](#authors)
  - [License](#license)

## Usage

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

## Overview

The `php-builder` image is based upon [Alpine Linux](https://alpinelinux.org/) to be as small as possible.
Even though size doesn't matter in a secondary stage container, it allows for much faster builds with less overhead.

### Supported Versions

The following versions of PHP and Alpine are supported by this image.
**Please note** that these are not freely combinable! See the [Version Compatibility Map](#version-compatibility-map) for more information.

#### PHP

- `7.3`
- `7.2`
- `7.1`

#### Alpine

- `3.11`
- `3.10`
- `3.9`
- `3.8`
- `3.7`

### Tag Naming Schemes

We provide three different tag naming schemes for this image:

- `latest`: Built upon the latest Alpine image and for it's latest supported PHP version
- `7.x`: Built for the given PHP version upon the newest compatible Alpine image
- `7.x-alpine3.x`: Built upon the given Alpine image version for the given PHP version

These naming schemes yield the following tag names:

| Tag | PHP Version | Alpine Version |
|:---:|:-----------:|:--------------:|
| `latest` | `7.3` | `latest` |
| `7.3` | `7.3` | `3.11` |
| `7.2` | `7.2` | `3.9` |
| `7.1` | `7.1` | `3.7` |
| `7.3-alpine3.11` | `7.3` | `3.11` |
| `7.3-alpine3.10` | `7.3` | `3.10` |
| `7.2-alpine3.9` | `7.2` | `3.9` |
| `7.2-alpine3.8` | `7.2` | `3.8` |
| `7.1-alpine3.7` | `7.1` | `3.7` |

_(table is exemplary and may not be up-to-date!)_

#### Version Compatibility Map

Alpine packages are built against a specific version of the OS, therefore not all packages are available to all versions of Alpine.
As the only way to circumvent this behaviour would be to build PHP from source for each image, we currently stick to mapping several PHP versions to their suitable Alpine versions.
(We may add support for such cross-compiled versions in the future through a new tagging scheme.)

| Alpine Version |  | PHP Version |
|:--------------:|--|:-----------:|
| `3.11` | -> | `7.3` |
| `3.10` | -> | `7.3` |
| `3.9` | -> | `7.2` |
| `3.8` | -> | `7.2` |
| `3.7` | -> | `7.1` |

## Reference

### Preinstalled Software

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

### Provided Tools

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

## Contributing

Please read [CONTRIBUTING.md](https://github.com/MCStreetguy/docker-php-builder/blob/master/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

- **Maximilian Schmidt** - *Lead Developer* - [MCStreetguy](https://github.com/MCStreetguy)

See also the list of [contributors](https://github.com/MCStreetguy/docker-php-builder/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
