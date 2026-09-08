# The Kalām Engine

*This lives at `/kalam-engine/` inside the [sacredcivilization/sacredcivilization.github.io](https://github.com/sacredcivilization/sacredcivilization.github.io) repository — the code project behind [alvidscriptorium.com/kalam.html](https://alvidscriptorium.com/kalam.html). CI for this subfolder is defined at the repo root, `.github/workflows/kalam-engine-build.yml`, and only runs when files under `kalam-engine/` change.*

A machine-checked formalization of the *Wājib al-Wujūd* (Necessary Existent) argument — the modal-ontology core of Naṣīr al-Dīn al-Ṭūsī's *Tajrīd al-I'tiqād*, inherited from Avicenna's *Shifāʾ*. Part of the [Alvid Scriptorium](https://alvidscriptorium.com) project's computational-theology tier.

Scope and rationale: `docs/scope-v1.md` in this repo (mirrors `claude/kalam-computational-theology-scope-v1.md` in the project).

## What this is

`KalamEngine.lean` states four axioms — a trichotomy of modal status (Necessary / Contingent / Impossible), "nothing impossible exists," "every existing contingent thing has an existing cause" (the substantive premise), and "the causal-dependency relation is well-founded" (no infinite regress) — and proves, with no `sorry` and no hidden dependencies beyond Lean's own core library:

> If at least one Contingent entity exists, then a Necessary entity exists.

That's it. It is a small, complete, honestly-scoped formalization of one argument, not a formalization of the whole *Tajrīd*, and not a claim that the argument's premises are true — only that its conclusion validly follows from them.

## What this is not

- **Not a proof that God, or a Necessary Being, actually exists.** A valid deduction from premises to a conclusion says nothing about whether the premises hold. The premise doing the real philosophical work — A4, well-founded causation — is exactly the one under live scholarly dispute (see "The honest complication" below).
- **Not the first formalization of a theological argument.** Christoph Benzmüller and Bruno Woltzenlogel Paleo formalized Gödel's ontological proof in Isabelle/HOL in 2013 ([arXiv:1308.4526](https://arxiv.org/abs/1308.4526)). This project found no prior formalization specifically of Avicennian/Ṭūsian modal metaphysics — "no comparable prior work found," not "first ever."
- **Not using Mathlib.** The proof only needs the well-founded-recursion machinery (`Acc`, `WellFounded`) that ships with the Lean 4 compiler itself, so this repo has zero external Lean dependencies. That's a deliberate scope choice to keep the argument small and the build fast, not an oversight.

## The honest complication: *Burhān al-Taṭbīq* and Cantor

A4 (well-founded causation) is inherited from Avicenna's *Burhān al-Taṭbīq* ("the argument from correspondence"): if an infinite causal chain existed, it could be bijected onto a proper sub-chain of itself, which the classical argument treats as an impossible "part equals whole." Cantor showed this kind of bijection is perfectly consistent for infinite sets (ℕ bijects with the even numbers, without contradiction) — exactly the move *Burhān al-Taṭbīq* rules out. This is a live, published scholarly discussion, not something invented for this repo; see the links in `docs/scope-v1.md` §4. The standard defense is that the argument targets concrete, causally-ordered *existential* dependency chains, not abstract set cardinality — whether that distinction holds is a real, contested philosophical question, not something this repo resolves. The proof in this repo is valid regardless of how that dispute is settled; whether it is *sound* depends on it.

## Verifying it yourself

This repository was written without access to a Lean toolchain in the environment that authored it (see the commit history / accompanying note) — the proof was hand-derived and checked on paper, not locally compiled by its author. **The authoritative verification is the CI badge above / the Actions tab**, which runs `lake build` on every push using GitHub's own runners, with `#print axioms necessary_root_exists` embedded directly in `KalamEngine.lean` so its full axiom list appears in the build log. Don't take "no `sorry` in the source" as verification on its own — check that the build is actually green.

To build locally:

```sh
elan self update   # or install elan: https://github.com/leanprover/elan
lake build
```

## License

Code: MIT. Text (this README and `docs/`): CC BY 4.0.
