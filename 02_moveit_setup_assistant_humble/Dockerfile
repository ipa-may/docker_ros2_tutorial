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

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        locales \
        python3-colcon-common-extensions \
        python3-rosdep \
        python3-vcstool \
        ros-${ROS_DISTRO}-joint-state-publisher-gui \
        ros-${ROS_DISTRO}-moveit \
        ros-${ROS_DISTRO}-moveit-setup-assistant \
        ros-${ROS_DISTRO}-robot-state-publisher \
        ros-${ROS_DISTRO}-ros2-control \
        ros-${ROS_DISTRO}-ros2-controllers \
        ros-${ROS_DISTRO}-ur-description \
        ros-${ROS_DISTRO}-xacro \
        sudo \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid "${GROUP_ID}" "${ROS_USER}" \
    && useradd --uid "${USER_ID}" --gid "${GROUP_ID}" --create-home --shell /bin/bash "${ROS_USER}" \
    && install -d -o "${ROS_USER}" -g "${ROS_USER}" "${WS_DIR}" "${WS_DIR}/src" \
    && echo "${ROS_USER} ALL=(root) NOPASSWD:ALL" > "/etc/sudoers.d/${ROS_USER}" \
    && chmod 0440 "/etc/sudoers.d/${ROS_USER}"

USER ${ROS_USER}
WORKDIR ${WS_DIR}

CMD ["bash"]
