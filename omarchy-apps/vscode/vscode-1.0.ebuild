# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: Visual Studio Code -> app-editors/vscode"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs repackages the .deb (pkgbuilds/visual-studio-code-bin);
# ::gentoo packages the same official build as app-editors/vscode (renamed
# from visual-studio-code-bin), so this is a pure reference metapackage.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-editors/vscode"
