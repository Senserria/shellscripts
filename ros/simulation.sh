#!/usr/bin/env bash
set -e
install_ros_simulation() {
    sudo apt update
    sudo apt install -y \
        ros-${ROS_DISTRO}-gazebo-ros-pkgs \
        ros-${ROS_DISTRO}-robot-state-publisher \
        ros-${ROS_DISTRO}-joint-state-publisher \
        ros-${ROS_DISTRO}-joint-state-publisher-gui \
        ros-${ROS_DISTRO}-xacro \
        ros-${ROS_DISTRO}-rviz2
}

echo ">>> 开始安装ROS仿真环境?(y/n) <<<"
read -r answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    install_ros_simulation
    echo ">>> ROS仿真环境安装完成"
fi