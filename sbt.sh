#!/bin/bash

if [[ "$SBT_IMAGE_PREFIX" == '' ]]; then
  IMAGE_PREFIX=giftig
else
  IMAGE_PREFIX="$SBT_IMAGE_PREFIX"
fi

SBT_VERSION=0.13.13
SCALA_VERSION=2.11.6
VOLUMES="-v $HOME/.ivy2:/root/.ivy2"

usage() {
  echo 'docked-sbt --versions'
  echo 'docked-sbt --help'
  echo 'docked-sbt [--scala VERSION] [--sbt VERSION] [--nocache] [--] SBT_OPTIONS'
}
expect_arg() {
  if [[ "$1" == '' ]]; then
    usage
    exit 1
  fi
}

while [[ "$1" != '' ]]; do
  case $1 in
    --versions)
      docker images $IMAGE_PREFIX/sbt
      exit 0
      ;;
    --help)
      usage
      exit 0
      ;;
    --scala)
      shift
      expect_arg $1
      SCALA_VERSION="$1"
      shift
      ;;
    --sbt)
      shift
      expect_arg $1
      SBT_VERSION="$1"
      shift
      ;;
    --nocache)
      VOLUMES=''
      shift
      ;;
    --)
      shift
      break
      ;;
    *)
      break
      ;;
  esac
done

IMAGE="$IMAGE_PREFIX/sbt:$SBT_VERSION-$SCALA_VERSION"
VOLUMES="$VOLUMES -v $(pwd):/usr/src"

if [[ $(docker images -q "$IMAGE") == '' ]]; then
  echo "No $IMAGE_PREFIX/sbt image for sbt = $SBT_VERSION, scala = $SCALA_VERSION"
  exit 1
fi

echo '================================================='
echo 'DOCKED SBT'
echo "Using image $IMAGE"
echo "Using volumes $VOLUMES"
echo '================================================='

docker run -it --rm -w /usr/src --entrypoint sbt $VOLUMES $IMAGE "$@"