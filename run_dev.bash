#!/usr/bin/env bash

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR_PATH=$(dirname "$SCRIPT_PATH")
SRC_DIR_PATH=$(realpath "$SCRIPT_DIR_PATH/host_ws/")
DOCKER_BASH_DIR_PATH=$(realpath "$SCRIPT_DIR_PATH/docker/docker_include/")

xhost +local:root

docker run -it --rm \
  --ulimit core=0 \
  --runtime=nvidia \
  --hostname=robot \
  --privileged \
  --volume=/tmp/.X11-unix:/tmp/.X11-unix \
  --device=/dev/dri:/dev/dri \
  --env="DISPLAY=$DISPLAY" \
  --env QT_X11_NO_MITSHM=1 \
  --volume="$SRC_DIR_PATH:/root/host_ws" \
  --volume="$DOCKER_BASH_DIR_PATH:/root/docker_include" \
  ucu_ros bash

xhost -local:root
