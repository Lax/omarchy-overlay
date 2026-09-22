# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: Chromium -> www-client/chromium"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs ships the vendor binary (pkgbuilds/omarchy-chromium-bin);
# ::gentoo builds the same browser from source, so this is a pure reference
# metapackage (the README previously mapped this by hand).

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="www-client/chromium"
