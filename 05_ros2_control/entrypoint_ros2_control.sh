#!/bin/sh
. /opt/ros/"${ROS_DISTRO}"/setup.sh

WS_DIR="${HOME}/ros2_ws"

if [ -d "$WS_DIR" ]; then
  cd "$WS_DIR"
  if [ -f install/setup.sh ]; then
    . install/setup.sh
  fi
fi

exec "$@"