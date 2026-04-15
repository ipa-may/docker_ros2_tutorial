# Dev-containers for ROS 2 development

Important Notes

- Depending on your Linux user ID, you may need to modify the Dockerfile user setting, for example:

```Dockerfile
ARG USER_ID=1000
```

- Check your user ID on Linux with:

```bash
id
```

- If your UID is different, update the `ARG USER_ID=...` value in the relevant Dockerfile to match it.

## 1. Reasons to use Docker for robotics development

1. Running incompatible libraries and OS.
2. Useful for using NVidia Jetsons. NVidia provides IDE Jetpack. Possible to use Jetpack with docker and any version of ROS necessary
3. Standardised a development environment: same tools and libraries4. Infrastructure as code: using code to define the environments
4. Cloud development: example for nav2

## 2. How to Use this repository

To use the GUI setup with ROS 2, follow these steps:

### 2.1. Build the Docker image

To build the Docker image for ROS 2 with GUI support, use the following command:

```sh
docker compose -f 01_ros2_gui/compose.ros2_gui_$ROS-DISTRO$.yaml build
```

Replace `$ROS-DISTRO$` with the desired ROS 2 distribution (e.g., `humble`, `jazzy`).

The build context for Docker is docker/.

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

This will start a Docker container configured for ROS 2 with GUI support. The container uses the `Dockerfile-humble-entrypoint` to build the image and mounts the `src` directory to `/home/ros/ros2_ws/src` inside the container.

#### Important Notes

- Ensure your host machine has an X11 server running and accessible.
- The `DISPLAY` environment variable is passed to the container to enable GUI applications.
- The `.X11-unix` directory is mounted to allow X11 communication.
- The container runs with `network_mode: host` and `ipc: host` to enable proper communication and shared memory access.

### 2.3 Develop using your container

To develop using the container, open VS Code and work from the local `/src` directory. This directory is bound to `/home/ros/ros2_ws/src` inside the container, ensuring your local changes are reflected within the container.

#### Building and Running

Build your ROS 2 packages inside the container and source the workspace:

```sh
colcon build --symlink-install --packages-select <your-package>
source install/setup.bash
```

**realtime enabled:**

```sh
docker compose -f 05_ros2_control/compose.ros2_control.yaml up ros2_control_demos_custom_rt

```

This setup allows you to leverage all your VS Code extensions while developing in a standardized environment.

## 3. How to add Docker images to this repository?

## 4. List of usable dev containters with tutorials

```
01_ros2_gui/
03_ros2_realsense/
04_ros2_gz_sim/
05_ros2_control/
06_universal_robot/
07_ros2_cartesian_robot_tutorial/
08_ros2_rmw_implementation/
```

Tools:

- Rviz
- Plotjuggler
- Gazebo harmonics with cartesian robot example (gantry)
- ros2 control
- Realsense with ROS 2 and opencv bridges with simple examples
- Zenoh setup

Todo:

- BT Tree with simple examples
- nav2

- tesseract

- PDDL and PlanSys2 : <https://github.com/fjrodl/PDDL-course>
  <https://kas-lab.github.io/mirte_playground/mirte_pddl.html>

- Trainings: Turtlebot4 :
  TODO: Docker images: <https://github.com/IntelligentRoboticsLabs/docker_infrastructure/tree/main>

- Training: Manipulation : <https://gitlab.cc-asp.fraunhofer.de/ipa326/manipulation_training>

- Training: DDS

- Convince : <https://convince-project.github.io/AS2FM/installation.html>

## GZ Sim

```bash
docker compose -f compose.ros2_gz_harmonic.yaml up
```

## Realsense

### Launch

```bash
docker compose -f compose.ros2_camera.yaml up
```

### Installatino

Test the realsense:

Install the realsense SDK:

```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6B0FC61
sudo add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo $(lsb_release -cs) main"
sudo apt update
sudo apt install librealsense2-utils
```

Run the viewer:

```bash
realsense-viewer
```


## Build the image with other UID and GUID

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
