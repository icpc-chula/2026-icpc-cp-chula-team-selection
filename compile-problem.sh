#!/bin/bash
# Usage: ./compile-problem.sh <path/to/problem.tex> [output-dir]
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEX_FILE="${1:?Usage: $0 <path/to/problem.tex> [output-dir]}"
OUT_DIR="${2:-$SCRIPT_DIR}"

# Resolve to absolute path
if [[ "$TEX_FILE" != /* ]]; then
  TEX_FILE="$SCRIPT_DIR/$TEX_FILE"
fi

if [[ ! -f "$TEX_FILE" ]]; then
  echo "Error: $TEX_FILE not found" >&2
  exit 1
fi

PROBLEM_NAME="$(basename "$TEX_FILE" .tex)"
WRAPPER="\documentclass[11pt,a4paper]{article}\usepackage{./templates/cpicpc}\begin{document}\input{$TEX_FILE}\end{document}"

echo "Compiling $TEX_FILE -> $OUT_DIR/$PROBLEM_NAME.pdf..."

cd "$SCRIPT_DIR"

# Two passes; feed wrapper via stdin so no .tex file is created
echo "$WRAPPER" | xelatex \
  -jobname="$PROBLEM_NAME" \
  -output-directory="$OUT_DIR" \
  -interaction=nonstopmode

echo "$WRAPPER" | xelatex \
  -jobname="$PROBLEM_NAME" \
  -output-directory="$OUT_DIR" \
  -interaction=nonstopmode

echo ""
echo "Done: $OUT_DIR/$PROBLEM_NAME.pdf"
