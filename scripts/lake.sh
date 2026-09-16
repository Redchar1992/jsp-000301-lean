#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Prefer the isolated local toolchain without changing shell profiles or defaults.
LOCAL_BIN="$ROOT/.tooling/lean-4.34.0-darwin_aarch64/bin"
if [[ -x "$LOCAL_BIN/lake" ]]; then
  export PATH="$LOCAL_BIN:$PATH"
fi
if ! command -v lake >/dev/null 2>&1; then
  printf '%s\n' 'Lean/Lake is not installed. Install elan, then run this script again.' >&2
  exit 1
fi
exec lake "$@"
