# omarchy 包映射：pkgs.omarchy.org → omarchy-overlay

pkgs.omarchy.org（omarchy 官方 pacman 二进制仓库）全量包 → 本 overlay / Gentoo
侧处置的完整映射。**本文件是映射的唯一 source of truth**；README 的映射表是
其摘要，不一致时以本文件为准并回改 README。

- 数据源：`https://pkgs.omarchy.org/stable/x86_64/omarchy.db`，抓取日期
  **2026-09-22**。
- stable x86_64：**188 个实包**（另有 58 个 `-debug` 符号子包，一律忽略）。
- edge x86_64：200 个实包 = stable −2（opencode、t3code-patched-bin 已移除）
  +14 新增（见「残留与拆分」节）。
- 刷新方式：skill **omarchy-pkgs-map**（`.agents/skills/omarchy-pkgs-map/`，
  附抓取脚本 `scripts/fetch-omarchy-repo.sh`）。
- 处置分类：已移植 24 ｜ 引用 17 ｜ 交上游 15 ｜ P2 候选 65 ｜ 硬件/DKMS
  排除 33 ｜ 设施排除 6 ｜ 无目标厂商排除 28（合计 188；另有 edge 独有 14）。

## 1. 已移植（源码 ebuild）— 24 个上游条目 → 12 个 overlay 包

| 上游包 | overlay 包 | 备注 |
|---|---|---|
| omarchy | `app-misc/omarchy` | 与 settings 锁步 pin |
| omarchy-settings | `app-misc/omarchy-settings` | 同上 |
| omarchy-emacs | `app-editors/omarchy-emacs` | |
| omarchy-nvim | `app-editors/omarchy-nvim` | |
| omarchy-fish | `app-shells/omarchy-fish` | |
| omarchy-zsh | `app-shells/omarchy-zsh` | |
| elephant、elephant-all、elephant-archlinuxpkgs、elephant-bluetooth、elephant-calc、elephant-clipboard、elephant-desktopapplications、elephant-files、elephant-menus、elephant-providerlist、elephant-runner、elephant-symbols、elephant-todo、elephant-unicode、elephant-websearch | `gui-apps/elephant` | 15 个上游包合一；25 个 provider 插件全内置 |
| omarchy-walker | `gui-apps/omarchy-walker` | 元包（walker[::guru] + elephant） |
| xdg-terminal-exec | `x11-misc/xdg-terminal-exec` | |
| ttf-ia-writer | `media-fonts/ia-writer` | |
| ttf-jetbrains-mono-nerd-basic | `media-fonts/jetbrains-mono-nerd-basic` | |

注：`gum` 上游已从 pkgbuilds 移除，overlay 保留 `app-shells/gum` 并直接跟踪
charmbracelet/gum。

## 2. omarchy-apps/* 引用元包 — 17 个上游条目

引用元包无内容（`LICENSE="metapackage"`），RDEPEND 指向真实包：

| 上游包 | 引用包 | 实际包 |
|---|---|---|
| 1password | `omarchy-apps/1password` | gui-apps/1password（guru） |
| 1password-cli | `omarchy-apps/1password-cli` | app-misc/1password-cli（guru） |
| spotify | `omarchy-apps/spotify` | media-sound/spotify |
| claude-code | `omarchy-apps/claude-code` | dev-util/claude-code |
| openai-codex-bin | `omarchy-apps/codex` | dev-util/codex（guru） |
| visual-studio-code-bin | `omarchy-apps/vscode` | app-editors/vscode |
| sublime-text-4 | `omarchy-apps/sublime-text` | app-editors/sublime-text（版本 4_pXXXX） |
| typora | `omarchy-apps/typora` | app-editors/typora-bin（guru） |
| dropbox + dropbox-cli | `omarchy-apps/dropbox` | net-misc/dropbox、net-misc/dropbox-cli |
| heroic-games-launcher-bin | `omarchy-apps/heroic-games-launcher` | games-util/heroic-bin |
| minecraft-launcher | `omarchy-apps/minecraft-launcher` | games-action/minecraft-launcher |
| bambustudio-bin | `omarchy-apps/bambustudio` | media-gfx/bambustudio-bin（guru） |
| bun-bin | `omarchy-apps/bun` | dev-lang/bun-bin（guru） |
| crush-bin | `omarchy-apps/crush` | app-misc/crush（guru） |
| omarchy-chromium-bin（+ 源码版残留 omarchy-chromium） | `omarchy-apps/chromium` | www-client/chromium |

