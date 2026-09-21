# omarchy-overlay

把 [Omarchy](https://github.com/omacom/omarchy) (Arch/Hyprland 发行版) 的配置层移植到 Gentoo 并持续跟进上游更新。

## 包列表

| 包 | 说明 |
|---|---|
| `app-misc/omarchy-settings` | Omarchy 用户配置、/etc/skel 内容、品牌资源。固定版 (4.0.4) + LIVE 版 (9999, 跟踪上游 quattro 分支) |
| `app-shells/gum` | Charmbracelet gum (Omarchy 脚本依赖)。主树和 GURU 均没有，自带 deps tarball |

## 启用 overlay

```sh
cat > /etc/portage/repos.conf/omarchy-overlay.conf <<'EOF'
[omarchy-overlay]
location = /var/db/repos/omarchy-overlay
sync-type = git
sync-uri = https://github.com/Lax/omarchy-overlay.git
masters = gentoo
auto-sync = yes
priority = 100
EOF
emerge --sync
```

## 安装

```sh
# omarchy-settings 固定版 (推荐, 可复现)
echo '=app-misc/omarchy-settings-4.0.4 **' > /etc/portage/package.accept_keywords/omarchy
emerge -a app-misc/omarchy-settings

# 或 LIVE 版 (持续跟进上游)
echo 'app-misc/omarchy-settings **' >> /etc/portage/package.accept_keywords/omarchy
emerge -a =app-misc/omarchy-settings-9999

# 应用到新用户: emerge 后新建用户即可; 已有用户:
rsync -a --exclude=.bashrc /usr/share/omarchy/config/ ~/.config/
```

## 完整桌面栈

参考 `install-stack.sh` (root 运行)：装 Hyprland/Quickshell/会话管理、音频、Omarchy 整套 CLI 工具。Quickshell 需要 guru overlay，脚本会自动启用。

## 与 Arch 版的有意差异

1. **不覆盖 /etc**：Arch 侧 omarchy-settings 用 post_install 直写 /etc drop-in
   (mkinitcpio/limine/plymouth/nsswitch/cups/faillock)。本 overlay 只装
   source-of-truth 到 /usr/share/omarchy，可选 `USE=skel-seed` 种子 /etc/skel。
   Arch 专属 /etc 配置需按 Gentoo 布局手工合并。
2. **不碰引导**：Gentoo 用 grub/systemd-boot，上游 limine 无对应，快照交给
   你的备份方案 (btrbk/snapper)。
3. **omarchy 运行时 CLI 未打包**：bin/omarchy-* 依赖 pacman 生态，Gentoo 上
   用 emerge/eselect 取代。
