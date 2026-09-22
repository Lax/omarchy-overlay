# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: 1Password CLI (op) -> app-misc/1password-cli"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs ships the signed vendor zip (pkgbuilds/1password-cli);
# ::guru packages the same tool, so this is a pure reference metapackage.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-misc/1password-cli"
