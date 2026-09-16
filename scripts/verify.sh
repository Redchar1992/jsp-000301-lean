#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
mkdir -p evidence

{
  printf '%s\n' '=== UTC verification time ==='
  date -u '+%Y-%m-%dT%H:%M:%SZ'
  printf '\n%s\n' '=== Lean version ==='
  LEAN_VERSION="$(./scripts/lake.sh env lean --version)"
  printf '%s\n' "$LEAN_VERSION"
  [[ "$LEAN_VERSION" == "Lean (version 4.34.0,"* ]] || {
    printf '%s\n' 'FAIL: unexpected Lean version' >&2
    exit 1
  }
  printf '\n%s\n' '=== Pinned mathlib revision ==='
  MATHLIB_REV="$(git -C .lake/packages/mathlib rev-parse HEAD)"
  printf '%s\n' "$MATHLIB_REV"
  [[ "$MATHLIB_REV" == "5ed2965256430c3649e86755f9576b54eca72435" ]] || {
    printf '%s\n' 'FAIL: unexpected mathlib revision' >&2
    exit 1
  }
  printf '\n%s\n' '=== Build ==='
  ./scripts/lake.sh build
  printf '\n%s\n' '=== Kernel replay of local proof declarations ==='
  ./scripts/lake.sh env leanchecker --verbose JSP301.Proof
  printf '\n%s\n' '=== Statement and axiom audit ==='
  ./scripts/lake.sh env lean -DwarningAsError=true JSP301/Audit.lean |
    tee evidence/axioms.txt
  printf '\n%s\n' '=== Enforce allowed axioms and source hygiene ==='
  python3 scripts/check_audit.py
  printf '\n%s\n' '=== Source SHA-256 ==='
  shasum -a 256 lean-toolchain lakefile.toml lake-manifest.json \
    JSP301.lean JSP301/Proof.lean JSP301/Audit.lean \
    scripts/lake.sh scripts/verify.sh scripts/check_audit.py
  printf '\n%s\n' 'PASS: build, kernel replay, exact-statement audit, and axiom checks.'
} 2>&1 | tee evidence/verification.txt
