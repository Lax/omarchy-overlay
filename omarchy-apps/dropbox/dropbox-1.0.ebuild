# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: Dropbox -> net-misc/dropbox + net-misc/dropbox-cli"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs ships the vendor tarball plus its own CLI wrapper
# (pkgbuilds/dropbox, pkgbuilds/dropbox-cli); ::gentoo packages both the
# daemon and a CLI, so this is a pure reference metapackage.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	net-misc/dropbox
	net-misc/dropbox-cli
"
