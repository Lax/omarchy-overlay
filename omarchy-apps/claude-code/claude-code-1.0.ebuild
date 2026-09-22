# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: Claude Code -> dev-util/claude-code"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs ships the vendor executable (pkgbuilds/claude-code);
# ::gentoo packages the same tool, so this is a pure reference metapackage.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-util/claude-code"