注：`dotnet-core-bin`（pkgbuilds 有配方、**仅 edge 发布**，edge 上拆分为
dotnet-host/runtime/sdk/targeting-pack-bin + aspnet-runtime/targeting-pack-bin）
→ `omarchy-apps/dotnet` → dev-dotnet/dotnet-sdk-bin，未计入 stable 188。

## 3. 交上游仓库（::gentoo / ::guru 已有，不建包）— 15 个上游条目

| 上游包 | Gentoo 侧 | 备注 |
|---|---|---|
| ghostty、ghostty-nautilus、ghostty-shell-integration、ghostty-terminfo | `x11-terms/ghostty` | ::gentoo；拆分子包随主包分发 |
| pinta | `media-gfx/pinta` | ::gentoo |
| sunshine | `net-misc/sunshine` | ::gentoo |
| quickshell-git | `gui-apps/quickshell` | ::guru（9999 覆盖 -git） |
| walker | `gui-apps/walker` | ::guru；经 omarchy-walker 元包引用 |
| nautilus-open-any-terminal | `gnome-extra/nautilus-open-any-terminal` | ::guru |
| gpu-screen-recorder | `media-video/gpu-screen-recorder` | ::guru |
| umu-launcher | `games-util/umu-launcher` | ::guru |
| nautilus-dropbox | `gnome-extra/nautilus-dropbox` | ::gentoo |
| tzupdate | `app-misc/tzupdate` | ::gentoo |
| opencode（stable 残留，edge 已移除） | `dev-util/opencode-bin` | ::guru |
| fcitx5（stable 残留） | `app-i18n/fcitx` | ::gentoo 的 fcitx 即 Fcitx 5 |

## 4. Omarchy 自有工具 / 开源无包 — P2 移植候选（65 个 stable 条目）

| 上游包 | 说明 |
|---|---|
| aether | 主题大脑（壁纸取色统一下发），ROADMAP P2 高优先 |
| flea、strata | 键盘优先文件管理器（quickshell / GTK4） |
| tensaku | 截图标注（grim 链路），高优先 |
| omacalc、omacut、omapresent、omawrite、hype(edge)、monologue(edge) | Qt Quick 小应用 |
| omakade、gliff(edge)、cliamp | 游戏库 / 远程桌面 / 终端音乐播放器 |
| omareel、omasnap、omatrack、omawake-bin、omaspeak-bin、omazed | omarchy 周边小工具（部分为 -bin 厂商产物，随 P2 逐一评估） |
| owe、owe-lockfeed | Omarchy feed/lockfeed |
| herdr、omarchy-herdr | AI 终端工作区管理器（后者带 omarchy 边框支持） |
| elsewhen | Omarchy shell 世界时钟插件 |
| ttfx、wayfreeze | 终端文字特效 / 截图冻结 |
| learn-omarchy、omarchy-audio-tuner、omarchy-billboard-generator、omarchy-task-manager(edge) | 官方教学 / 音频调校 / 宣传片渲染 / 任务管理器 |
| tobi-try、qmk-hid、asdcontrol | ruby 脚本 / QMK HID / Apple 显示器亮度 |
| hyprshade、hyprland-preview-share-picker、hyprland-preview-share-picker-git | Hyprland 滤镜 / 分享选择器（无 Gentoo 包；-git 为残留） |
| yaru-gnome-shell-theme、yaru-gtk-theme、yaru-gtksourceview-theme、yaru-icon-theme、yaru-metacity-theme、yaru-session、yaru-sound-theme、yaru-unity-theme、yaru-xfwm4-theme | Ubuntu Yaru 主题集（9 包），两仓库皆无 |
| ufw-docker、python-sounddevice、python-terminaltexteffects、symfony-cli | 随主工具移植或按需 |
| vi | ::gentoo 无 app-editors/vi；nvi/vim 可替代 |
| localsend、localsend-bin | 开源 AirDrop 替代，Flutter+cargo 构建 |
| mise-bin | GURU 已 treeclean（2026-06）；README 记手动安装 |
| once-bin | Basecamp once，Go 源码可自建 |
| schist、lmstudio | 对应 -bin 包的源码构建残留 |
| libretro-cap32-git、libretro-database-git、libretro-fbneo-git、libretro-uae-git、libretro-vice-x128-git、libretro-vice-x64-git、libretro-vice-x64dtv-git、libretro-vice-x64sc-git、libretro-vice-xcbm2-git、libretro-vice-xcbm5x0-git、libretro-vice-xpet-git、libretro-vice-xplus4-git、libretro-vice-xscpu64-git、libretro-vice-xvic-git、retroarch-joypad-autoconfig-git | RetroArch 扩展生态（15 包）；::gentoo 仅 7 个 core |

