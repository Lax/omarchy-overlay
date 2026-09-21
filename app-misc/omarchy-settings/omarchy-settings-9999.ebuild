# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

inherit git-r3

DESCRIPTION="Omarchy user defaults, /etc/skel content, fonts, branding, and settings package (Gentoo port)"
HOMEPAGE="https://github.com/omacom/omarchy"
SRC_URI=""
EGIT_REPO_URI="https://github.com/omacom/omarchy.git"
EGIT_BRANCH="quattro"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+skel-seed"

DEPEND=""
RDEPEND="sys-apps/coreutils sys-apps/findutils sys-apps/grep sys-apps/sed"

# Arch ships these trees to /etc via pacman and the omarchy-settings package's
# post_install scriptlet. This overlay keeps the authoritative copy under
# /usr/share/omarchy (the same "source of truth" path upstream uses for
# re-sync) and only seeds /etc/skel when USE=skel-seed is enabled, so the
# live /etc and existing users' homes are never clobbered behind the user's
# back. Arch-owned /etc drop-ins (mkinitcpio, limine, plymouth, nsswitch,
# cups, faillock) are intentionally NOT applied; see the KB in the overlay
# README and adapt to Gentoo's /etc layout manually.

src_unpack() {
	git-r3_src_unpack
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	# Source of truth copy (bin/, config/, etc/, default/, themes/,
	# applications/, install/, migrations/, shell/).
	local om=/usr/share/omarchy
	dodir "${om}"
	insinto "${om}"
	for d in bin config etc default themes applications install migrations shell; do
		[[ -d "${S}/${d}" ]] && cp -a "${S}/${d}" "${ED}/${om}/"
	done
	# Version + branding assets.
	insinto "${om}"
	doins version logo.txt logo.svg icon.txt icon.png 2>/dev/null
}

pkg_postinst() {
	if use skel-seed; then
		einfo "Seeding /etc/skel from ${EROOT}/usr/share/omarchy/config..."
		install -d -m0755 "${EROOT}/etc/skel/.config"
		cp -a "${EROOT}/usr/share/omarchy/config"/. "${EROOT}/etc/skel/.config/" 2>/dev/null
		# Branding seeds used by omarchy screensaver/about.
		install -Dm0644 "${EROOT}/usr/share/omarchy/logo.txt" \
			"${EROOT}/etc/skel/.config/omarchy/branding/screensaver.txt" 2>/dev/null
		install -Dm0644 "${EROOT}/usr/share/omarchy/icon.txt" \
			"${EROOT}/etc/skel/.config/omarchy/branding/about.txt" 2>/dev/null
	fi
	elog "Omarchy settings installed to /usr/share/omarchy (source of truth)."
	elog "To apply to an existing user (destructive, mirrors omarchy-reinstall-configs):"
	elog "  rsync -a --exclude=.bashrc ${EROOT}/usr/share/omarchy/config/ ~/.config/"
	elog "Arch-specific /etc drop-ins (mkinitcpio/limine/plymouth/etc.) not applied."
}