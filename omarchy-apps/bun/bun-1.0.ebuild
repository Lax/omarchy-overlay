# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: Bun -> dev-lang/bun-bin"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs ships the vendor zips (pkgbuilds/bun-bin);
# ::guru packages the same runtime, so this is a pure reference metapackage.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-lang/bun-bin"
