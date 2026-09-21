# omarchy

[Omarchy](https://github.com/omacom/omarchy)（Arch/Hyprland 发行版）的**非官方**
Gentoo 移植，并按上游 [omacom/omarchy-pkgs](https://github.com/omacom/omarchy-pkgs)
的方式管理本仓库：每包一份 checked-in 配方 + upstream-watch 自动追版 + 人审合并 +
`omarchy`/`omarchy-settings` 包对锁定同步 pin。

演进计划见 [ROADMAP.md](ROADMAP.md)——按 **基础 / 应用 / 配置 / 其它** 逐步
对齐 Omarchy 桌面体验。

> 上游的 canonical 仓库在 `omacom/*`；`basecamp/*` 目前只是重定向。

## 移植模型（PKGBUILD ↔ ebuild 对照）

| omarchy-pkgs / Arch | 本 overlay / Gentoo |
|---|---|
| PKGBUILD（`source#commit=` pin） | ebuild，`OMARCHY_COMMIT` pin 同一 commit |
| `omarchy` + `omarchy-settings` 锁定同步 pin | 同一对 ebuild，`~app-misc/omarchy-settings-${PV}` 锁定，`scripts/bump-omarchy.sh` 保证同步 |
| stable / rc / edge 三通道二进制仓库 | pinned 版 = stable；edge/rc 暂不提供（ROADMAP.md） |
| `.omarchy/package.json` upstream watch | `metadata/upstream-watch.conf` + `scripts/check-upstream.sh`（git ls-remote，无 token） |
| `bin/omarchy-release` pin 引擎 | `scripts/bump-omarchy.sh`（见下） |
| `backup=()` 保护 /etc | portage `CONFIG_PROTECT`（内建且更强） |
| `.INSTALL` post_install | `pkg_postinst` + elog（绝不静默覆盖） |
| libalpm hooks（update guard / reload pause） | 无对应物，不移植；用 `omarchy update` 代替裸 emerge |
| pacman / yay / AUR | emerge / eselect repository / guru 等第三方 overlay |
| `vercmp` ATTACHED 预发布号 | PMS `_rc` 后缀（排序语义相同：`4.0.0_rc1 < 4.0.0`） |
| arch=any | `KEYWORDS="~amd64"`，数据类同 `all` |

发版纪律沿用上游：pinned 版只保留最新一个（历史在 git tag 里），每次发版
原地改写 pin；pkgrel 用 `-r1` 重打包；epoch 留给人工。

## 包列表

| 包 | 上游 | 说明 |
|---|---|---|
| `app-misc/omarchy` | pkgbuilds/omarchy | 元包：`omarchy-*` 运行时 CLI、themes、quickshell shell、migrations，RDEPEND 带动整套桌面 |
| `app-misc/omarchy-settings` | pkgbuilds/omarchy-settings | config source-of-truth、/etc/skel、/etc drop-in、systemd user units、SDDM/Plymouth 主题、字体、品牌 |
| `app-shells/gum` | charmbracelet/gum | Omarchy 脚本依赖，主树/GURU 没有；deps tarball 自托管 |
| `gui-apps/elephant` | abenz1267/elephant | walker 的 provider 守护进程；上游拆成十余个包，这里合并为单一 ebuild（守护进程 + 25 个 provider 插件） |
| `gui-apps/omarchy-walker` | pkgbuilds/omarchy-walker | 元包：guru 的 walker + 本 overlay 的 elephant |
| `x11-misc/xdg-terminal-exec` | Vladimir-csp/xdg-terminal-exec | Terminal=true 桌面条目解析 |
| `app-shells/omarchy-zsh` | omacom-io/omarchy-zsh | zsh 配置（omadots pin 在本 overlay） |
| `app-shells/omarchy-fish` | omacom-io/omarchy-fish | fish 配置（fzf.fish 内置） |
| `app-editors/omarchy-emacs` | scottjones/omarchy-emacs | Emacs 主题/字体同步 |
| `app-editors/omarchy-nvim` | omarchy-pkgs 内置配方 | LazyVim 配置层；见下方偏差说明 |
| `media-fonts/jetbrains-mono-nerd-basic` | ryanoasis/nerd-fonts | 系统 UI 字体（-basic 四字重） |
| `media-fonts/ia-writer` | iaolo/iA-Fonts | 写作字体（Duospace 侧封存于上游已删的 commit） |

## 启用与安装

```sh
sudo eselect repository add omarchy git https://github.com/Lax/omarchy-overlay.git
sudo emerge --sync omarchy
```

overlay 内的包都是 ~amd64，desktop 依赖部分来自 ::guru / ::hyproverlay：

```sh
# /etc/portage/package.accept_keywords/omarchy
# — 稳定通道全部用 ~amd64
app-shells/gum ~amd64
app-misc/omarchy ~amd64
app-misc/omarchy-settings ~amd64
gui-apps/elephant ~amd64
gui-apps/omarchy-walker ~amd64
x11-misc/xdg-terminal-exec ~amd64
app-shells/omarchy-zsh ~amd64
app-shells/omarchy-fish ~amd64
app-editors/omarchy-emacs ~amd64
app-editors/omarchy-nvim ~amd64
media-fonts/jetbrains-mono-nerd-basic ~amd64
media-fonts/ia-writer ~amd64
# — omarchy-zsh 需要的主树 ~amd64 包
app-shells/zoxide ~amd64
# — ::guru / ::hyproverlay 桌面依赖
gui-apps/quickshell ~amd64
gui-apps/walker ~amd64
gui-libs/gtk4-layer-shell ~amd64
gui-libs/xdg-desktop-portal-hyprland ~amd64
dev-cpp/sdbus-c++ ~amd64
dev-cpp/cpptrace ~amd64
dev-libs/libdwarf ~amd64

# /etc/portage/package.use/omarchy
dev-cpp/cpptrace unwind
# 全局 USE 开了 vala 时必需（gtk4-layer-shell 的 REQUIRED_USE 约束）
gui-libs/gtk4-layer-shell introspection
```

edge/rc 通道暂不提供（仅 pin 上游正式 tag，见 ROADMAP.md）。

安装：

```sh
emerge -a app-misc/omarchy            # 整套桌面 + CLI
emerge -a gui-apps/omarchy-walker     # launcher 生态（walker + elephant）

# 或只要配置层：
emerge -a app-misc/omarchy-settings
```

已有用户应用配置（新用户经 /etc/skel 自动获得）：

```sh
rsync -a --exclude=.bashrc /usr/share/omarchy/config/ ~/.config/
omarchy-nvim-setup        # 装了 omarchy-nvim 的话
```

mise 不在 Gentoo 仓库中（手动安装，如 `curl https://mise.run | sh`）。
settings 会装 `/etc/mise/conf.d/omarchy.toml`，其中 `[tool_alias]` 字段需要
**mise ≥ 2025.12**；旧版会对该字段报 `unknown field` 警告并忽略——升级 mise 即可。

## 启动方式：SDDM 可选，支持 startx 式命令

SDDM 只是可选门面，不需要 `systemctl enable sddm`。在 TTY 登录后：

```sh
omarchy-start          # startx 的等价物 = uwsm start omarchy.desktop
```

- 无需手工 enable 任何服务：uwsm 把会话接入 systemd --user 的
  graphical-session.target，`config/autostart` 由 xdg-desktop-autostart.target
  接管（Wayland 会话本身依赖 systemd 用户实例，这是 uwsm 的设计，非额外服务）。
- 注销走 Hyprland 菜单里的退出项，或 `uwsm stop`。
- 其它启动器（greetd/ly/…）直接指向 wayland-sessions 的 `omarchy.desktop`
  即可；SDDM 主题与自动登录配置已随 omarchy-settings 装好。

## bin/ 适配层（pacman → portage）

444 个 `bin/omarchy-*` 脚本中仅 38 个引用 pacman/yay。移植策略：

- **25 个重写为 portage 版**（`app-misc/omarchy/files/gentoo-bin/`）：
  `omarchy update`（emerge --sync + -uDN @world）、`omarchy pkg
  add/drop/install/remove`（qlist/eix/fzf + emerge --noreplace/--depclean）、
  `omarchy-channel-*`（pinned=edge 映射）等；AUR/keyring/guard 类为解释性 stub。
- **9 个小 patch**（`files/omarchy-gentoo-*.patch`）：omarchy-migrate、
  omarchy-debug、omarchy-update-restart 等，其余内容保持上游原样。
- 其余 400+ 脚本原样安装。`scripts/bump-omarchy.sh` 在每次发版时重新扫描
  上游 bin/ 的 pacman 依赖面，超出已知适配集会显式报 DRIFT。

## 有意不移植（与 Arch 的差异）

1. **/etc 落地遵循 Gentoo 惯例**：settings 以白名单方式把可映射 drop-in
   （sysctl.d、logind/sddm/resolved/systemd conf.d、zram、udev、sudoers.d
   等）装入 /etc，交给 CONFIG_PROTECT 保护（pacman `backup=()` 的等价物且
   更强）；Arch 专属的 mkinitcpio/limine/plymouthd.conf/faillock/nsswitch/
   cups sysuser/zswap-禁用 一律过滤，完整参照 ebuild 内 `OMARCHY_ETC_KEEP`
   注释。
2. **不碰引导**：上游 limine + snapper 快照栈不移植；Gentoo 用
   grub/systemd-boot + 你自己的快照方案。
3. **内核**：linux-omarchy（bore/ptl）不移植，用 sys-kernel/gentoo-sources。
4. **omarchy-keyring**：portage 按仓库 Manifest 校验，无 keyring 概念。
5. **vendor 二进制**（omarchy-chromium-bin、1password、spotify、claude-code
   等）与硬件 DKMS 修复包不移植；chromium 用 www-client/chromium。
6. **libalpm hooks**：无 portage 通用对应物，不移植。
7. **os-release 覆盖**：上游把 /etc/os-release 改写成 Omarchy；Gentoo 保留
   自己的身份信息，参考副本在 `/usr/share/omarchy/etc-overrides/`。
8. **omarchy-nvim**：上游在打包时联网预拉插件缓存；portage 构建沙箱禁止
   联网，故只发配置层，`lazy.nvim` 在用户首次启动时同步插件
   （`omarchy-nvim-setup` 已适配）。
9. **elephant/omarchy-walker 合并**：上游按 pacman 增量升级拆 provider 包；
   源码 overlay 一并重建即可，收敛为单一 ebuild。
10. **仅支持 systemd**（user units、uwsm、SDDM）。

## 维护流程（omarchy-pkgs 式）

```sh
scripts/check-upstream.sh        # 全部包的版本漂移检查（CI 每日运行并开 issue）
scripts/bump-omarchy.sh 4.0.5    # 包对 pin 引擎：
                                 #  1. 解析 tag → commit，下载新 tarball
                                 #  2. 重扫 bin/ 的 pacman 依赖面（DRIFT 则中止）
                                 #  3. 锁定同步改写两个 ebuild 并 git mv
                                 #  4. 刷新 omarchy-nvim 的 pkgs 配方 pin
                                 #  5. 重生成 Manifest，输出提交信息
git tag omarchy-v4.0.5           # 发版即打 tag（历史即版本档案）
```

其它包手动 bump 版本 + `ebuild ... manifest`，`metadata/upstream-watch.conf`
同步更新当前 pin。CI：`pkgcheck scan` + 每日 upstream-watch。
