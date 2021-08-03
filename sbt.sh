#!/bin/bash

if [[ "$SBT_IMAGE" == '' ]]; then
  IMAGE=giftig/sbt
else
  IMAGE="$SBT_IMAGE"
fi

SCALA_VERSION=2.12.8
VOLUMES=''
QUIET=false

CACHE_ROOT="$HOME"
NOCACHE=false

# Colours
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

usage() {
  echo 'docked-sbt --versions'
  echo 'docked-sbt --help'
  echo 'docked-sbt OPTIONS [--] SBT_OPTIONS'
  echo ''
  echo 'Options:'
  echo -e "--scala VERSION\t\tDefaults to 2.11.6"
  echo -e "-e, --expose-socket\tExpose the host docker.sock to the sbt container"
  echo -e "--nocache\t\tDon't mount the user's .ivy2 dir as a volume"
  echo -e "--cache-root\t\tMount .ivy2 from a different base dir"
  echo -e "--image\t\tSpecify a different image; default is giftig/sbt"
  echo '--nocolor'
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
      docker images "$IMAGE"
      exit 0
      ;;
    --nocolor)
      YELLOW=''
      RESET=''
      ;;
    --help)
      usage
      exit 0
      ;;
    -q|--quiet)
      shift
      QUIET=true
      ;;
    --scala)
      shift
      expect_arg $1
      SCALA_VERSION="$1"
      shift
      ;;
    --image)
      shift
      expect_arg $1
      IMAGE="$1"
      shift
      ;;
    --expose-socket|-e)
      shift
      VOLUMES="$VOLUMES -v /var/run/docker.sock:/var/run/docker.sock"
      ;;
    --nocache)
      NOCACHE=true
      shift
      ;;
    --cache-root)
      shift
      CACHE_ROOT="$1"
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

if [[ "$NOCACHE" == false ]]; then
  VOLUMES="$VOLUMES -v $CACHE_ROOT/.ivy2:/root/.ivy2"
  VOLUMES="$VOLUMES -v $CACHE_ROOT/.sbt:/root/.sbt"
  VOLUMES="$VOLUMES -v $CACHE_ROOT/.cache/coursier:/root/.cache/coursier"
fi

ENVIRON="-e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION -e DDE_NO_FATAL_WARNINGS -e XANTORIA_NO_FATAL_WARNINGS"
IMAGE="$IMAGE:$SCALA_VERSION"
VOLUMES="$VOLUMES -v $(pwd):/usr/src"

if [[ $(docker images -q "$IMAGE") == '' ]]; then
  echo "No $IMAGE image for scala = $SCALA_VERSION"
  exit 1
fi

if [[ "$QUIET" != true ]]; then
  echo -n $YELLOW
  echo '================================================='
  echo 'DOCKED SBT'
  echo "Using image $IMAGE"
  echo "Using volumes $(echo $VOLUMES | sed 's|-v|\'$'\n-v|g')"
  echo -e "Running command\n  sbt $@"
  echo '================================================='
  echo -n $RESET
fi

docker run -it --rm -w /usr/src --entrypoint sbt $ENVIRON $VOLUMES $IMAGE "$@"
