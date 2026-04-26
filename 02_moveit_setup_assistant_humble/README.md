## MoveIt Setup Assistant for ROS 2 Humble

This example provides a Docker-based ROS 2 Humble environment for creating a MoveIt configuration package from an existing URDF or Xacro robot description.

The container includes:

- `ur_description`
- `moveit`
- `moveit_setup_assistant`

The workspace `src/` directory from this repository is mounted into the container at `/home/ros/ros2_ws/src`, so generated SRDF and MoveIt configuration files can be written back to the host workspace.

### Prerequisites

- Docker and Docker Compose are installed on the host.
- An X11 server is available on the host.
- The robot description and any dependent packages are present in `src/`.

### Start the Container

From the repository root, allow local X11 access for Docker:

```bash
xhost +local:docker
```

Build and start the container:

```bash
docker compose -f 02_moveit_setup_assistant_humble/compose.moveit_setup_assistant_humble.yaml up --build
```

### Open a Shell in the Running Container

Attach an interactive shell to the running container:

```bash
docker exec -it docker-moveit-setup-assistant-humble-moveit_setup_assistant_humble-1 bash
```

### Build and Source the Workspace

If the robot description depends on packages from the local workspace, build and source the workspace before starting MoveIt Setup Assistant:

In the running container:
```bash
source /opt/ros/humble/setup.bash
colcon build --symlink-install
source install/setup.bash
```

### Launch MoveIt Setup Assistant

Start the Setup Assistant from inside the container:

```bash
ros2 run moveit_setup_assistant moveit_setup_assistant
```

When selecting the robot description in the GUI, choose the top-level URDF or Xacro file that defines a complete robot model.

Example:

```bash
/home/ros/ros2_ws/src/ur_atc_robot_cell/ur_atc_robot_cell_description/urdf/my_robot_cell.urdf.xacro
```

### Generated Output

Use the Setup Assistant to generate:

- the SRDF
- the MoveIt configuration package
- planning group, kinematics, controller, and collision settings

Save the generated package into the mounted workspace under `/home/ros/ros2_ws/src`.
