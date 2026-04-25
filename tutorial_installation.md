# Installation Guide

This guide explains the minimum setup you need before using this repository.

It assumes you want to run the Docker-based ROS 2 tutorials on a Linux laptop or desktop.

## 1. Install Docker

Install Docker Engine by following the official Docker instructions for Linux:

<https://docs.docker.com/engine/install/>

If you are using Ubuntu, use the method called:

`Install using the apt repository`

That is the recommended installation method for most users.

## 2. Do the Docker post-install steps

After Docker is installed, follow the official post-installation steps:

<https://docs.docker.com/engine/install/linux-postinstall/>

The most important step is usually adding your user to the `docker` group so you can run Docker without `sudo`.

Example:

```bash
sudo usermod -aG docker $USER
```

After that, log out and log in again, or reboot your machine, so the group change takes effect.

## 3. Verify that Docker works

Open a new terminal and run:

```bash
docker run hello-world
```

If Docker is installed correctly, you should see a confirmation message from the `hello-world` container.

You can also check that Docker Compose is available:

```bash
docker compose version
```

This repository uses `docker compose`, so this command should work before you continue.

## 4. Clone or open this repository

Make sure the repository is available on your machine, then open a terminal in the repository root:

```bash
cd /path/to/docker_ros2_tutorial
```

All example commands in this repository are expected to be run from the repository root unless stated otherwise.

## 5. Create the local workspace folder

Most tutorial containers mount a local `src/` folder into the ROS 2 workspace inside the container.

Create it once at the repository root:

```bash
mkdir -p src
```

## 6. Enable GUI access for Docker containers

Some tutorials open GUI applications such as RViz, PlotJuggler, or Gazebo.

Before starting those containers, allow local Docker containers to use your X11 display:

```bash
xhost +local:docker
```

If you skip this step, GUI windows may fail to open.

## 7. Build the Required Workshop Images in Advance

Before the workshop, build the images that will be used during the exercises.

For `01_ros2_gui`:

```bash
docker compose -f 01_ros2_gui/compose.ros2_gui_humble.yaml build
docker compose -f 01_ros2_gui/compose.ros2_gui_jazzy.yaml build
```

For `03_ros2_realsense`:

```bash
docker compose -f 03_ros2_realsense/compose.ros2_camera_jazzy.yaml build
```

This step may take some time the first time you run it, so it is better to do it before the workshop starts.

## 8. Recommended next step

After installation, continue with [tutorial_readme.md](./tutorial_readme.md).
