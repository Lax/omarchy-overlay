# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Emacs integration for Omarchy with automatic theme and font syncing"
HOMEPAGE="https://github.com/scottjones/omarchy-emacs"
SRC_URI="https://github.com/scottjones/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-editors/emacs"

src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto /usr/share/omarchy-emacs/config
	doins config/init.el config/omarchy.el config/shell-bashrc
	insinto /usr/share/omarchy-emacs/config/themes
	doins config/themes/omarchy-theme.el
	insinto /usr/share/omarchy-emacs
	doins omarchy-colors.el.tpl

	# Theme/font sync hooks picked up by omarchy-theme-set / omarchy-font-set.
	exeinto /usr/share/omarchy-emacs/hooks
	doexe hooks/font-set hooks/theme-set

	dobin bin/omarchy-emacs-setup bin/omarchy-emacs-sync-hooks \
		bin/omarchy-restart-emacs bin/omarchy-install-emacs

	dodoc README.md
}
