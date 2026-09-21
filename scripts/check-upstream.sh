#!/usr/bin/env bash
# Overlay port of omacom/omarchy-pkgs bin/check-versions: compare the pins in
# this overlay against upstream git tags / branches, using git ls-remote only
# (no API tokens, no rate limits).
#
# Exit 1 when something is stale — CI turns that into an issue for a human,
# mirroring upstream's watcher-queue-then-human-merge model.

set -euo pipefail

conf="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/metadata/upstream-watch.conf"
stale=0

while IFS=$'\t' read -r pkg url mode current; do
	[[ -z ${pkg// /} || $pkg == \#* ]] && continue
	case $mode in
		tags:*)
			verregex=${mode#tags:}
			# Tags the regex cannot parse (betas, RCs) keep their raw sha line
			# and are dropped here: the stable channels never chase them.
			latest=$(git ls-remote --tags --refs "$url" 2>/dev/null \
				| sed -E "s#.*refs/tags/${verregex}#\1#" \
				| grep -E '^[0-9]+([.][0-9]+)*$' | sort -V | tail -1 || true)
			what=version
			;;
		head:*)
			ref=${mode#head:}
			latest=$(git ls-remote "$url" "$ref" 2>/dev/null | cut -f1 || true)
			what=commit
			;;
		none)
			echo "   $pkg: frozen pin $current (intentional)"
			continue
			;;
		*)
			echo "?? $pkg: unknown mode '$mode'" >&2
			stale=1
			continue
			;;
	esac

	if [[ -z $latest ]]; then
		echo "?? $pkg: upstream query returned nothing for $url ($mode)"
		stale=1
	elif [[ $latest == "$current" ]]; then
		echo "ok $pkg: $current"
	else
		echo "!! $pkg: pinned $current -> upstream $latest ($what)"
		stale=1
	fi
done <"$conf"

if (( stale )); then
	echo
	echo "Run the matching bump (scripts/bump-omarchy.sh for the omarchy pair, or a"
	echo "version-bump commit) and regenerate Manifests before pushing."
fi
exit "$stale"
