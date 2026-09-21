# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Pre-built LazyVim configuration for Omarchy (Gentoo port, config layer)"
HOMEPAGE="https://github.com/LazyVim/LazyVim"
# The recipe payload (lua/, plugin/, lazyvim.json, omarchy-nvim-setup) lives in
# the omarchy-pkgs repo itself, so the ebuild pins that repo. The LazyVim
# starter is a moving branch upstream; this overlay pins its commit.
PKGS_COMMIT="23394639cca35d993d8eb3ec042181520cadb6ed"
STARTER_COMMIT="803bc181d7c0d6d5eeba9274d9be49b287294d99"
SRC_URI="
	https://github.com/omacom/omarchy-pkgs/archive/${PKGS_COMMIT}.tar.gz -> omarchy-pkgs-${PKGS_COMMIT}.tar.gz
	https://github.com/LazyVim/starter/archive/${STARTER_COMMIT}.tar.gz -> lazyvim-starter-${STARTER_COMMIT}.tar.gz
"
S="${WORKDIR}/omarchy-pkgs-${PKGS_COMMIT}/pkgbuilds/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-editors/neovim
	dev-vcs/git
"

# Gentoo deviation (documented in the overlay README): upstream builds the
# plugin cache headlessly inside its build sandbox — network access at build
# time, which portage forbids. This package ships the config layer only;
# lazy.nvim syncs the plugins on first launch, and omarchy-nvim-setup is
# patched to make the absent data seed optional.
src_prepare() {
	default
	eapply "${FILESDIR}"/omarchy-nvim-setup-data-optional.patch
}

src_install() {
	# Merge the pinned LazyVim starter with Omarchy's custom configs — the
	# upstream build() recipe, minus the headless plugin install.
	local config="${T}/config"
	mkdir -p "${config}" || die
	cp -a "${WORKDIR}/starter-${STARTER_COMMIT}/." "${config}/" || die
	rm -rf "${config}/.git" || die
	cp -a lua plugin lazyvim.json "${config}/" || die

	insinto /usr/share/omarchy-nvim
	doins -r "${config}/."

	# Seed NEW users via /etc/skel (config only); the theme symlink resolves
	# under any user's home, exactly as upstream seeds it.
	insinto /etc/skel/.config
	doins -r "${config}"
	dosym ../../../../.local/state/omarchy/current/theme/neovim.lua \
		/etc/skel/.config/nvim/lua/plugins/theme.lua

	dobin omarchy-nvim-setup
	dosym omarchy-nvim-setup /usr/bin/omarchy-nvim-refresh
}

pkg_postinst() {
	elog "For an existing user, run: omarchy-nvim-setup   (or omarchy-nvim-refresh to reset)"
	elog "Plugins sync on first Neovim launch; no prebuilt cache ships (see README)."
}
