# Copyright 2026, omarchy-gentoo overlay team
# Distributed under the terms of the MIT license

EAPI=8

inherit shell-completion

DESCRIPTION="Omarchy shell configuration for Zsh (Gentoo port)"
HOMEPAGE="https://github.com/omacom-io/omarchy-zsh"
# omadots (shared shell config) is tracked on an unpinned master branch
# upstream (SKIP checksum); this overlay pins it.
OMADOTS_COMMIT="556354683664f4143776296d76df75c0fa29059a"
SRC_URI="
	https://github.com/omacom-io/omarchy-zsh/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/omacom-io/omadots/archive/${OMADOTS_COMMIT}.tar.gz -> omadots-${OMADOTS_COMMIT}.tar.gz
"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-shells/fzf
	app-shells/starship
	app-shells/zoxide
	app-shells/zsh
	app-shells/zsh-syntax-highlighting
	sys-apps/bat
	sys-apps/eza
	sys-apps/fd
"
# dev-util/mise is not packaged in ::gentoo/guru; the shared shell config
# degrades gracefully without it (elog notes how to install).

src_configure() { :; }
src_compile() { :; }

src_install() {
	# Shared shell config from omadots (aliases, functions, envs, inits,
	# inputrc), rewritten to load from the installed package location instead
	# of user config — mirrors the upstream PKGBUILD.
	local shell_dir="${T}/shell"
	mkdir -p "${shell_dir}" || die
	cp -a "${WORKDIR}/omadots-${OMADOTS_COMMIT}/config/shell/." "${shell_dir}/" || die
	grep -rl 'config/shell' "${shell_dir}" | while read -r f; do
		sed -i \
			-e 's|"\$HOME"/\.config/shell|/usr/share/omarchy-zsh/shell|g' \
			-e 's|\$HOME/\.config/shell|/usr/share/omarchy-zsh/shell|g' \
			"${f}" || die
	done
	insinto /usr/share/omarchy-zsh/shell
	doins -r "${shell_dir}/."

	# Zsh-specific zoptions from omarchy-zsh.
	doins shell/zoptions

	# Completions on the standard site-functions path so they autoload via the
	# default fpath; compinit is invoked from zoptions.
	dozshcomp shell/completions/*

	# Templates and documentation.
	insinto /usr/share/omarchy-zsh
	doins -r templates
	dodoc README.md LICENSE

	dobin bin/omarchy-setup-zsh
}

pkg_postinst() {
	elog "To set zsh as default shell, run: omarchy-setup-zsh"
	if ! has_version dev-util/mise; then
		elog "dev-util/mise is not in ::gentoo or ::guru; install it from upstream"
		elog "(https://mise.jdx.dev) if you use the mise-driven dev workflows."
	fi
}
