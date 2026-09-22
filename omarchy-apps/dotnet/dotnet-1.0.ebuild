# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy app reference: .NET SDK -> dev-dotnet/dotnet-sdk-bin"
HOMEPAGE="https://omarchy.org"
# Upstream omarchy-pkgs splits the Microsoft SDK tarballs across six
# sub-packages (pkgbuilds/dotnet-core-bin); ::gentoo packages the SDK as
# dev-dotnet/dotnet-sdk(-bin), so this is a pure reference metapackage.

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-dotnet/dotnet-sdk-bin"
