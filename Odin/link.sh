#!/usr/bin/env bash
# Create the symlinks listed in links.txt. Safe to re-run.
# Usage: ./link.sh [--dry-run]
set -euo pipefail
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dry=0; [ "${1:-}" = "--dry-run" ] && dry=1

while read -r src dst; do
  [[ -z "${src:-}" || "$src" == \#* ]] && continue
  dst="${dst/#\~/$HOME}"
  src="$(realpath -m "$dir/$src")"
  [ -e "$src" ] || { echo "MISSING source: $src" >&2; continue; }
  if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
    echo "ok       $dst"; continue
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "SKIPPED  $dst exists and is not the expected link (move it aside, then re-run)" >&2
    continue
  fi
  echo "link     $dst -> $src"
  [ "$dry" = 1 ] || { mkdir -p "$(dirname "$dst")"; ln -s "$src" "$dst"; }
done < "$dir/links.txt"
