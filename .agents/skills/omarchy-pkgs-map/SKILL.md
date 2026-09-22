---
name: omarchy-pkgs-map
description: Maintain the omarchy package mapping between pkgs.omarchy.org (upstream Arch binary repo) and the omarchy-overlay (Gentoo). Use whenever the user asks what packages upstream omarchy has, to sync/check/refresh upstream packages, to evaluate/port/exclude an omarchy package, or to update docs/omarchy-pkgs-map.md — even if they don't mention the map file. Also use after any upstream-watch or bump run that changes package coverage.
---

# omarchy-pkgs-map：上游包清单与映射维护

维护 `docs/omarchy-pkgs-map.md`——pkgs.omarchy.org 全量包 → 本 overlay / Gentoo
侧处置的完整映射。该文档是唯一 source of truth；README 的映射表是它的摘要，
两者不一致时以映射文档为准并同步 README。

## 背景

- pkgs.omarchy.org 是 omarchy 官方 pacman 二进制仓库，目录结构
  `<channel>/<arch>/omarchy.db`，channel ∈ {stable, rc, edge}，
  arch ∈ {x86_64, aarch64}。**stable x86_64 是 canonical 集合**；edge 是
  预发布（包更多），rc 介于两者之间；aarch64 另有少量 arm 专属包
  （如 omarchy-steam-fex）。`-debug` 后缀是 repo-add 的符号包子包，不是
  独立配方，一律忽略。
- omacom/omarchy-pkgs（源码配方仓库）与二进制仓库**不是一一对应**：二进制
  仓库含 split 子包（ghostty-terminfo、yaru-gtk-theme、dotnet-sdk-bin…）和
  已删配方的残留构建（如 fcitx5、opencode）。映射以**二进制仓库实际内容**
  为准，残留单独标注。

## 刷新流程

1. 拉取两侧清单（脚本已处理缓存与 -debug 过滤）。本 skill 目录下的脚本：

   ```sh
   .agents/skills/omarchy-pkgs-map/scripts/fetch-omarchy-repo.sh stable x86_64 > /tmp/omarchy-stable.tsv
   .agents/skills/omarchy-pkgs-map/scripts/fetch-omarchy-repo.sh edge x86_64   > /tmp/omarchy-edge.tsv
   ```

2. 与映射文档 diff：`cut -f1 /tmp/omarchy-stable.tsv` 对比
   `docs/omarchy-pkgs-map.md` 各表"上游包"列的并集。产出三类动作：
   新增（进决策树）、消失（从文档移除或标注残留）、仅版本变化（刷新文档
   头部的统计与日期，通常无需改映射）。

3. 新增包按下面的决策树分类，然后改文档；涉及新增 overlay 包的，同步
   README（包列表/映射表/accept_keywords）并跑 `pkgcheck scan --exit`。

4. 更新文档头部：`数据源` 日期、stable/edge 包数、各类计数。

## 决策树（新增包 → 处置）

按顺序判定，命中即停：

1. **内核 / 固件 / DKMS / 硬件驱动 / 引导（limine）** / 仓库设施
   （omarchy-keyring、yay、omarchy-settings-dev、omarchy-dev、*-headers、
   dotnet/aspnet 拆分子包）→ **排除**，写入文档"有意排除"分类，一句话理由。
2. **厂商应用 / 预编译二进制**（-bin、Electron、.deb、AppImage、vendor
   tarball）：查 ::gentoo 与 ::guru 有无等价包——
   - 有 → 建 `omarchy-apps/<app>` 引用元包（下述惯例），并加映射表行；
   - 无 → 不建包，写入"无目标厂商应用"清单 + 替代途径
     （flatpak / 上游渠道 / 源码自建）。
3. **Omarchy 自有工具 / 桌面组件源码**（omarchy-*、oma*、Go/Rust/Qt 项目）：
   - ::gentoo / ::guru 已有等价包且版本可用 → 文档记"交上游仓库" +
     atom，不建包；
   - 没有且属于桌面体验链路 → 评估移植为源码 ebuild（优先级对照
     ROADMAP.md，go-module/cargo 模式已验证）；暂不移植的进 P2 候选清单。
4. **拿不准**：查 omarchy-pkgs 对应 PKGBUILD 的 `depends`/安装内容定性质
   （raw: https://raw.githubusercontent.com/omacom/omarchy-pkgs/master/pkgbuilds/<name>/PKGBUILD），
   并在总结里给出证据再定。

## overlay ebuild 惯例（新增/修改包时）

- EAPI=8；头两行
  `# Copyright 2026, omarchy-gentoo overlay team` +
  `# Distributed under the terms of the MIT license`。
- 引用元包：`LICENSE="metapackage"`、`KEYWORDS="~amd64"`、无 SRC_URI、
  **不写 Manifest**（thin-manifests）；DESCRIPTION 用
  `Omarchy app reference: <App> -> <atom>`。
- **包名不得以 `-数字` 结尾**（PMS 版本解析冲突；先例：sublime-text-4 →
  sublime-text）。GURU 依赖直接 RDEPEND，CI 已豁免不可见依赖检查。
- metadata.xml：Lax maintainer 块 + longdescription 说明映射来源 +
  `<remote-id type="github">omacom/omarchy-pkgs</remote-id>`。
- 版本跟踪：**只有源码移植包**进 `metadata/upstream-watch.conf`；引用元包
  与排除项不注册。
- 文档语言：README 与映射文档用中文；ebuild/metadata.xml 注释用英文。

## 映射文档结构（docs/omarchy-pkgs-map.md）

头部：数据源 URL + 抓取日期、stable/edge 包数、各处置类计数。
正文按处置分类小节，每行 `上游包名 | 版本(可选) | 处置/atom | 备注`。
处置分类：已移植（源码 ebuild）、omarchy-apps/* 引用、交上游仓库
（::gentoo/::guru）、Omarchy 自有工具（P2 候选）、硬件/内核/DKMS 排除、
仓库设施排除、无目标厂商应用、仓库残留/拆分子包说明。

## 输出

刷新/评估后向用户报告：新增包清单及各自处置、移除项、文档改动点；
若新增 overlay 包，附 pkgcheck 结果。不要主动 commit，除非用户要求。
