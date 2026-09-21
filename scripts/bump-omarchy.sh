#!/usr/bin/env bash
# Overlay port of omacom/omarchy-pkgs bin/omarchy-pkgs — the pin engine for
# the omarchy + omarchy-settings lockstep pair. Upstream rewrites both
# PKGBUILDs in one shot (identical _tag/_commit/pkgver/sha256sums); this does
# the same for the ebuild pair, plus the checks that keep the portage
# adaptation surface honest across upstream bumps.
#
# Usage:
#   scripts/bump-omarchy.sh 4.0.5 [commit]
#
# Steps:
#   1. resolve the tag to a commit (peeled), or take the commit verbatim
#   2. fetch the new source tarball and check the bin/ pacman-dependency
#      surface against the known adaptation set (drift = manual review)
#   3. rewrite OMARCHY_TAG/OMARCHY_COMMIT/PV in both ebuilds, git mv them
#   4. drop the previous pinned ebuilds, regenerate Manifests
#   5. refresh the omarchy-nvim recipe pin (it rides the omarchy-pkgs repo)
#   6. print the commit message and the tag to cut
#
# Versioning convention mirrors upstream: pkgver = X.Y.Z (prereleases use
# Gentoo's _rc form, which orders 4.0.0_rc1 < 4.0.0 — the same semantics as
# pacman's ATTACHED 4.0.0rc1; see the upstream PKGBUILD header).

set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OMARCHY_URL=https://github.com/omacom/omarchy
PKGS_URL=https://github.com/omacom/omarchy-pkgs

