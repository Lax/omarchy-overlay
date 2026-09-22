# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: Typora -> app-editors/typora-bin"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs repackages the .deb (pkgbuilds/typora);
# ::guru packages the same binary, so this is a pure reference metapackage.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-editors/typora-bin"
