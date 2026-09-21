# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

inherit font

DESCRIPTION="Subset of the fonts provided by iA Writer"
HOMEPAGE="https://github.com/iaolo/iA-Fonts"
# Duospace was removed upstream; the legacy family is pinned at its last
# revision, mirroring upstream ttf-ia-writer.
IA_COMMIT="f32c04c3058a75d7ce28919ce70fe8800817491b"
IA_LEGACY_COMMIT="b337fe1a4c93026268f70e4b2678371f3e89e2ce"
_IA="https://raw.githubusercontent.com/iaolo/iA-Fonts"
SRC_URI="
	${_IA}/${IA_COMMIT}/iA%20Writer%20Mono/Static/iAWriterMonoS-Bold.ttf
	${_IA}/${IA_COMMIT}/iA%20Writer%20Mono/Static/iAWriterMonoS-BoldItalic.ttf
	${_IA}/${IA_COMMIT}/iA%20Writer%20Mono/Static/iAWriterMonoS-Italic.ttf
	${_IA}/${IA_COMMIT}/iA%20Writer%20Mono/Static/iAWriterMonoS-Regular.ttf
	${_IA}/${IA_COMMIT}/iA%20Writer%20Quattro/Static/iAWriterQuattroS-Bold.ttf
	${_IA}/${IA_COMMIT}/iA%20Writer%20Quattro/Static/iAWriterQuattroS-BoldItalic.ttf
	${_IA}/${IA_COMMIT}/iA%20Writer%20Quattro/Static/iAWriterQuattroS-Italic.ttf
	${_IA}/${IA_COMMIT}/iA%20Writer%20Quattro/Static/iAWriterQuattroS-Regular.ttf
	${_IA}/${IA_COMMIT}/iA%20Writer%20Duo/Static/iAWriterDuoS-Bold.ttf
	${_IA}/${IA_COMMIT}/iA%20Writer%20Duo/Static/iAWriterDuoS-BoldItalic.ttf
	${_IA}/${IA_COMMIT}/iA%20Writer%20Duo/Static/iAWriterDuoS-Italic.ttf
	${_IA}/${IA_COMMIT}/iA%20Writer%20Duo/Static/iAWriterDuoS-Regular.ttf
	${_IA}/${IA_LEGACY_COMMIT}/iA%20Writer%20Duospace/TTF%20(PC)/iAWriterDuospace-Bold.ttf
	${_IA}/${IA_LEGACY_COMMIT}/iA%20Writer%20Duospace/TTF%20(PC)/iAWriterDuospace-BoldItalic.ttf
	${_IA}/${IA_LEGACY_COMMIT}/iA%20Writer%20Duospace/TTF%20(PC)/iAWriterDuospace-Italic.ttf
	${_IA}/${IA_LEGACY_COMMIT}/iA%20Writer%20Duospace/TTF%20(PC)/iAWriterDuospace-Regular.ttf
"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"

FONT_S="${S}"
FONT_SUFFIX="ttf"

src_unpack() {
	default
	# Raw .ttf URLs are not archives: default unpack leaves them in DISTDIR.
	local f
	for f in ${A}; do
		cp -- "${DISTDIR}/${f}" "${S}/" || die
	done
}

src_prepare() { default; }

src_install() {
	font_src_install
}
