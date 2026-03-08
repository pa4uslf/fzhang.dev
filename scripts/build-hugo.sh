#!/usr/bin/env bash
set -euo pipefail

HUGO_VERSION="${HUGO_VERSION:-0.157.0}"
OS="linux"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH" >&2
    exit 1
    ;;
esac

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

ARCHIVE_URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_${OS}-${ARCH}.tar.gz"

echo "Downloading Hugo ${HUGO_VERSION} from ${ARCHIVE_URL}"
curl -fsSL "$ARCHIVE_URL" -o "$TMP_DIR/hugo.tar.gz"
tar -xzf "$TMP_DIR/hugo.tar.gz" -C "$TMP_DIR"

"$TMP_DIR/hugo" version
"$TMP_DIR/hugo" --gc --minify
