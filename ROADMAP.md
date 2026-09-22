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

## ✅ P0 — 本次已完成

- `omarchy` + `omarchy-settings` 锁定包对、bin/ 适配层、/etc 白名单落地
- walker 生态（elephant + walker）、omarchy-zsh/fish、omarchy-emacs、
  omarchy-nvim（配置层）、xdg-terminal-exec、两个系统字体
- 管理基建：upstream-watch、check/bump 脚本、CI（pkgcheck + 每日追版）

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
[docs/omarchy-pkgs-map.md](docs/omarchy-pkgs-map.md)——P2 选题以该文档
「P2 候选」节为权威清单。

## P2 — 应用：Omarchy 自有工具 + 应用清单

Omarchy 的"标志性体验"大半来自自有小工具，全部在 omarchy-pkgs 有配方，
适合逐个移植（Go/Rust/Qt Quick，go-module/cargo ebuild 模式已验证）：

| 工具 | 上游描述 | 优先级 |
|---|---|---|
| tensaku | Wayland 截图标注 | 高（核心交互链路：grim → 标注 → 剪贴板） |
| aether | 从壁纸取色并统一下发主题 | 高（与 theme-set-* 联动，是主题体验的大脑） |
| omacalc | Qt Quick 计算器 | 中 |
| omacut | Qt Quick + ffmpeg 视频裁剪 | 中 |
| omawrite | Qt Quick Markdown 写作 | 中 |
| cliamp | Winamp 风格终端音乐播放器 | 低 |
| herdr | AI coding agent 终端工作台 | 低（依赖 AI 生态，见 P4） |
| ttfx / usage / tobi-try / asdcontrol | 终端特效 / 磁盘用量 / 随手目录 / Apple 显示器亮度 | 低 |

主树应用清单（chromium、libreoffice-fresh、obs-studio、kdenlive、
nautilus + gvfs、mpv、imv、evince、xournalpp、pinta、localsend、
moonlight-qt、yt-dlp、obsidian 等）：以文档化的 emerge 清单为主，仅
主树缺失时建包（如 obsidian 无官方 ebuild，可作 bin 包评估）。

落地形式：`app-misc/omarchy-apps` 建议清单（文档）+ 逐个自有工具 ebuild。

## P3 — 配置：让主题与交互链路端到端跑通

配置数据已随 settings 落地，这一步验证"数据 → 行为"：

1. **主题链路**：`omarchy-theme-set` 全家桶对 default/themed/*.tpl 的改写
   依赖对应应用存在（alacritty/foot/ghostty/kitty/btop/chromium…）；
   与 P1/P2 的应用到位后逐个验证，aether 接管取色。
2. **输入法**：fcitx5 + gtk/qt 模块（base.packages 内），environment.d
   与 user unit 已随 settings 落地，补主树包即可。
3. **会话**：uwsm 会话文件已落地（settings 改装 /usr/share/wayland-sessions）；
   SDDM 主题/自动登录、Hyprland 会话变量复核。
4. **迁移器**：`omarchy update` 触发 `omarchy-migrate`（已 patch），
   验证上游迁移脚本在 Gentoo 的兼容性，不兼容的加入过滤/patch 集。
5. **Plymouth**（可选）：主题数据已装，补 sys-boot/plymouth + 内核参数文档。

## P4 — 其它：扩展面

- **AI agents**：`agents/skills` 是给 Claude Code/OpenAI Codex 的技能文件，
  已随元包落地为数据；herdr + claude-code 等二进制属于 vendor 排除项，
  文档化手动安装路径（npm/官方源），不打包。
- **Gaming**：retroarch、moonlight、steam 相关（base 里有 remove-gaming-*
  命令组）；按需评估，非优先。
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
