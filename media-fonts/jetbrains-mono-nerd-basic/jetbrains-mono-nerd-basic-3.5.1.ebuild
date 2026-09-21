# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

inherit font

DESCRIPTION="Basic JetBrains Mono Nerd Font family"
HOMEPAGE="https://github.com/ryanoasis/nerd-fonts"
SRC_URI="https://github.com/ryanoasis/nerd-fonts/releases/download/v${PV}/JetBrainsMono.zip -> JetBrainsMono-${PV}.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"
# Only the core faces ship (mirrors upstream's -basic split); text is rendered
# without the icon glyph subsets, which the shell themes do not use.

BDEPEND="app-arch/unzip"
FONT_S="${S}"
FONT_SUFFIX="ttf"

src_prepare() {
	default
	local keep
	for keep in *.ttf; do
		case ${keep} in
			JetBrainsMonoNerdFont-Regular.ttf|\
			JetBrainsMonoNerdFont-Bold.ttf|\
			JetBrainsMonoNerdFont-Italic.ttf|\
			JetBrainsMonoNerdFont-BoldItalic.ttf)
				;;
			*)
				rm -f "${keep}"
				;;
		esac
	done
}

src_install() {
	font_src_install
	insinto /usr/share/licenses/${PN}
	doins OFL.txt
}
