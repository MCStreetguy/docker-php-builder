#!/bin/bash

set -e
PWD=$(pwd)
BUILD_DIR=$(realpath $(dirname $0))

# If working directory and build folder differ, CD there for paths to work
if [ "$PWD" != "$BUILD_DIR" ]; then
  unset CDPATH
  cd $BUILD_DIR
fi

# Read all version combinations and build them
while read _VERSION; do
  VERSIONS=(${_VERSION//;/ })
  ALPINE_VERSION="${VERSIONS[1]}"
  PHP_VERSION="${VERSIONS[0]}"

  export ALPINE_VERSION
  export PHP_VERSION
  echo "Building for PHP v$PHP_VERSION on alpine v$ALPINE_VERSION..." >&2

  TAG_NAME="mcstreetguy/php-builder:$PHP_VERSION"
  if [ "$ALPINE_VERSION" != "latest" ]; then
    TAG_NAME="$TAG_NAME-alpine$ALPINE_VERSION"
  fi

  echo "+ docker build --tag "$TAG_NAME" --build-arg ALPINE_VERSION --build-arg PHP_VERSION --compress --no-cache --no-cache .." >&2
  docker build --tag "$TAG_NAME" --build-arg ALPINE_VERSION --build-arg PHP_VERSION --compress --no-cache --no-cache .. >&2

  echo "$TAG_NAME" # Print tag name to stdout to allow piping the results

  unset PHP_VERSION

  unset ALPINE_VERSION
done <targets.txt

cd $PWD
echo "Done." >&2
exit 0