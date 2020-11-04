#!/bin/bash

if [[ "$PREFIX" == '' ]]; then
  PREFIX=giftig
fi

YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

build_tag() {
  SCALA_VERSION=$1
  SBT_VERSION=$2

  echo "${YELLOW}Building $PREFIX/sbt for scala-$SCALA_VERSION, sbt-$SBT_VERSION$RESET"
  docker build \
    --build-arg SCALA_VERSION=$SCALA_VERSION \
    --build-arg SBT_VERSION=$SBT_VERSION \
    -t $PREFIX/sbt:$SBT_VERSION-$SCALA_VERSION .
}

build_tag 2.11.12 1.2.8
build_tag 2.12.8 1.2.8
