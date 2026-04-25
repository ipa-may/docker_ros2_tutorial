# Tutorial: How This ROS 2 Docker Repository Works

This document explains the repository structure and how to use it.

The goal is simple:

- learn that this repository provides ready-to-use ROS 2 Docker environments for different workshop exercises and development tasks
- understand the role of Docker, Docker Compose, and ROS 2 here
- know which files to edit
- run one example without getting lost in the folder structure

## 1. What You Will Find in This Repository

This repository contains several small ROS 2 development environments built with Docker.

Each environment focuses on one topic, for example:

- GUI tools
- RealSense cameras
- Gazebo / GZ Sim
- `ros2_control`
- Universal Robots
- RMW / middleware experiments such as Zenoh

Instead of installing everything directly on your Linux system, you run ROS 2 inside a container.

That gives you:

- a reproducible setup
- fewer host dependency conflicts
- an easier way to switch between ROS distributions such as `humble` and `jazzy`
- a cleaner learning environment for tutorials

## 2. The Build-Run-Edit Workflow

The Dockerfile builds the environment, Docker Compose starts it, and your local `src/` folder is mounted into the container so you can edit code normally.

## 3. Why These Tutorials Use Docker

When people start with ROS 2, they often have two problems:

1. installing the right packages takes time
2. one broken dependency can affect the whole system

This repository avoids that by giving you prepared container setups.

You can focus on:

- learning ROS 2
- running examples
- editing your own packages
- understanding how Dockerfiles and Compose files work

The Dockerfiles are also intentionally kept as simple single-stage Dockerfiles so they are easier to read and explain.

## 4. Repository Overview

At the root of the repository, you will find folders like these:

```text
01_ros2_gui/
03_ros2_realsense/
04_ros2_gz_sim/
05_ros2_control/
06_universal_robot/
07_ros2_cartesian_robot_tutorial/
08_ros2_rmw_implementation/
```

Each numbered folder is one tutorial or one scenario.

Inside a typical folder, you will usually see:

- a `Dockerfile-*`
- a `compose.*.yaml`
- an `entrypoint.sh`
- a `bashrc`

### 4.1 Dockerfile, Compose, Entrypoint, and Bashrc

`Dockerfile-*`

- describes how the image is built
- installs packages
- creates the `ros` user
- prepares the ROS 2 workspace

`compose.*.yaml`

- tells Docker how to run the container
- sets environment variables such as `DISPLAY`
- mounts folders from the host into the container
- enables host networking or GUI access when needed

`entrypoint.sh`

- runs when the container starts
- usually prepares the shell environment before you work inside the container

`bashrc`

- custom shell configuration for the user inside the container

## 5. What an Image Is and What a Container Is

Keep this model in mind:

- image = blueprint
- container = running instance of that blueprint

You first build an image from a Dockerfile.
Then you start a container from that image.

In this repository:

- `docker compose ... build` creates the image
- `docker compose ... up` starts the container

## 6. How the Workspace Is Shared with the Container

Most examples mount a local folder called `src/` into the container:

```text
host:      ./src
container: /home/ros/ros2_ws/src
```

This means:

- you edit code on your host machine
- the container sees the same files
- you build and run ROS 2 inside the container

This is the reason the setup feels like a normal development environment instead of a closed box.

## 7. First Exercise: `01_ros2_gui`

`01_ros2_gui` is the best place to start because it is the simplest general-purpose ROS 2 GUI environment.

### 7.1 Requirements

You should have:

- Linux system
- Docker installed 
- Docker Compose available through `docker compose`
- X11 available for GUI applications

You don't need ROS 2 installed on your host.

You should also run:

```bash
xhost +local:docker
```

That allows local Docker containers to open GUI windows on your desktop.

### 7.2 Create the `src/` Folder

From the repository root:

```bash
mkdir -p src
```

This gives Docker something to mount into the ROS 2 workspace.

### 7.3 Why `USER_ID` and `GROUP_ID` Matter

All Dockerfiles in this repository define a container user with configurable `USER_ID` and `GROUP_ID`.

This matters because the container does not work in isolation:

- your local `src/` folder is bind-mounted into the container
- some tutorials also mount `/dev/` devices such as USB or camera devices

If the user inside the container does not match your Linux user well enough, you can run into problems such as:

- files created in `src/` having the wrong owner on the host
- trouble reading or writing mounted files
- permission issues when working with mounted devices

So this is not just a cleanup detail. It is part of making bind mounts and hardware access behave correctly.

If needed, rebuild an image with your host user and group IDs:

```bash
docker compose -f 01_ros2_gui/compose.ros2_gui_humble.yaml build \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g)
```

### 7.4 Build the Image

For example, for ROS 2 Humble:

