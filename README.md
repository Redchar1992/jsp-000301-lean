# JSP-000301 — consecutive nonsquare powerful numbers

A Lean formalization of the **already-known** counterexample
`12167, 12168`. This is not a claim of a new mathematical discovery,
first formalization, accepted submission, or entitlement to prize money.

**Submitted for official review:** [The Justin Sun Prize PR #17](https://github.com/TheJustinSunPrize/awards/pull/17).
The submission includes the Lean source and verification evidence; official
review and eligibility assessment are pending. An earlier same-result submission
exists as [PR #13](https://github.com/TheJustinSunPrize/awards/pull/13), so no
first-formalization priority is claimed.

The verified source snapshot is available as
[release v0.1.0](https://github.com/Redchar1992/jsp-000301-lean/releases/tag/v0.1.0),
pinned to commit `94c99f824c0deb2f0a163ba1b07ad95c7995100d`.

**Verified locally on 2026-09-16:** Lean build, kernel replay, expanded-statement
inspection, and the axiom audit all passed. See `VERIFICATION.md` and the raw
log in `evidence/verification.txt`.

## Exact scope

The prize record asks:

> If two consecutive positive integers are powerful, must at least one be a
> perfect square?

The answer is **no**. A positive integer is powerful when the square of every
prime divisor divides it. In this project, `Powerful` uses mathlib's `Nat.Prime`
and ordinary natural-number divisibility. Perfect squares use mathlib's
`IsSquare`, with a natural-number witness.

The final theorem is `JSP301.jsp_000301 : ¬ JSP301.Claim`.
`JSP301.jsp_000301_expanded` spells out the same statement without the local
definitions. Quantifiers over prime divisors and square roots are **unbounded**.

This proves precisely the yes/no question in the scoped catalog record.
It does **not** prove an asymptotic counting result, an infinitude result,
or the distinct question in Erdős problem 365.

## Proof

1. `12167 = 23³` is powerful: every prime divisor of a cube divides its base,
   so its square divides the cube.
2. `12168 = 2³ × 39²` is powerful: positive squares and cubes are powerful,
   and the product of powerful numbers is powerful.
3. `110² = 12100 < 12167 < 12168 < 12321 = 111²`.
   No natural-number square lies strictly between successive squares.
4. The consecutive pair therefore disproves the universal assertion.

This uses ordinary proof-producing arithmetic tactics. The main proof does
not rely on a finite search over all candidate primes or square roots.

## Pinned dependencies

- Lean: `leanprover/lean4:v4.34.0`.
- mathlib: `5ed2965256430c3649e86755f9576b54eca72435` (release `v4.34.0`).
- Transitive dependency revisions: `lake-manifest.json`.

Install elan and let `lean-toolchain` select the pinned Lean release.
The wrapper also supports an optional project-local installation under
`.tooling/`; that installation is not included in this repository. The
macOS release used for the attached verification evidence was checked against
the SHA-256 digest saved in `evidence/lean-release.json`.

## Reproduce

From the project directory:

```sh
./scripts/lake.sh exe cache get \
  Mathlib.Data.Nat.Prime.Basic \
  Mathlib.Algebra.Group.Even
./scripts/verify.sh
```

The source proof is in `JSP301/Proof.lean`; the statement and axiom audit is
in `JSP301/Audit.lean`. Verification includes a separate `leanchecker` replay
of the local proof declarations and rejects any transitive axioms other than
Lean's standard `propext`, `Classical.choice`, and `Quot.sound`.
It also rejects proof placeholders and native-evaluation shortcuts in the
local Lean source. `leanchecker` uses the same Lean kernel; it is not an
independently implemented verifier. Cached upstream mathlib artifacts are used in the
standard way. This is not an independent bootstrap of Lean or rebuild of
all of mathlib from source.

## Attribution and prize status

The pair and argument were already listed by **The Justin Sun Prize
contributors**. The exact source revision and an extracted record are retained
in `evidence/problem-statement.md`. Only formalization work is new in this
project. An earlier submission for the same result is linked above; no
first-formalization priority is claimed. Codex AI assisted preparation,
checking and submission of this implementation.

- [Pinned problem record](https://github.com/TheJustinSunPrize/awards/blob/f4e7173d89dfe91022a185427d63452c8ffbf6ae/problems/catalog-0301-0400.md#JSP-000301)
- [Upstream content license](https://github.com/TheJustinSunPrize/awards/blob/f4e7173d89dfe91022a185427d63452c8ffbf6ae/LICENSE-CONTENT)
- [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

The source snapshot is an attributed excerpt, with retrieval metadata added;
the original record's mathematical content is unchanged. Third-party works
cited by the record retain their original rights.

At the captured revision the record says `Lean proof: No`,
`Eligible to claim: No`, and lists no bounty amount. A local kernel check does
not change those official fields, establish priority, or authorize payment.
PR #17 submits this implementation for review, not as an accepted candidate or
award. Recipient confirmation, independent review, eligibility assessment and
payment verification remain pending. No official eligibility flag or award
record has been changed by this submission.
