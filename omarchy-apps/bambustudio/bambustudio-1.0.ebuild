# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: Bambu Studio -> media-gfx/bambustudio-bin"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs ships the vendor AppImage payload
# (pkgbuilds/bambustudio-bin); ::guru packages the same binary, so this is
# a pure reference metapackage.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-gfx/bambustudio-bin"
