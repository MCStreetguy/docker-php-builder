#!/bin/bash

set -e
PWD=$(pwd)
BUILD_DIR=$(realpath $(dirname $0))
QUIET=$(([[ $1 == "--quiet" ]] || [[ $1 == "-q" ]]) && echo true || echo false)

# If working directory and build folder differ, CD there for paths to work
# if [ "$PWD" != "$BUILD_DIR" ]; then
#   unset CDPATH
#   cd $BUILD_DIR
# fi

declare -a IMAGES=()

# Read all version combinations and build them
sed '/^$/d' "${BUILD_DIR}/targets.txt" | while read _VERSION; do
  VERSIONS=(${_VERSION//;/ })
  ALPINE_VERSION="${VERSIONS[1]}"
  PHP_VERSION="${VERSIONS[0]}"

  export ALPINE_VERSION
  export PHP_VERSION

  TAG_NAME="mcstreetguy/php-builder:${VERSIONS[2]:-$PHP_VERSION}"
  _CMD="docker build --file build/alpine/Dockerfile --tag $TAG_NAME --build-arg ALPINE_VERSION --build-arg PHP_VERSION --compress ."

  if [ "$QUIET" == "false" ]; then
    echo "" >&2
    echo "Building for PHP v$PHP_VERSION on alpine v$ALPINE_VERSION..." >&2
    echo "+ $_CMD" >&2
    echo "" >&2
    $_CMD >&2
  else
    $_CMD &>/dev/null
  fi

  echo "$TAG_NAME" >&1
  IMAGES+=( "$TAG_NAME" )

  unset _CMD
  unset _VERSION
  unset ALPINE_VERSION
  unset PHP_VERSION
  unset TAG_NAME
  unset VERSIONS
done

if [ "$QUIET" == "false" ]; then
  echo "" >&2
  echo "Done. Built the following images:" >&2

  for image in "${IMAGES[@]}"; do
    echo " - $image" >&2
  done
fi

cd $PWD
unset BUILD_DIR
unset IMAGES
unset QUIET
unset PWD
exit 0
