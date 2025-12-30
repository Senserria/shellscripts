#!/usr/bin/env bash
set -e

source /etc/os-release

# 请根据Linux发行版修改此函数以安装必要的软件包
install_docker() {
    case "$ID" in
        ubuntu|debian|kali|linuxmint)
            sudo apt update
            sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
            sudo curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/$ID/gpg | sudo apt-key add -
            sudo add-apt-repository -y "deb [arch=$(dpkg --print-architecture)] https://mirrors.aliyun.com/docker-ce/linux/$ID $(lsb_release -cs) stable"
            sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
        centos|rocky|alinux|almalinux|rhel|fedora)
            sudo dnf install -y zsh git wget curl
            sudo wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
            sudo sed -i 's|https://mirrors.aliyun.com|http://mirrors.cloud.aliyuncs.com|g' /etc/yum.repos.d/docker-ce.repo
            sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
        *)
            echo ">>> 不支持的发行版: $ID"
            echo ">>> 您可以修改脚本以添加对您发行版的支持"
            exit 1
            ;;
    esac
}

echo ">>> 注意:本脚本默认使用外网下载资源,请确保您的服务器可以访问外网 <<<"
echo ">>> 请注意流量消耗以免造成额外费用 <<<"
echo ">>> 是否继续? (y/n) <<<"
read -r answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    install_docker
    echo ">>> Docker 安装完成"
    echo ">>>正在启动 Docker 服务..."
    sudo systemctl start docker
    sudo systemctl enable docker
    echo ">>> Docker 服务已启动"
    echo "是否设置当前用户免sudo使用Docker? (y/n) <<<"
    read -r sudo_answer
    if [[ "$sudo_answer" =~ ^[Yy]$ ]]; then
        sudo usermod -aG docker "$USER"
        echo ">>> 当前用户已添加到docker用户组,请重新登录以使设置生效"
        echo ">>> 如果没有生效的话,请重新启动"
    fi
fi
