# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: Spotify -> media-sound/spotify"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs repackages the vendor client (pkgbuilds/spotify);
# ::gentoo packages the same official client, so this is a pure reference
# metapackage.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-sound/spotify"
