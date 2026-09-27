#!/usr/bin/env bash
# Publish a GitHub Release when the manifest reports a version we have not released yet,
# then point the README download links at it.
# usage: release.sh <key> <manifest-url> <file-prefix> <display-name> <latest:true|false>
# DRY_RUN=1 skips every GitHub call (local testing).
set -euo pipefail

key=$1 url=$2 prefix=$3 display=$4 latest=$5
[ -n "$url" ] || { echo "::error::manifest URL for $key is not set (repo secret missing)"; exit 1; }

json=$(curl -fsS "$url")
ver=$(jq -er .versionName <<<"$json")
apk_url=$(jq -er .apkUrl <<<"$json")
sha=$(jq -er .sha256 <<<"$json")
echo "::add-mask::$apk_url"

tag="$key-v$ver"
file="$prefix-$ver.apk"

if [ -z "${DRY_RUN:-}" ] && gh release view "$tag" >/dev/null 2>&1; then
  echo "$display $ver already released"
  exit 0
fi

curl -fsS -o "$file" "$apk_url"
[ "$(sha256sum "$file" | cut -d" " -f1)" = "$sha" ] || { echo "::error::$display $ver: SHA-256 mismatch"; exit 1; }

{
  echo "### English"
  jq -r '.notes.en // empty' <<<"$json"
  echo
  echo "### Tiếng Việt"
  jq -r '.notes.vi // empty' <<<"$json"
  echo
  echo "SHA-256: \`$sha\`"
} > notes.md

if [ -z "${DRY_RUN:-}" ]; then
  gh release create "$tag" "$file" --title "$display $ver" --notes-file notes.md --latest="$latest"
fi

link="https://github.com/${GITHUB_REPOSITORY:-OWNER/REPO}/releases/download/$tag/$file"
VER="$ver" LINK="$link" FILE="$file" KEY="$key" BADGE="${display// /_}" perl -0pi -e '
  s{(<!-- $ENV{KEY}-version -->).*?(<!-- /$ENV{KEY}-version -->)}{$1$ENV{VER}$2}g;
  s{(<!-- $ENV{KEY}-link -->).*?(<!-- /$ENV{KEY}-link -->)}{$1\[$ENV{FILE}\]($ENV{LINK})$2}g;
  s{(badge/$ENV{BADGE}-)[0-9][0-9A-Za-z.]*(-)}{$1$ENV{VER}$2}g;
' README.md README.vi.md

rm -f "$file" notes.md
echo "$display $ver published"
