#!/usr/bin/env bash
set -euo pipefail

# Syncs chezmoi documentation from upstream into src/.
# Shallow-clones the repo, copies all Markdown files preserving structure.

REPO_URL="https://github.com/twpayne/chezmoi.git"
DOCS_SUBDIR="assets/chezmoi.io/docs"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMPDIR_PREFIX="chezmoi-docs-sync"

TARGET_DIR="$SCRIPT_DIR/src"

cleanup() {
  if [[ -n "${tmp_dir:-}" && -d "$tmp_dir" ]]; then
    rm -rf "$tmp_dir"
  fi
}
trap cleanup EXIT

tmp_dir="$(mktemp -d -t "${TMPDIR_PREFIX}.XXXXXX")"

echo "Cloning chezmoi (shallow)..."
git clone --depth 1 --filter=blob:none --sparse "$REPO_URL" "$tmp_dir/chezmoi"

cd "$tmp_dir/chezmoi"
git sparse-checkout set "$DOCS_SUBDIR"

echo "Removing old docs from target..."
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

echo "Copying Markdown files..."
src="$tmp_dir/chezmoi/$DOCS_SUBDIR"
find "$src" -name "*.md" -type f | while read -r file; do
  rel="${file#"$src"/}"
  dest="$TARGET_DIR/$rel"
  mkdir -p "$(dirname "$dest")"
  cp "$file" "$dest"
done

count="$(find "$TARGET_DIR" -name "*.md" -type f | wc -l | tr -d ' ')"
echo "Done. $count Markdown files synced into src/."