## 5. 硬件 / 内核 / DKMS — 有意排除（33 个上游条目）

| 上游包 | 备注 |
|---|---|
| linux-omarchy、linux-omarchy-headers、linux-omarchy-bore、linux-omarchy-bore-headers、linux-omarchy-muqss、linux-omarchy-muqss-headers、linux-ptl、linux-ptl-headers、linux-ptl-audio、linux-ptl-audio-headers、linux-mainline-panther-lake、linux-mainline-panther-lake-headers | 内核层交 sys-kernel/gentoo-sources（README「有意不移植」第 3 条） |
| linux-firmware-cirrus | 交 sys-kernel/linux-firmware |
| nvidia-580xx-utils + nvidia-580xx-dkms + opencl-nvidia-580xx + lib32-nvidia-580xx-utils + lib32-opencl-nvidia-580xx | legacy NVIDIA 拆分包 |
| intel-ipu7-camera、intel-lpmd、v4l2-relayd、python-mediapipe | Intel 相机/功耗/虚拟摄像头/ML 依赖栈 |
| macbook12-spi-driver-dkms、macbook8-spi-pxa2xx-nodma-dkms、tuxedo-drivers-nocompatcheck-dkms、xpadneo-dkms、yt6801-dkms | DKMS 修复包（yt6801 见 README 第 5 条：主线 7.0+ dwmac-motorcomm） |
| libfprint-git、dell-xps-touchpad-haptics、dell-xps13-sidecar-amps | 机型特化补丁 |
| supergfxctl、asusctl（+ rog-control-center 拆分） | asus-linux 生态，::gentoo/GURU 无对应维护 |

注：`omarchy-steam-fex` 为 aarch64 专属（x86 db 不可见），x86 用户 steam 见
README「厂商应用」节 anyc/steam-overlay 注记。

## 6. 仓库设施 — 有意排除（6 个上游条目）

limine-mkinitcpio-hook、limine-snapper-sync（引导栈，第 2 条）、
omarchy-keyring（第 4 条）、yay（Arch 专属）、omarchy-dev、
omarchy-settings-dev（dev 通道变体；overlay 只 pin stable，见 README 三通道
说明）。

## 7. 无目标厂商应用 — 有意排除（27 个上游条目）

多为 Electron/.deb/AppImage，两仓库皆无等价包；用上游渠道或 flatpak 自装：
1password-beta、cursor-bin、cursor-cli、github-copilot-cli、grok-bot、
perplexity、claude-desktop、openai-codex-desktop、hermes-desktop、t3code-bin（+
t3code-patched-bin 残留）、slap-notes-bin、schist-bin、tmog-bin、voxtype-bin、
omawake-bin、omaspeak-bin、link-studio、openclaw、lmstudio-bin、nordvpn-bin、
rustdesk、basecamp-cli、dbxcli-bin、hey-cli、makima-bin、cua-driver-bin、
caja-open-any-terminal（残留）。

## 8. 仓库残留与拆分说明

- **-debug 子包**（58 个）：repo-add 符号包，非独立配方，始终忽略。
- **split 子包归并**：ghostty-*（4）、yaru-*（9）、libretro-vice-*-git（10）、
  nvidia-580xx 系（5）、内核 -headers/-audio、dotnet/aspnet 系（edge）、
  asusctl + rog-control-center、elephant 系（15）。
- **stable 残留**（配方已不在 omarchy-pkgs master 或已被替换）：
  fcitx5、caja-open-any-terminal、lmstudio（源码版）、omarchy-chromium（源码版，
  已被 -bin 取代）、hyprland-preview-share-picker-git、schist（源码版）、
  opencode、t3code-patched-bin、lib32-opencl-nvidia-580xx。
- **仅存在于 pkgbuilds 源码仓库、未进入二进制仓库**：obs-studio、hyprland、
  hyprland-guiutils、hyprtoolkit（obs-studio/hyprland 交主树或 ::guru）。
- **edge 独有（14 个，待观察是否进 stable）**：aspnet-runtime-bin、
  aspnet-targeting-pack-bin、cua-hyprland-plugin、dotnet-host-bin、
  dotnet-runtime-bin、dotnet-sdk-bin、dotnet-targeting-pack-bin、gliff、hype、
  linux-omarchy-ptl-novrr-mm、linux-omarchy-ptl-novrr-mm-headers、monologue、
  omarchy-task-manager、openvino-genai。
