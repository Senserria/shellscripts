#!/usr/bin/env bash
set -e

source /etc/os-release

install_packages() {
    case "$ID" in
        ubuntu|debian|kali|linuxmint)
            sudo apt update
            sudo apt install -y zsh git wget curl
            ;;
        centos|rocky|almalinux|rhel|fedora)
            sudo dnf install -y zsh git wget curl
            ;;
        arch)
            sudo pacman -Sy --noconfirm zsh git wget curl
            ;;
        *)
            echo ">>> 不支持的发行版: $ID"
            exit 1
            ;;
    esac
}

echo ">>> 安装依赖包中……"
install_packages

echo ">>> 安装 Oh My Zsh无交互"
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended

echo ">>> 安装 Powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo ">>> 安装 zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo ">>> 安装 zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

ZSHRC="$HOME/.zshrc"

echo ">>> 配置 .zshrc"

# 修改主题
sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$ZSHRC"

# 修改插件
sed -i 's|^plugins=.*|plugins=(git zsh-autosuggestions zsh-syntax-highlighting)|' "$ZSHRC"

if ! grep -q "^plugins=" "$ZSHRC"; then
    echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> "$ZSHRC"
fi

echo ">>> 切换默认 shell 为 zsh"
chsh -s "$(which zsh)"

echo ""
echo ">>> 安装完成!是否继续配置powerlevel10k主题? (y/n) <<<"
read -r answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    exec zsh
fi