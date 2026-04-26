# syntax=docker/dockerfile:1.6

ARG ROS_DISTRO=humble
ARG ROS_DESKTOP_BASE=osrf/ros:${ROS_DISTRO}-desktop-full

FROM ${ROS_DESKTOP_BASE}

ARG ROS_DISTRO
ARG ROS_USER=ros
ARG USER_ID=1001
ARG GROUP_ID=${USER_ID}
ARG DEBIAN_FRONTEND=noninteractive

ENV ROS_DISTRO=${ROS_DISTRO} \
    ROS_USER=${ROS_USER} \
    USER_ID=${USER_ID} \
    GROUP_ID=${GROUP_ID} \
    WS_DIR=/home/${ROS_USER}/ros2_ws \
    PATH=/home/${ROS_USER}/.local/bin:${PATH} \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

SHELL ["/bin/bash", "-c"]

COPY docker/scripts/base-setup.sh /tmp/base-setup.sh
COPY docker/assets /opt/docker-assets

RUN chmod +x /tmp/base-setup.sh \
    && /tmp/base-setup.sh \
    && rm -f /tmp/base-setup.sh

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3-colcon-common-extensions \
        python3-rosdep \
        python3-vcstool \
        ros-${ROS_DISTRO}-joint-state-publisher-gui \
        ros-${ROS_DISTRO}-moveit \
        ros-${ROS_DISTRO}-moveit-setup-assistant \
        ros-${ROS_DISTRO}-robot-state-publisher \
        ros-${ROS_DISTRO}-ur-description \
        ros-${ROS_DISTRO}-xacro \
    && rm -rf /var/lib/apt/lists/*

RUN install -d -o "${ROS_USER}" -g "${ROS_USER}" "${WS_DIR}" "${WS_DIR}/src" \
    && install -m 644 -o "${ROS_USER}" -g "${ROS_USER}" /opt/docker-assets/bashrc /home/"${ROS_USER}"/.bashrc \
    && install -m 755 /opt/docker-assets/entrypoints/default_entrypoint.sh /entrypoint.sh

USER ${ROS_USER}
WORKDIR ${WS_DIR}

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["bash"]
