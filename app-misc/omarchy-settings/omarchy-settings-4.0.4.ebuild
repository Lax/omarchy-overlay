# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

DESCRIPTION="Omarchy user defaults, /etc/skel content, fonts, branding (Gentoo port, pinned release)"
HOMEPAGE="https://github.com/omacom/omarchy"
# Commit pinned in upstream omarchy-settings PKGBUILD for v4.0.4.
OMARCHY_COMMIT="c668141e9c42b13c80c9ca4ea108e11708c5e8a5"
SRC_URI="https://github.com/omacom/omarchy/archive/${OMARCHY_COMMIT}.tar.gz -> omarchy-${PV}.tar.gz"
S="${WORKDIR}/omarchy-${OMARCHY_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+skel-seed"

DEPEND=""
RDEPEND="sys-apps/coreutils sys-apps/findutils sys-apps/grep sys-apps/sed"

src_configure() { :; }
src_compile() { :; }

src_install() {
	local om=/usr/share/omarchy
	dodir "${om}"
	insinto "${om}"
	for d in bin config etc default themes applications install migrations shell; do
		[[ -d "${S}/${d}" ]] && cp -a "${S}/${d}" "${ED}/${om}/"
	done
	doins version logo.txt logo.svg icon.txt icon.png 2>/dev/null
}

pkg_postinst() {
	if use skel-seed; then
		einfo "Seeding /etc/skel from ${EROOT}/usr/share/omarchy/config..."
		install -d -m0755 "${EROOT}/etc/skel/.config"
		cp -a "${EROOT}/usr/share/omarchy/config"/. "${EROOT}/etc/skel/.config/" 2>/dev/null
		install -Dm0644 "${EROOT}/usr/share/omarchy/logo.txt" \
			"${EROOT}/etc/skel/.config/omarchy/branding/screensaver.txt" 2>/dev/null
		install -Dm0644 "${EROOT}/usr/share/omarchy/icon.txt" \
			"${EROOT}/etc/skel/.config/omarchy/branding/about.txt" 2>/dev/null
	fi
	elog "Omarchy settings ${PV} installed to /usr/share/omarchy (source of truth)."
	elog "Apply to an existing user (destructive, mirrors omarchy-reinstall-configs):"
	elog "  rsync -a --exclude=.bashrc ${EROOT}/usr/share/omarchy/config/ ~/.config/"
}