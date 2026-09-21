#!/usr/bin/env bash
# Omarchy → Gentoo 一键安装脚本 (root 运行, 需先启用 omarchy-overlay)
set -euo pipefail

# 确保 guru overlay 存在 (quickshell 需要)
if ! eselect repository list 2>/dev/null | grep -q "guru"; then
	eselect repository enable guru
fi
emerge --sync

echo "=== [1/3] 桌面核心 (Hyprland + Quickshell + 会话) ==="
emerge -a \
	gui-wm/hyprland \
	gui-libs/quickshell \
	gui-apps/uwsm \
	x11-misc/sddm \
	gui-libs/xdg-desktop-portal-hyprland \
	sys-apps/xdg-desktop-portal-gtk

echo "=== [2/3] 音频 / 认证 / 终端 ==="
emerge -a \
	media-video/pipewire \
	media-session/wireplumber \
	app-crypt/gnome-keyring \
	gui-apps/foot \
	x11-terms/kitty

echo "=== [3/3] 工具链 (omarchy 脚本运行需要) ==="
emerge -a \
	dev-vcs/git \
	app-misc/jq \
	dev-lang/perl \
	app-shells/zsh \
	app-shells/zoxide \
	app-shells/starship \
	app-shells/fzf \
	app-shells/gum \
	sys-apps/bat \
	sys-process/btop \
	sys-apps/ripgrep \
	sys-apps/fd \
	app-misc/tmux \
	app-editors/neovim \
	gui-apps/grim \
	gui-apps/slurp \
	gui-apps/wl-clipboard \
	media-gfx/imagemagick \
	media-video/mpv \
	net-misc/networkmanager \
	net-misc/socat

echo
echo "完成。下一步:"
echo "  echo '=app-misc/omarchy-settings-4.0.4 **' > /etc/portage/package.accept_keywords/omarchy"
echo "  emerge -a app-misc/omarchy-settings"
echo "  rsync -a --exclude=.bashrc /usr/share/omarchy/config/ ~/.config/"
echo "  systemctl enable --now sddm"