```bash
docker compose -f 01_ros2_gui/compose.ros2_gui_humble.yaml build
```

For ROS 2 Jazzy:

```bash
docker compose -f 01_ros2_gui/compose.ros2_gui_jazzy.yaml build
```

### 7.5 Start the Container

```bash
docker compose -f 01_ros2_gui/compose.ros2_gui_humble.yaml up
```

When the container starts, you are inside a ROS 2-ready development environment.

## 8. What to Do After the Container Starts

Once the container is running, a common workflow is:

1. put ROS 2 packages into `src/`
2. build them with `colcon`
3. source the workspace
4. run nodes, launch files, RViz, or other tools

Example:

```bash
cd /home/ros/ros2_ws
colcon build --symlink-install
source install/setup.bash
```

If your code is in the host `src/` folder, it will already be visible here.

## 9. Available Tutorial Environments

Here is a simple guide:

`01_ros2_gui/`

- best starting point
- general ROS 2 GUI development

`03_ros2_realsense/`

- for RealSense camera work
- includes device access and camera launch setup

`04_ros2_gz_sim/`

- for GZ Sim / Gazebo-related work
- includes a simulation example

`05_ros2_control/`

- for learning `ros2_control`
- includes a realtime-enabled service variant

`06_universal_robot/`

- for Universal Robots related development

`07_ros2_cartesian_robot_tutorial/`

- focused tutorial setup for a cartesian robot example

`08_ros2_rmw_implementation/`

- for middleware experiments
- useful if you want to compare or test a different RMW implementation such as Zenoh

## 10. How to Modify an Environment

You can customize an environment in two ways.

### 10.1 Add Software to the Image

Edit the Dockerfile if you want to install:

- Ubuntu packages
- ROS 2 packages
- build tools
- Python packages

Example:

```Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  python3-colcon-common-extensions \
  ros-${ROS_DISTRO}-plotjuggler-ros \
  && rm -rf /var/lib/apt/lists/*
```

Then rebuild:

```bash
docker compose -f 01_ros2_gui/compose.ros2_gui_humble.yaml build
```

### 10.2 Add More Mounted Files

Edit the Compose file if you want to add more mounted folders:

```yaml
volumes:
  - ../src:/home/ros/ros2_ws/src
  - ../my-config:/home/ros/config
```

Use this for:

- configuration files
- datasets
- logs
- calibration files

## 11. Where to Start Reading

If you are just learning, focus on these files first:

1. `compose.*.yaml`
2. `Dockerfile-*`

Why this order:

- Compose shows how the container is run
- Dockerfile shows how the environment is built

This is usually easier to understand than starting with shell scripts.

## 12. ROS 2 Versions Used in This Repository

You will see names like:

- `humble`
- `jazzy`
- `foxy`

These are ROS 2 distributions.

Different projects may require different distributions.
This repository helps you switch between them by choosing a different Compose file and Dockerfile instead of reinstalling your host system.

## 13. Troubleshooting

### 13.1 Running Commands from the Wrong Folder

Run the commands from the repository root unless the documentation says otherwise.

### 13.2 Forgetting the `src/` Folder

If the local `src/` folder does not exist, the mount may not behave as expected.

### 13.3 GUI Applications Do Not Open

Check:

- `DISPLAY` is set
- `/tmp/.X11-unix` is mounted
- `xhost +local:docker` was run on the host

### 13.4 Mounted Files Have the Wrong Owner or Permissions

See section `7.3 Why USER_ID and GROUP_ID Matter`.

If the container user does not match your Linux user well enough, bind-mounted files and mounted devices can behave incorrectly.

If needed, rebuild the image with your host user and group IDs:

```bash
docker compose -f 01_ros2_gui/compose.ros2_gui_humble.yaml build \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g)
```

## 14. A simple mental model for the whole repository

If the repository still feels abstract, think of each tutorial folder like this:

- one folder = one prepared lab bench
- Dockerfile = how the lab bench is assembled
- Compose file = how the lab bench is started
- `src/` = the place where you put your own experiment

## 15. Recommended Path Through the Material

This order makes sense:

1. start with `01_ros2_gui`
2. understand how `Dockerfile-*` and `compose.*.yaml` work together
3. create and mount your own `src/` workspace
4. build a simple ROS 2 package with `colcon`
5. move to a more specific tutorial such as `05_ros2_control` or `04_ros2_gz_sim`

## 16. Final Recap

This repository is not just a collection of Dockerfiles.
It is a set of small, reusable ROS 2 learning environments.

The key takeaway is:

- pick one tutorial folder
- build the image
- start the container
- edit code in `src/`
- build and run ROS 2 inside the container

Once that mental model is clear, the rest of the repository becomes much easier to understand.
