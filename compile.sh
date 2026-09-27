#!/bin/bash
# Usage: ./compile.sh [path/to/file.tex]
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEX_FILE="${1:-statements/entry.tex}"

# Resolve to absolute path
if [[ "$TEX_FILE" != /* ]]; then
  TEX_FILE="$SCRIPT_DIR/$TEX_FILE"
fi

if [[ ! -f "$TEX_FILE" ]]; then
  echo "Error: $TEX_FILE not found" >&2
  exit 1
fi

TEX_DIR="$(dirname "$TEX_FILE")"
TEX_NAME="$(basename "$TEX_FILE" .tex)"

echo "Compiling $TEX_FILE..."

# Run from project root so ./templates/ and ./assets/ paths in the sty resolve correctly
cd "$SCRIPT_DIR"

xelatex \
  -output-directory="$TEX_DIR" \
  -interaction=nonstopmode \
  "$TEX_FILE"

# Second pass to resolve cross-references
xelatex \
  -output-directory="$TEX_DIR" \
  -interaction=nonstopmode \
  "$TEX_FILE"

echo ""
echo "Done: $TEX_DIR/$TEX_NAME.pdf"
