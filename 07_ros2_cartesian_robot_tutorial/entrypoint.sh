#!/bin/bash
set -e

# Source ROS and overlay
source /opt/ros/jazzy/setup.bash

# Source workspace if built
if [ -f /home/ros/ros2_ws/install/setup.bash ]; then
  source /home/ros/ros2_ws/install/setup.bash
fi

# Export plugin path
export GZ_SIM_SYSTEM_PLUGIN_PATH=/opt/ros/jazzy/lib:/home/ros/ros2_ws/install/lib

exec "$@"
