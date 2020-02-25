#!/bin/bash

set -e
PWD=$(pwd)
BUILD_DIR=$(realpath $(dirname $0))
QUIET=$(([[ $1 == "--quiet" ]] || [[ $1 == "-q" ]]) && echo true || echo false)

# If working directory and build folder differ, CD there for paths to work
if [ "$PWD" != "$BUILD_DIR" ]; then
  unset CDPATH
  cd $BUILD_DIR
fi

declare -a IMAGES=()

# Read all version combinations and build them
while read _VERSION; do
  VERSIONS=(${_VERSION//;/ })
  ALPINE_VERSION="${VERSIONS[1]}"
  TAG_APPENDIX="${VERSIONS[2]}"
  PHP_VERSION="${VERSIONS[0]}"

  export ALPINE_VERSION
  export PHP_VERSION

  [ "$QUIET" == "false" ] && echo "" >&2
  [ "$QUIET" == "false" ] && echo "Building for PHP v$PHP_VERSION on alpine v$ALPINE_VERSION..." >&2

  TAG_NAME="mcstreetguy/php-builder:$PHP_VERSION"
  if [ -n "$TAG_APPENDIX" ]; then
    TAG_NAME="$TAG_NAME-$TAG_APPENDIX"
  fi

  if [ "$QUIET" == "false" ]; then
    echo "+ docker build --tag "$TAG_NAME" --build-arg ALPINE_VERSION --build-arg PHP_VERSION --compress --no-cache --no-cache .." >&2 && echo "" >&2
    docker build --tag "$TAG_NAME" --build-arg ALPINE_VERSION --build-arg PHP_VERSION --compress --no-cache --no-cache .. >&2
  else
    docker build --tag "$TAG_NAME" --build-arg ALPINE_VERSION --build-arg PHP_VERSION --compress --no-cache --no-cache .. &>/dev/null
  fi

  echo "$TAG_NAME" >&1
  IMAGES+=( "$TAG_NAME" )

  unset PHP_VERSION
  unset ALPINE_VERSION
done <targets.txt

if [ "$QUIET" == "false" ]; then
  echo "Done. Built the following images:" >&2

  for image in "${IMAGES[@]}"; do
    echo " - $image" >&2
  done
fi

cd $PWD
exit 0