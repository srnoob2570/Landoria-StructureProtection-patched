#!/usr/bin/env bash
set -euo pipefail

# Build the distributable mod archive.
# Usage: scripts/package.sh [output-directory]
#
# Only the files listed in `files` below are shipped. Repo-only material
# (.git, .commit, scripts, FIX_PERFORMANCE.md, backups) is never included.

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
manifest="$repo_root/manifest.json"
output_dir="${1:-$repo_root/dist}"

package_name="$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1]))["name"])' "$manifest")"
package_version="$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1]))["version_number"])' "$manifest")"

files=(
  manifest.json
  README.md
  CHANGELOG.md
  icon.png
  Landoria.StructureProtection.dll
)

for file in "${files[@]}"; do
  if [[ ! -f "$repo_root/$file" ]]; then
    printf 'missing required file: %s\n' "$file" >&2
    exit 1
  fi
done

mkdir -p "$output_dir"
output_dir="$(cd -- "$output_dir" && pwd)"
archive="$output_dir/${package_name}-${package_version}.zip"

rm -f "$archive"
(cd "$repo_root" && zip -q -j -X "$archive" "${files[@]}")

printf 'created %s\n' "$archive"
unzip -l "$archive"
