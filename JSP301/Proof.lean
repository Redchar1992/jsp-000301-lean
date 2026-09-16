import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Algebra.Group.Even
import Lean.Elab.Tactic.Omega

/-!
# JSP-000301: consecutive nonsquare powerful numbers

This formalizes the known counterexample 12167, 12168, already recorded in the
prize catalog. It makes no claim of a new mathematical discovery or award
eligibility. It does not address the counting question in Erdős problem 365.

`Powerful n` means that n is positive and the square of every prime divisor
of n divides n. Both the prime divisor and square-root quantifiers in the
final statement range over all natural numbers, not a finite search range.
-/

namespace JSP301

/-- A positive integer divisible by the square of each of its prime divisors. -/
def Powerful (n : ℕ) : Prop :=
  0 < n ∧ ∀ p : ℕ, Nat.Prime p → p ∣ n → p ^ 2 ∣ n

/-- The universal yes/no assertion stated in the scoped JSP-000301 record. -/
def Claim : Prop :=
  ∀ n : ℕ, Powerful n → Powerful (n + 1) → IsSquare n ∨ IsSquare (n + 1)

/-- Products of positive powerful numbers are powerful. -/
theorem powerful_mul {a b : ℕ} (ha : Powerful a) (hb : Powerful b) :
    Powerful (a * b) := by
  refine ⟨Nat.mul_pos ha.1 hb.1, ?_⟩
  intro p hp hdiv
  rcases hp.dvd_mul.mp hdiv with hpa | hpb
  · exact dvd_mul_of_dvd_left (ha.2 p hp hpa) b
  · exact dvd_mul_of_dvd_right (hb.2 p hp hpb) a

/-- Every positive square is powerful. -/
theorem powerful_square {a : ℕ} (ha : 0 < a) : Powerful (a ^ 2) := by
  refine ⟨Nat.pow_pos_iff.mpr (Or.inl ha), ?_⟩
  intro p hp hdiv
  exact pow_dvd_pow_of_dvd (hp.dvd_of_dvd_pow hdiv) 2

/-- Every positive cube is powerful. -/
theorem powerful_cube {a : ℕ} (ha : 0 < a) : Powerful (a ^ 3) := by
  refine ⟨Nat.pow_pos_iff.mpr (Or.inl ha), ?_⟩
  intro p hp hdiv
  have hsq : p ^ 2 ∣ a ^ 2 := pow_dvd_pow_of_dvd (hp.dvd_of_dvd_pow hdiv) 2
  simpa only [pow_succ] using dvd_mul_of_dvd_left hsq a

/-- A natural number strictly between successive squares is not a square. -/
theorem not_isSquare_between {n k : ℕ}
    (hlo : k * k < n) (hhi : n < (k + 1) * (k + 1)) : ¬ IsSquare n := by
  rintro ⟨r, hr⟩
  have hkr : k < r := by
    apply Nat.lt_of_not_ge
    intro hle
    have hsq := Nat.mul_self_le_mul_self hle
    omega
  have hrk : r < k + 1 := by
    apply Nat.lt_of_not_ge
    intro hle
    have hsq := Nat.mul_self_le_mul_self hle
    omega
  omega

/-- 12167 is the cube of 23. -/
theorem powerful_12167 : Powerful 12167 := by
  exact powerful_cube (a := 23) (by decide)

/-- 12168 = 2³ × 39², a product of two powerful numbers. -/
theorem powerful_12168 : Powerful 12168 := by
  exact powerful_mul (powerful_cube (a := 2) (by decide))
    (powerful_square (a := 39) (by decide))

theorem not_isSquare_12167 : ¬ IsSquare (12167 : ℕ) :=
  not_isSquare_between (k := 110) (by decide) (by decide)

theorem not_isSquare_12168 : ¬ IsSquare (12168 : ℕ) :=
  not_isSquare_between (k := 110) (by decide) (by decide)

/-- The complete counterexample, including both nonsquare conditions. -/
theorem counterexample :
    ∃ n : ℕ, Powerful n ∧ Powerful (n + 1) ∧
      ¬ IsSquare n ∧ ¬ IsSquare (n + 1) := by
  exact ⟨12167, powerful_12167, powerful_12168,
    not_isSquare_12167, not_isSquare_12168⟩

/-- The answer to the exact scoped JSP-000301 question is no. -/
theorem jsp_000301 : ¬ Claim := by
  intro h
  rcases h 12167 powerful_12167 powerful_12168 with hsq | hsq
  · exact not_isSquare_12167 hsq
  · exact not_isSquare_12168 hsq

/-- Expanded statement for checking the precise mathematical scope. -/
theorem jsp_000301_expanded :
    ¬ (∀ n : ℕ,
      (0 < n ∧ ∀ p : ℕ, Nat.Prime p → p ∣ n → p ^ 2 ∣ n) →
      (0 < n + 1 ∧ ∀ p : ℕ, Nat.Prime p → p ∣ n + 1 → p ^ 2 ∣ n + 1) →
      (∃ r : ℕ, n = r * r) ∨ (∃ r : ℕ, n + 1 = r * r)) :=
  jsp_000301

end JSP301
