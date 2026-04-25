# Dev-containers for ROS 2 development

For a step-by-step explanation of the repository, start with [tutorial_readme.md](./tutorial_readme.md).

## Important Notes

- Depending on your Linux user ID, you may need to modify the Dockerfile user setting, for example:

```Dockerfile
ARG USER_ID=1000
```

- Check your user ID on Linux with:

```bash
id
```

- If your UID is different, update the `ARG USER_ID=...` value in the relevant Dockerfile to match it.
- The Dockerfiles in this repository are intentionally written as single-stage Dockerfiles. They are not optimized as multi-stage builds on purpose, because the goal is to keep them easy to read and explain while learning the basic Dockerfile instructions first.

## 1. Reasons to use Docker for robotics development

1. Run software stacks with incompatible libraries or operating system requirements.
2. Work with NVIDIA Jetson platforms while keeping ROS 2 versions and dependencies under control.
3. Standardize the development environment so the same tools and libraries are available for everyone.
4. Infrastructure as code: using code to define the environments.
5. Cloud development: for example for Nav2 or remote development setups.

## 2. How to Use This Repository

This repository contains small ROS 2 Docker and Docker Compose examples for different learning scenarios such as GUI tools, cameras, simulation, ros2_control, Universal Robots, and middleware experiments.

To use one of the examples, follow these steps:

### 2.1. Build the Docker image

To build the Docker image for a selected tutorial environment, use the following command:

```sh
docker compose -f 01_ros2_gui/compose.ros2_gui_$ROS-DISTRO$.yaml build
```

Replace `$ROS-DISTRO$` with the desired ROS 2 distribution (e.g., `humble`, `jazzy`).

The image is built from the Dockerfile that lives inside the selected tutorial folder.

### 2.2 Run the Docker container

Run the Docker container using the appropriate compose file for your ROS 2 distribution:

```bash
docker compose -f 01_ros2_gui/compose.ros2_gui_humble.yaml up
docker compose -f 01_ros2_gui/compose.ros2_gui_jazzy.yaml up
```

```bash
docker compose -f 05_ros2_control/compose.ros2_control.yaml up
```

```bash
docker compose -f 07_ros2_cartesian_robot_tutorial/compose.ros2_cartesian_robot_tutorial_humble.yaml up
docker compose -f 07_ros2_cartesian_robot_tutorial/compose.ros2_cartesian_robot_tutorial_jazzy.yaml up
```

This will start the selected ROS 2 development container. The selected compose file uses the Dockerfile from that tutorial folder and mounts the local `src/` directory to `/home/ros/ros2_ws/src` inside the container.

Most examples follow the same pattern: one folder contains a Dockerfile, a compose file, and helper files such as `entrypoint.sh` and `bashrc`.

#### Important Notes

- Ensure your host machine has an X11 server running and accessible.
- The `DISPLAY` environment variable is passed to the container to enable GUI applications.
- The `.X11-unix` directory is mounted to allow X11 communication.
- The container runs with `network_mode: host` and `ipc: host` to enable proper communication and shared memory access.

### 2.3 Develop using your container

To develop using the container, open VS Code and work from the local `src/` directory in the repository root. This directory is bound to `/home/ros/ros2_ws/src` inside the container, ensuring your local changes are reflected within the container.

#### Building and Running

Build your ROS 2 packages inside the container and source the workspace:

```sh
colcon build --symlink-install --packages-select <your-package>
source install/setup.bash
```

**Realtime-enabled service:**

```sh
docker compose -f 05_ros2_control/compose.ros2_control.yaml up ros2_control_demos_custom_rt

```

This setup allows you to leverage all your VS Code extensions while developing in a standardized environment.

## 3. How to Customize the Images

The easiest way to customize an image is to edit the Dockerfile in the tutorial folder you want to use.

### 3.1 Add packages to the image

If you want additional Ubuntu or ROS 2 packages, add them to the `apt-get install` section of the Dockerfile. For example:

```Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
  python3-colcon-common-extensions \
  ros-${ROS_DISTRO}-plotjuggler-ros \
  git \
  && rm -rf /var/lib/apt/lists/*
```

After changing the Dockerfile, rebuild the image:

```bash
docker compose -f 01_ros2_gui/compose.ros2_gui_humble.yaml build
```

If Docker still reuses an old cached layer, rebuild with:

```bash
docker compose -f 01_ros2_gui/compose.ros2_gui_humble.yaml build --no-cache
```

### 3.2 Add Python packages

If you need Python packages, install them in the Dockerfile as well so the environment remains reproducible:

```Dockerfile
RUN pip install <package-name>
```

Add your dependencies explicitly to the Dockerfile instead of installing them manually each time in a running container.

### 3.3 Customize the mounted workspace

Most compose files bind-mount a local `src` directory into:

```bash
/home/ros/ros2_ws/src
```

This means you keep editing code on the host machine, while the container builds and runs it.

You can add more bind-mounts in the compose file if you want to share other folders with the container, for example configuration files, datasets, or logs:

```yaml
volumes:
  - ../src:/home/ros/ros2_ws/src
  - ../my-config:/home/ros/config
```

Use bind-mounts for files that change often. Use the Dockerfile for software that should always be present in the image.

### 3.4 Customize users and permissions

All Dockerfiles in this repository define:

```Dockerfile
ARG USER_ID=1001
ARG GROUP_ID=$USER_ID
```

This helps align the container user with your Linux user. If file permissions are wrong in the mounted workspace, rebuild the image with your own UID and GID:

```bash
docker compose -f 05_ros2_control/compose.ros2_control.yaml build \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g)
```

### 3.5 Create your own variant

If you want to keep the original tutorial unchanged, copy one existing folder and adapt it to your own use case. This is a simple workflow:

1. Copy the closest tutorial folder.
2. Rename the Dockerfile and compose file.
3. Add or remove packages step by step.
4. Rebuild and test after each small change.

This makes it easier to understand what each Dockerfile instruction does.


## 4. Available Tutorial Environments

```
01_ros2_gui/
03_ros2_realsense/
04_ros2_gz_sim/
05_ros2_control/
06_universal_robot/
07_ros2_cartesian_robot_tutorial/
08_ros2_rmw_implementation/
```


## GZ Sim

```bash
docker compose -f 04_ros2_gz_sim/compose.ros2_gz_harmonic.yaml up
```


## Build an Image with a Different UID and GID

```sh
# build
docker compose -f 05_ros2_control/compose.ros2_control.yaml build \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  ros2_control_demos_custom_rt
```


```sh
# run
docker compose -f 05_ros2_control/compose.ros2_control.yaml up ros2_control_demos_custom_rt
```
