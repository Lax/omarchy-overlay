# ROADMAP — 对齐 Omarchy 桌面体验

目标：以 [omacom/omarchy](https://github.com/omacom/omarchy) 的结构与节奏，
按 **基础 → 应用 → 配置 → 其它** 逐步补全，最终在 Gentoo 上获得与 Omarchy
一致的使用体验。每一步都遵守仓库模型：上游配方 → 锁定 pin 的 ebuild →
upstream-watch 追版 → 人审合并。

上游参照系（omarchy 仓库 @ pinned commit）：

- `install/omarchy-base.packages` — 默认安装 147 项（体验的真正清单）
- `install/omarchy-other.packages` — 固件/驱动/引导等硬件层 57 项
- `bin/` — 444 个 `omarchy-*` 命令（已随元包全量落地）
- `config/`、`default/` — 配置与主题模板（已随 settings 落地）
- `applications/` — 自带 .desktop 与 webapp 启动器（已落地）
- `agents/`、`manual/` — AI agent 技能与桌面手册
- `pkgs.omarchy.org` — 上游二进制仓库（stable/rc/edge × x86_64/aarch64），
  stable x86_64 188 实包；全量逐包映射见
  [PKGS-MAP.md](PKGS-MAP.md)

## ✅ P0 — 本次已完成

- `omarchy` + `omarchy-settings` 锁定包对、bin/ 适配层、/etc 白名单落地
- walker 生态（elephant + walker）、omarchy-zsh/fish、omarchy-emacs、
  omarchy-nvim（配置层）、xdg-terminal-exec、两个系统字体
- 管理基建：upstream-watch、check/bump 脚本、CI（pkgcheck + 每日追版）
- 厂商应用引用机制 `omarchy-apps/*`：16 个引用元包落地（2026-09）；
  上游包全量映射 PKGS-MAP.md + 维护 skill

## P1 — 基础：把 base.packages 翻译成 Gentoo 基座

上游把"完整体验"装在 ISO 里；Gentoo 没有现成 ISO，翻译 base.packages 是
体验的地基。主树大多数包直接可用，少数要写 ebuild 或记 use 诉求。

| 领域 | 上游项（base/other） | Gentoo 侧 | 状态 |
|---|---|---|---|
| 桌面核心 | hyprland、quickshell、uwsm、sddm、portals | 元包 RDEPEND（guru/hyproverlay） | ✅ |
| 音频 | pipewire、wireplumber、alsa-utils、pamixer | 主树 | ✅ 元包已含 pipewire/wireplumber，其余并入 base 元包 |
| 蓝牙 | bluez、bluez-tools、avahi、nss-mdns | 主树 | P1 |
| 网络 | networkmanager、wireless-regdb、ufw、whois | 主树（NM 已含） | P1 |
| 打印/扫描 | cups 系、system-config-printer | 主树（cups-filters 等） | P1 |
| 电源/显示 | power-profiles-daemon、brightnessctl、ddcutil、bolt | 主树 | P1 |
| 基础 CLI | bat/fd/fzf/eza/jq/ripgrep/starship/zoxide/tmux/… | 主树 | P1（清单化） |
| 字体 | noto 系、font-awesome、ttf-ia-writer、jetbrains-nerd | 主树 + 本 overlay | P1 |
| 容器/虚拟化 | docker、buildx、compose、qemu-user-binfmt | 主树 | P1（可选组） |
| 磁盘/挂载 | dosfstools、exfatprogs、udiskie、gvfs-*、sushi | 主树 | P1 |
| 快速预览/工具 | fastfetch、inxi、tldr、plocate、zbar、qrencode | 主树 | P1 |
| 落地形式 | — | `app-misc/omarchy-base` 元包（RDEPEND 分组）+ `package.use` 建议 | P1 |

有意排除（与 README"有意不移植"一致）：内核（linux-omarchy）、固件层交
sys-kernel/linux-firmware、limine 引导栈、硬件 DKMS 修复包。厂商应用不重
打包：Gentoo 侧已有现成包的经 `omarchy-apps/*` 引用元包落地（2026-09 起，
见 README「厂商应用」节）；无目标的（cursor、claude-desktop、perplexity、
localsend、once 等）维持排除，其中开源的 localsend/once/mise 是后续源码
移植候选。pkgs.omarchy.org 全量包的逐条处置见
[PKGS-MAP.md](PKGS-MAP.md)——P2 选题以该文档
「P2 候选」节为权威清单。

## P2 — 应用：Omarchy 自有工具 + 应用清单

Omarchy 的"标志性体验"大半来自自有小工具。厂商应用已由 `omarchy-apps/*`
引用元包落地（✅ 2026-09，见 README「厂商应用」节）；本阶段是自有工具的
源码移植。候选以 [PKGS-MAP.md](PKGS-MAP.md)
「P2 候选」节为权威清单（65 个 stable 条目，随上游增减），当前分组：

| 优先级 | 工具（上游包名） | 说明 |
|---|---|---|
| 高（核心交互/主题链路） | tensaku、aether、flea、strata、elsewhen、hyprshade、hyprland-preview-share-picker | 截图标注 / 主题大脑 / 文件管理器×2 / 世界时钟插件 / 滤镜 / 分享选择器 |
| 中（Qt Quick 工具链） | omacalc、omacut、omapresent、omawrite、omakade、hype(edge)、omarchy-task-manager(edge) | 计算器 / 裁剪 / 演示 / 写作 / 游戏库 / 任务管理器 |
| 中（omarchy 周边） | omareel、omasnap、omatrack、omazed、owe、owe-lockfeed、herdr、omarchy-herdr、wayfreeze、ttfx | 随上游节奏逐个评估（herdr 依赖 AI 生态，见 P4） |
| 低（官方配套/脚本） | cliamp、learn-omarchy、omarchy-audio-tuner、omarchy-billboard-generator、tobi-try、qmk-hid、asdcontrol、ufw-docker、gliff(edge)、monologue(edge) | |
| 低（无包的开源件，源码移植） | localsend、mise（GURU 已 treeclean）、once、yaru-icon-theme（+8 拆分）、schist 与 lmstudio 源码版残留、vi、symfony-cli、python-sounddevice、python-terminaltexteffects | 明细见映射文档 |
| 按需（RetroArch 生态） | libretro-cap32/database/fbneo/uae-git、libretro-vice-*-git（10 个）、retroarch-joypad-autoconfig-git | ::gentoo 仅 7 个 core，RetroArch 本体在 ::guru |

主树应用清单（chromium、libreoffice-fresh、obs-studio、kdenlive、
nautilus + gvfs、mpv、imv、evince、xournalpp、pinta、moonlight-qt、
yt-dlp、ghostty、sunshine 等）：以文档化的 emerge 清单为主，关键 atoms
已于 2026-09 逐个核实（见映射文档「交上游仓库」节）。两处修正：localsend
无包，移入上面源码移植候选；obsidian 两仓库均无 ebuild，维持 bin 包评估。

落地形式：自有工具逐个 ebuild（go-module/cargo 模式已验证）+ P1 的
`omarchy-base` 元包分组。

## P3 — 配置：让主题与交互链路端到端跑通

配置数据已随 settings 落地，这一步验证"数据 → 行为"：

1. **主题链路**：`omarchy-theme-set` 全家桶对 default/themed/*.tpl 的改写
   依赖对应应用存在（alacritty/foot/ghostty/kitty/btop/chromium…）；
   与 P1/P2 的应用到位后逐个验证，aether 接管取色。
2. **输入法**：fcitx5 + gtk/qt 模块（base.packages 内），environment.d
   与 user unit 已随 settings 落地，补主树包即可（::gentoo 的
   app-i18n/fcitx 即 Fcitx 5，套件见 app-i18n/fcitx-*；上游二进制仓库的
   fcitx5 条目是残留构建）。
3. **会话**：uwsm 会话文件已落地（settings 改装 /usr/share/wayland-sessions）；
   SDDM 主题/自动登录、Hyprland 会话变量复核。
4. **迁移器**：`omarchy update` 触发 `omarchy-migrate`（已 patch），
   验证上游迁移脚本在 Gentoo 的兼容性，不兼容的加入过滤/patch 集。
5. **Plymouth**（可选）：主题数据已装，补 sys-boot/plymouth + 内核参数文档。

## P4 — 其它：扩展面

- **AI agents**：`agents/skills` 是给 Claude Code/OpenAI Codex 的技能文件，
  已随元包落地为数据。CLI 侧已有现成包并经 `omarchy-apps/*` 引用：
  claude-code → dev-util/claude-code（::gentoo）、codex → dev-util/codex、
  opencode → dev-util/opencode-bin（::guru）。桌面版（claude-desktop、
  openai-codex-desktop）与 herdr 维持排除/按需，见映射文档。
- **Gaming**：heroic、minecraft 已由 `omarchy-apps/*` 引用落地；umu-launcher
  在 ::guru（games-util）；RetroArch 本体在 ::guru（games-emulation），
  缺失 core 见 P2 按需组；steam 见 README anyc/steam-overlay 注记。
  base 里有 remove-gaming-* 命令组，按需评估，非优先。
- **文档**：`manual/`（omarchy 桌面手册）可作 `app-misc/omarchy-docs` 或
  指向上游文档站。
- **edge 通道回归**：稳定线打磨后，再评估以 9999 live ebuild 提供
  quattro 跟随（需要 patch 集对 quattro 的持续适配作为前提）。
- **aarch64**：上游有 Apple Silicon 分支（iwd/asahi），暂不在范围。

## 节奏与纪律

- 每个新包：上游 PKGBUILD → ebuild（保持来源 pin）→ upstream-watch 登记
  → 本机实测 → `scripts/check-upstream.sh` 全绿。
- 上游发版：`scripts/bump-omarchy.sh <ver>`（包对锁定 + 适配面 DRIFT 检查），
  打 `omarchy-v<ver>` tag。
