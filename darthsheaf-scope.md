# DarthSheaf: BLAS Level 1 in Pure Haskell

## Core Thesis

Implement core BLAS Level 1 operations (vector-vector) in pure Haskell, focusing on correctness, numerical stability, and pedagogical clarity. Each operation becomes a study in how minimal algorithmic structure generates derived understanding about cache efficiency, numerical hazards, and the bridge between mathematical elegance and computational reality.

**Portfolio signal:** I can read numerical source code, understand the design decisions, and reimplement them correctly. Not "I built a library." Rather: "I know what BLAS does and why it matters."

---

## Operations (In Learning Order)

| Op | What It Does | Why It Matters | Learning Focus |
|---|---|---|---|
| **SCAL** | Scale a vector: `y := alpha * x` | Simplest op. No accumulation, no stability issues. | Loop structure, indexing, performance baseline |
| **AXPY** | Add scaled vector: `y := alpha*x + y` | Introduces accumulation without dot product complexity. | Memory access patterns, vectorization hints |
| **DOTC** / **DOT** | Dot product with conjugation (or not) | Accumulation + numerical stability (sum order matters). | Reduction patterns, floating-point error, Kahan summation |
| **NRML2** | 2-norm: `sqrt(sum(x_i^2))` | Risk of overflow/underflow. Safe scaling required. | Normalization, dynamic range handling |
| **ASUM** | Sum of absolute values | Simpler accumulation, no squaring. | Conditional logic (sign), loop unrolling |
| **IAMAX** | Index of maximum absolute value | First search operation. | Comparison, early termination |
| **SWAP** | Swap two vectors in-place | Memory locality, aliasing concerns. | Temporary buffers, reference semantics |
| **COPY** | Copy one vector to another | Baseline for memory bandwidth. | Cache behavior, memory layout |
| **ROT** | Givens rotation: `(x, y) := G(x, y)` | Introduces trigonometry + coupled updates. | Parametric transformations |
| **ROTMG** | Generate Givens rotation parameters | Numerical robustness in rotation generation. | Scaling, edge cases, backward stability |

---

## Why These 10?

- **SCAL → AXPY**: Build loop intuition incrementally.
- **DOT**: Introduces the accumulation hazard that dominates numerical computing.
- **NRML2 → ASUM**: Two flavors of reduction; shows different stability strategies.
- **IAMAX → COPY**: Bread-and-butter utilities; easy wins.
- **SWAP**: Memory alias problem; reveals Haskell's immutability advantage.
- **ROT / ROTMG**: Pushes beyond simple arithmetic; shows how structure (Givens) maps to code.

Each is a *lesson*, not just a subroutine.

---

## Timeline

| Phase | Weeks | Tasks |
|---|---|---|
| **Skeleton** | 1 | Create Haskell module structure; type signatures for all 10 ops |
| **Core ops** (SCAL–COPY) | 2–3 | Implement + test (QuickCheck) + micro-benchmarks vs. standard Haskell |
| **Reductions** (DOT–NRML2) | 1–2 | Implement + stability analysis (paper: when does error grow?) |
| **Utilities** (IAMAX–SWAP) | 1 | Implement + memory layout exploration |
| **Advanced** (ROT–ROTMG) | 1–2 | Implement + derive the math from first principles in comments |
| **Documentation** | 1 | README, blog post, examples |
| **Polish** | 1 | Benchmarks, edge case handling, final review |

**Total: 8–10 weeks.** Land by **September 1st** for October application.

---

## Deliverables

1. **`DarthSheaf.hs`** — The full implementation (400–600 LOC)
2. **`DarthSheaf/Bench.hs`** — QuickCheck properties + criterion benchmarks vs. `Data.Vector`
3. **`README.md`** — Explains why each op, design choices, how to read it
4. **Blog post** — Deep dive on ONE op (e.g., "Why DOT Product Stability Matters: A Haskell Story")
5. **Examples** — Cholesky decomposition (or QR, or whatever) using the ops

---

## Success Criteria

- All 10 ops implemented, type-safe, tested
- Blog post is publishable (500+ words, genuine insight)
- README is clear enough for a non-expert to understand why BLAS exists
- Benchmark shows the implementation is "reasonable" (not beating BLAS, but in the same ballpark for small vectors)

---

## Why This Matters for October

**Research alignment signal:**
- Shows you can **read and understand foundational numerical code**
- Demonstrates **pedagogical clarity** (can explain why things matter, not just implement)
- Proves **rigor** (testing, benchmarks, edge cases)
- Positions you as someone who thinks about **systems that generate derived understanding** (the DarthSheaf philosophy)

**For an alignment role:** Understanding BLAS is understanding constraints. You're not building a new paradigm; you're respecting the existing one and learning it deeply.

---

## Notes

- Start with a simple Haskell module. Don't over-architect.
- Use `Data.Vector` for the underlying array. Don't rewrite arrays.
- Each op gets a comment block explaining the numerical hazard (if any).
- Benchmarks are nice, not required. Correctness is table stakes.
- Blog post is the real deliverable. Code is evidence.

---

Done. Eat breakfast. Iterate on this if it needs work.
