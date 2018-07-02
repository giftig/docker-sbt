#!/bin/bash

# Simple wrapper with default arguments for sbt.sh
# Uses a cache of .sbt and .ivy2 in the current working directory

DIR=$(readlink -f "$(dirname $0)")

# You'll need to install giftig/docker-sbt into /opt to use this script
$DIR/sbt.sh --expose-socket --image giftig/sbt-rpm --cache-root $(pwd)/.docked-sbt -- "$@"
