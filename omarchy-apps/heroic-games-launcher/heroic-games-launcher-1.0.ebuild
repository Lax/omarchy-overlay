# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: Heroic Games Launcher -> games-util/heroic-bin"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs ships the vendor AppImage payload
# (pkgbuilds/heroic-games-launcher-bin); ::gentoo packages the same launcher
# as games-util/heroic-bin, so this is a pure reference metapackage.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="games-util/heroic-bin"
