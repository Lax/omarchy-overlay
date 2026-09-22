# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: 1Password -> gui-apps/1password"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs ships the signed vendor tarball (pkgbuilds/1password);
# ::guru packages the same client, so this is a pure reference metapackage.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="gui-apps/1password"
