# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: Sublime Text 4 -> app-editors/sublime-text"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs ships the vendor tarball (pkgbuilds/sublime-text-4);
# ::gentoo packages the same editor as app-editors/sublime-text (versions
# 4_pXXXX), so this is a pure reference metapackage.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-editors/sublime-text"
