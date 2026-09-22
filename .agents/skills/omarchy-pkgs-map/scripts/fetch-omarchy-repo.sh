#!/usr/bin/env bash
# Fetch and parse an omarchy pacman repository database (pkgs.omarchy.org).
#
# Usage: fetch-omarchy-repo.sh [channel] [arch]
#   channel: stable (default) | rc | edge
#   arch:    x86_64 (default) | aarch64
#
# Output: TSV lines  name<TAB>version<TAB>description , sorted by name.
# Debug symbol sub-packages (name ends in -debug) are excluded.
set -euo pipefail

channel=${1:-stable}
arch=${2:-x86_64}
url="https://pkgs.omarchy.org/${channel}/${arch}/omarchy.db"
cache="${TMPDIR:-/tmp}/omarchy-db-${channel}-${arch}"

mkdir -p "$cache"
db="$cache/omarchy.db"
if [ ! -s "$db" ]; then
    curl -fsSL -o "$db" "$url"
fi

work="$cache/extract"
rm -rf "$work"
mkdir -p "$work"
tar --zstd -xf "$db" -C "$work"

for d in "$work"/*/; do
    f="$d/desc"
    [ -f "$f" ] || continue
    awk '
        /^%NAME%$/    { getline; name = $0 }
        /^%VERSION%$/ { getline; ver  = $0 }
        /^%DESC%$/    { getline; desc = $0 }
        END { if (name !~ /-debug$/) printf "%s\t%s\t%s\n", name, ver, desc }
    ' "$f"
done | sort
