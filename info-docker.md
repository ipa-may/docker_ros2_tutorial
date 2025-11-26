# Docker, Docker Compose, and This Repository

## What Docker Provides
- **Images** bundle an OS layer, dependencies, tools, and entrypoints into a portable artifact you can reuse across machines.
- **Containers** are running instances of images. They share the host kernel, making them lighter-weight than virtual machines while keeping your ROS 2 toolchain isolated from your laptop’s package set.
- **Layers and caching** mean rebuilds only touch what changed (e.g., the ROS distribution version or added apt packages), which keeps iteration fast once the base layers are cached.
- **Volume mounts** bridge the gap between isolation and productivity: you edit source code on the host while the container runs the build and ROS nodes against that same source tree.

## What Docker Compose Adds
- **Multiple services**: Compose lets you declare one or many containers in YAML, including networking, volumes, and environment variables. Even though most tutorials here launch a single ROS 2 container, Compose keeps configuration discoverable and editable.
- **Profiles and files**: Each tutorial ships its own `compose.*.yaml`, so you can pick a ROS 2 distribution or scenario without editing global config.
- **Lifecycle commands** such as `docker compose build`, `up`, `down`, and `logs` wrap verbose Docker CLI chains with predictable defaults.

## Repository Layout
- `docker/` is the build context for images. Compose files reference it so Docker has access to every `Dockerfile-*` you need.
- `01_ros2_gui/`, `05_ros2_control/`, `07_ros2_cartesian_robot_tutorial/`, etc., each contain a Compose definition tailored to that scenario.
- `src/` (created locally) is mounted into the container at `/home/ros/ros2_ws/src`, so edits you make in VS Code show up instantly inside the workspace.
- Entry points such as `Dockerfile-humble-entrypoint` provide user accounts, dependencies, and ROS setup for the container sessions.

## Typical Workflow
1. **Build the image**:  
   ```bash
   docker compose -f 01_ros2_gui/compose.ros2_gui_<ros-distro>.yaml build
   ```  
   Replace `<ros-distro>` with `humble`, `jazzy`, or any distribution supported in the folder.
2. **Start the dev container**:  
   ```bash
   docker compose -f 01_ros2_gui/compose.ros2_gui_humble.yaml up
   ```  
   This mounts `./src` into the ROS workspace and forwards X11 so GUI tools (RViz, PlotJuggler, Gazebo) run on your desktop. Compose uses `network_mode: host` and `ipc: host` to match typical robotics needs.
3. **Develop inside the container**:  
   ```bash
   colcon build --symlink-install --packages-select <your-package>
   source install/setup.bash
   ```  
   Use your host IDE for editing; run builds, tests, and ROS launch files from the attached terminal in the container.
4. **Stop the container** with `Ctrl+C` in the terminal or `docker compose -f <file> down`. Volumes keep your workspace intact.

## Working with Other Tutorials
- Swap in any other compose file—for example `05_ros2_control/compose.ros2_control.yaml` or the cartesian robot examples under `07_ros2_cartesian_robot_tutorial/`.
- Realtime demos expose additional services (e.g., `ros2_control_demos_custom_rt`) that you can target directly with `docker compose ... up <service-name>`.
- Compose files declare device mounts or environment tweaks needed by each tutorial, so inspect them if you must adapt to custom hardware.

## Extending the Setup
- **Add a new environment** by copying the closest existing directory (e.g., `01_ros2_gui/`) and updating its Compose file plus any matching `Dockerfile-*`.
- **Share dependencies** by keeping common setup inside the `docker/` context, so layers stay cacheable across tutorials.
- **Document new services** in `README.md` or an additional how-to, mirroring the pattern used for current tutorials.

## Troubleshooting Checklist
- X11 errors: confirm an X server is running and that `DISPLAY` (and optionally `xhost +local:docker`) allows container access.
- Volume issues: ensure `src/` exists locally before running `docker compose up`.
- Permission errors: many services run as the `ros` user; if you mount host files created as root, reset ownership (`sudo chown -R $USER:$USER src`).
- Cached builds: if a base layer change does not take effect, rebuild with `--no-cache` or bump the relevant Dockerfile section.

With Docker and Compose, this repository gives you reproducible ROS 2 dev environments that stay isolated yet work seamlessly with your local editor and display stack.
