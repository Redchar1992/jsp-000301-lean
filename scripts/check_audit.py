"""Reject missing declarations, proof placeholders, and nonstandard axioms."""

import re
from pathlib import Path

root = Path(__file__).resolve().parent.parent
text = (root / "evidence/axioms.txt").read_text()
expected = {
    "JSP301.powerful_12167",
    "JSP301.powerful_12168",
    "JSP301.not_isSquare_12167",
    "JSP301.not_isSquare_12168",
    "JSP301.counterexample",
    "JSP301.jsp_000301",
    "JSP301.jsp_000301_expanded",
}
allowed = {"propext", "Classical.choice", "Quot.sound"}
seen = set()

for name, raw in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", text):
    axioms = {x.strip() for x in raw.split(",") if x.strip()}
    unexpected = axioms - allowed
    if unexpected:
        raise SystemExit(f"FAIL: {name} depends on {sorted(unexpected)}")
    seen.add(name)
    print(f"PASS {name}: {sorted(axioms)}")

for name in re.findall(r"'([^']+)' does not depend on any axioms", text):
    seen.add(name)
    print(f"PASS {name}: no axioms")

if expected - seen:
    raise SystemExit(f"FAIL: missing axiom audit for {sorted(expected - seen)}")

# Supplement the kernel's transitive axiom report with a local-source check.
# This intentionally scans comments too: keep placeholder tokens out of sources.
blocked = re.compile(r"\b(?:sorry|admit|axiom|native_decide|implemented_by|unsafe)\b")
for source in [root / "JSP301.lean", *sorted((root / "JSP301").glob("*.lean"))]:
    if match := blocked.search(source.read_text()):
        raise SystemExit(f"FAIL: forbidden token {match[0]!r} in {source.name}")
print("PASS local Lean sources: no placeholders, custom axioms, or native shortcuts")
