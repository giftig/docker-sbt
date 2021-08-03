#!/bin/bash

if [[ "$PREFIX" == '' ]]; then
  PREFIX=giftig
fi

YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

build_tag() {
  SCALA_VERSION=$1

  echo "${YELLOW}Building $PREFIX/sbt for scala-$SCALA_VERSION, sbt-$SBT_VERSION$RESET"
  docker build \
    --build-arg SCALA_VERSION=$SCALA_VERSION \
    -t $PREFIX/sbt:$SCALA_VERSION .
}

build_tag 2.13.6
