# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: OpenAI Codex CLI -> dev-util/codex"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs ships the vendor tarball (pkgbuilds/openai-codex-bin);
# ::guru packages the same Rust CLI, so this is a pure reference metapackage.
# The Electron desktop variant (openai-codex-desktop) has no Gentoo package.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-util/codex"
