#!/bin/bash

if [[ "$PREFIX" == '' ]]; then
  PREFIX=giftig
fi

YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

build_tag() {
  SCALA_VERSION=$1
  SBT_VERSION=$2

  echo "Building $PREFIX/sbt for scala-$SCALA_VERSION, sbt-$SBT_VERSION"
  docker build \
    --build-arg SCALA_VERSION=$SCALA_VERSION \
    --build-arg SBT_VERSION=$SBT_VERSION \
    -t $PREFIX/sbt:$SBT_VERSION-$SCALA_VERSION .
}

build_tag 2.10.4 0.13.13
build_tag 2.11.6 0.13.13
build_tag 2.10.6 0.13.12
build_tag 2.10.6 0.13.13
build_tag 2.11.6 0.13.12
build_tag 2.12.1 0.13.12
