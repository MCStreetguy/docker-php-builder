#!/bin/bash

declare -a IMAGES=()
set -e

while read ALPINE_VERSION; do
  echo "Building on alpine v$ALPINE_VERSION..."
  export ALPINE_VERSION

  while read PHP_VERSION; do
    echo "Building for PHP v$PHP_VERSION"
    export PHP_VERSION

    TAG_NAME="mcstreetguy/php-builder:$PHP_VERSION"
    if [ "$ALPINE_VERSION" != "latest" ]; then
      TAG_NAME="$TAG_NAME-alpine$ALPINE_VERSION"
    fi

    echo "+ docker build --tag "$TAG_NAME" --build-arg ALPINE_VERSION --build-arg PHP_VERSION --compress --no-cache --no-cache .." >&2
    docker build --tag "$TAG_NAME" --build-arg ALPINE_VERSION --build-arg PHP_VERSION --compress --no-cache --no-cache ..

    IMAGES+=( "$TAG_NAME" )

    unset PHP_VERSION
  done <targets/php.txt

  unset ALPINE_VERSION
done <targets/alpine.txt

echo "Done. Built the following images:"

