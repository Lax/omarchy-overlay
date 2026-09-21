# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

inherit shell-completion

DESCRIPTION="Omarchy shell configuration for Fish (Gentoo port)"
HOMEPAGE="https://github.com/omacom-io/omarchy-fish"
FZF_FISH_PV="10.3"
SRC_URI="
	https://github.com/omacom-io/omarchy-fish/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/PatrickF1/fzf.fish/archive/refs/tags/v${FZF_FISH_PV}.tar.gz -> fzf.fish-${FZF_FISH_PV}.tar.gz
"
S="${WORKDIR}/${P}"

LICENSE="MIT BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-shells/fish
	app-shells/fzf
	dev-vcs/git
	sys-apps/bat
	sys-apps/fd
"

src_configure() { :; }
src_compile() { :; }

src_install() {
	# fzf.fish vendored into the fish vendor directories, then omarchy-fish's
	# own conf.d/functions/completions on top (dotglob for leading-dot
	# function names like ....fish — mirrors the upstream PKGBUILD).
	insinto /usr/share/fish/vendor_conf.d
	doins "${WORKDIR}/fzf.fish-${FZF_FISH_PV}/conf.d/"*.fish
	insinto /usr/share/fish/vendor_functions.d
	doins "${WORKDIR}/fzf.fish-${FZF_FISH_PV}/functions/"*.fish
	dofishcomp "${WORKDIR}/fzf.fish-${FZF_FISH_PV}/completions/"*.fish

	insinto /usr/share/fish/vendor_conf.d
	doins conf.d/*.fish
	insinto /usr/share/fish/vendor_functions.d
	doins functions/*.fish
	dofishcomp completions/*.fish

	# Templates and documentation.
	insinto /usr/share/omarchy-fish
	doins -r templates
	dodoc README.md
	insinto /usr/share/licenses/${PF}
	newins "${WORKDIR}/fzf.fish-${FZF_FISH_PV}/LICENSE.md" LICENSE.fzf.fish
	newdoc "${WORKDIR}/fzf.fish-${FZF_FISH_PV}/README.md" README.fzf.fish.md

	dobin bin/omarchy-setup-fish
}

pkg_postinst() {
	elog "To set fish as default shell, run: omarchy-setup-fish"
}
