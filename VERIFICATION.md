# Verification result — JSP-000301

Status: **PASS**, locally verified on 2026-09-16.

## Result

`JSP301.jsp_000301 : ¬ JSP301.Claim`

The exact universal assertion in the source record is false: `12167` and
`12168` are consecutive positive powerful numbers, neither a perfect square.
The underlying counterexample is already known and explicitly present in
the prize's problem record. This project supplies a Lean formalization.

## Checks performed

| Check | Result |
| --- | --- |
| Official Lean 4.34.0 archive SHA-256 | Matched the release asset digest |
| Lean and mathlib versions | Matched the pinned versions |
| All nine dependency Git revisions | Matched `lake-manifest.json`; tracked sources clean |
| `./scripts/lake.sh build` | Passed; local warnings treated as errors |
| `leanchecker --verbose JSP301.Proof` | Passed, replaying local declarations through the Lean kernel |
| Expanded final theorem type | Matches the positive-integer, arbitrary-prime, arbitrary-square-root statement |
| Transitive axiom audit | Passed for seven witness/final declarations |
| Local proof-source hygiene | No `sorry`, `admit`, custom `axiom`, `native_decide`, `implemented_by`, or `unsafe` |

The final theorem uses only the standard axioms `propext`, `Classical.choice`,
and `Quot.sound`. This is not a claim that the proof has no foundational axioms.

The raw command output, theorem types, dependency reports, and source hashes
are in `evidence/verification.txt`; the separate axiom output is in
`evidence/axioms.txt`. Reproduce all core checks with `./scripts/verify.sh`.

## Scope and limitations

- Prime numbers use mathlib's `Nat.Prime`; squares use mathlib's `IsSquare`.
- The definition of `Powerful` requires positivity and square divisibility
  for **every** prime divisor. It is not a bounded numerical approximation.
- The proof does not claim infinitely many such pairs or a counting estimate.
  In particular, it does not solve the separate Erdős problem 365.
- `leanchecker` uses the same Lean kernel, not an independent implementation.
  Standard upstream mathlib build caches were used, not independently rebuilt.
- An earlier same-result submission exists as
  [PR #13](https://github.com/TheJustinSunPrize/awards/pull/13).
  No first-formalization priority is claimed.
- Submitted for official review through
  [PR #17](https://github.com/TheJustinSunPrize/awards/pull/17) on 2026-09-16.
  This is not an accepted candidate or award. Recipient confirmation,
  independent review, eligibility assessment and payment verification remain
  pending. The captured prize record lists no amount and marks eligibility as `No`.
- [Release v0.1.0](https://github.com/Redchar1992/jsp-000301-lean/releases/tag/v0.1.0)
  preserves the verified source snapshot at
  `94c99f824c0deb2f0a163ba1b07ad95c7995100d`. Its GitHub archive is versioned,
  not an independently preserved permanent archive; the recorded verification
  predates submission and is not an independent review.

## Frozen references

- Prize record revision: `f4e7173d89dfe91022a185427d63452c8ffbf6ae`.
- Lean: `v4.34.0`, release commit `293d5d0c0c3f3dded4688b3ccd6a33939ac5102b`.
- mathlib: `5ed2965256430c3649e86755f9576b54eca72435`.
- Proof SHA-256: `135c5492ebad9f36484cbdebf44210a69559f77e41e067f44a388b60866c1ab2`.
