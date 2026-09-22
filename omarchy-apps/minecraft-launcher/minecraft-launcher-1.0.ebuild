# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: Minecraft launcher -> games-action/minecraft-launcher"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs packages the official launcher
# (pkgbuilds/minecraft-launcher); ::gentoo packages the same launcher, so
# this is a pure reference metapackage.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="games-action/minecraft-launcher"
