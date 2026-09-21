# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Proposed standard to launching desktop apps with Terminal=true"
HOMEPAGE="https://gitlab.freedesktop.org/Vladimir-csp/xdg-terminal-exec"
SRC_URI="https://gitlab.freedesktop.org/Vladimir-csp/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-text/scdoc"

src_configure() { :; }

src_compile() {
	emake prefix=/usr
}

src_install() {
	emake DESTDIR="${D}" prefix=/usr install
}