[[ $# == 1 || $# == 2 ]] || { echo "usage: $0 <version> [commit]" >&2; exit 2; }
version=$1
tag="v${version}"

if [[ $# == 2 ]]; then
	commit=$2
else
	# Annotated tags need the peeled ^{} entry; fall back to the tag object.
	commit=$(git ls-remote "$OMARCHY_URL" "refs/tags/${tag}" "refs/tags/${tag}^{}" \
		| awk -v t="refs/tags/${tag}^{}" '$2 == t { print $1; found=1 } END { if (!found) exit 1 }' 2>/dev/null \
		|| git ls-remote "$OMARCHY_URL" "refs/tags/${tag}" | cut -f1)
	[[ -n $commit ]] || { echo "error: tag ${tag} not found upstream" >&2; exit 1; }
fi
echo "pin: ${tag} @ ${commit}"

old_commit=$(sed -n 's/^OMARCHY_COMMIT="\([0-9a-f]*\)"/\1/p' "$repo"/app-misc/omarchy/omarchy-*.ebuild | head -1)
old_version=$(sed -n 's/^OMARCHY_TAG="v\([0-9.]*\)"/\1/p' "$repo"/app-misc/omarchy/omarchy-*.ebuild | head -1)

# --- adaptation-surface check ------------------------------------------------
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
curl -sfL "$OMARCHY_URL/archive/${commit}.tar.gz" -o "$work/src.tar.gz"
mkdir "$work/src"
tar -xzf "$work/src.tar.gz" -C "$work/src"

known=$(
	cat <<-EOF
		omarchy-debug
		omarchy-debug-idle
		omarchy-upload-log
		omarchy-pkg-present
		omarchy-pkg-missing
		omarchy-pkg-add
		omarchy-pkg-drop
		omarchy-pkg-install
		omarchy-pkg-remove
		omarchy-pkg-aur-accessible
		omarchy-pkg-aur-add
		omarchy-pkg-aur-install
		omarchy-update-system-pkgs
		omarchy-update-system-pkgs-when-conflicted
		omarchy-update-keyring
		omarchy-update-aur-pkgs
		omarchy-update-orphan-pkgs
		omarchy-update-pkg-prune
		omarchy-update-available
		omarchy-version-pkgs
		omarchy-version
		omarchy-channel-current
		omarchy-channel-set
		omarchy-refresh-pacman
		omarchy-reinstall-pkgs
		omarchy-update-pacman-guard
		omarchy-upgrade-to-quattro
		omarchy-dev-pkg-test
		omarchy-migrate
		omarchy-update-restart
		omarchy-debug
		omarchy-upload-log
		omarchy-remove-dev-env
		omarchy-remove-launcher-entry
		omarchy-provision-owner
		omarchy-setup-security-fingerprint
		omarchy-install-editor-emacs
	EOF
)

drift=0
while read -r script; do
	base=${script##*/}
	if ! grep -qxF "$base" <<<"$known"; then
		echo "DRIFT: $base newly references pacman/yay and has no portage adaptation"
		drift=1
	fi
done < <(grep -lE 'pacman|yay|checkupdates' "$work"/src/*/bin/* 2>/dev/null || true)
if (( drift )); then
	echo "Review the drifted scripts, extend files/gentoo-bin/ or files/*.patch, then re-run." >&2
	exit 1
fi
echo "adaptation surface: clean"

# --- rewrite the pair --------------------------------------------------------
for pkg in app-misc/omarchy app-misc/omarchy-settings; do
	# Glob tolerates a packaging revision suffix (-rN); the new ebuild drops
	# it, matching the convention that pkgrel resets whenever pkgver changes.
	old_ebuild=$(ls "$repo/$pkg/${pkg##*/}-${old_version}"*.ebuild 2>/dev/null | head -1)
	new_ebuild="${old_ebuild%/*}/${pkg##*/}-${version}.ebuild"
	sed -i \
		-e "s/^OMARCHY_TAG=\"v${old_version}\"/OMARCHY_TAG=\"${tag}\"/" \
		-e "s/^OMARCHY_COMMIT=\"${old_commit}\"/OMARCHY_COMMIT=\"${commit}\"/" \
		"$old_ebuild"
	git -C "$repo" mv "$old_ebuild" "$new_ebuild"
	# DESCRIPTION line keeps PV references fresh via ${PV}; nothing else pins.
	echo "rewritten: $new_ebuild"
done

# --- refresh the omarchy-nvim recipe pin --------------------------------------
pkgs_commit=$(git ls-remote "$PKGS_URL" master | cut -f1)
nvim_ebuild=$(ls "$repo"/app-editors/omarchy-nvim/*.ebuild)
old_pkgs_commit=$(sed -n 's/^PKGS_COMMIT="\([0-9a-f]*\)"/\1/p' "$nvim_ebuild")
sed -i "s/^PKGS_COMMIT=\"${old_pkgs_commit}\"/PKGS_COMMIT=\"${pkgs_commit}\"/" "$nvim_ebuild"
echo "omarchy-nvim recipe: ${old_pkgs_commit} -> ${pkgs_commit}"

# --- manifests ----------------------------------------------------------------
( cd "$repo" && for e in app-misc/omarchy/omarchy-"${version}".ebuild \
	app-misc/omarchy-settings/omarchy-settings-"${version}".ebuild \
	"$nvim_ebuild"; do
	DISTDIR="$work" ebuild "$e" manifest
	# keep the fetched tarball around for local testing
	cp -n "$work/${e##*/}"*.tar.gz /tmp/ 2>/dev/null || true
done )

# --- watch registry ------------------------------------------------------------
sed -i \
	-e "s#^\(app-misc/omarchy\t[^\t]*\t[^\t]*\t\).*#\1${version}#" \
	-e "s#^\(app-misc/omarchy-settings\t[^\t]*\t[^\t]*\t\).*#\1${version}#" \
	"$repo/metadata/upstream-watch.conf"

cat <<EOF

Done. Next steps:
  git add -A && git commit -m "omarchy ${version}: pin to upstream ${tag} (${commit})"
  git tag omarchy-${version}
  scripts/check-upstream.sh   # should be all green
EOF
