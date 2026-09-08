---
title: "The Kalām Engine: A Computational Theology Tier for Alvid Scriptorium"
status: "Planning document — v1 scope locked, pending build (Lean proof → GitHub repo → Hugging Face Space → site integration)"
---

# The Kalām Engine
## A Computational Theology Tier for Alvid Scriptorium — Scope & Architecture, v1

## 0. Where this starts

There is already a draft in the pipeline: `computational_theology_nasir_al_din_al_tusi_lean4_smt_paper.md`, written the same day this plan was requested. It's the right instinct pointed in an inflated direction — five "domains" (modal ontology, graph theory, deontic game theory, a four-layer NLP/knowledge-graph pipeline, and a HoTT framing), none of them actually finished. The one piece of real code in it — the Lean 4 theorem `necessary_root_exists` — ends in `sorry`, Lean's own keyword for "not actually proven." The closing paragraph calls the result "mathematically coherent, logically necessary, and computationally verifiable" while the only executable artifact in the document isn't verified at all. That gap between claim and content is the exact failure mode this whole corpus has been audited for elsewhere, and it would be a mistake to let it define the flagship page of a new site.

This document is the corrected version: one argument, actually finished, honestly framed, before anything gets built.

## 1. Why this is worth doing at all

"Computational theology" is a real, published field, not a marketing coinage. Christoph Benzmüller and Bruno Woltzenlogel Paleo formally verified Gödel's ontological proof of God's existence in Isabelle/HOL in 2013 — peer-reviewed, and archived in the Isabelle Archive of Formal Proofs:
- [arXiv:1308.4526 — Formalization, Mechanization and Automation of Gödel's Proof of God's Existence](https://arxiv.org/abs/1308.4526)
- [Gödel's God in Isabelle/HOL — Archive of Formal Proofs](https://isa-afp.org/browser_info/current/AFP/GoedelGod/document.pdf)

I searched specifically for prior work formalizing Avicennian or Ṭūsian modal metaphysics in a proof assistant and found nothing. That's not proof no one has ever done it, but it means the honest claim on the site is "no comparable prior work found," not "the first ever" — a smaller, defensible claim rather than an unverifiable superlative (the same discipline applied to the Waqf Act and Khojkī pieces already published). If v1 actually lands, it's a genuine small contribution, not a repackaging of something already done for Gödel.

## 2. v1 scope: one argument, fully real

**In scope for v1:** the *Wājib al-Wujūd* argument — the tripartite modal partition (Necessary / Contingent / Impossible) plus the regress-blocking argument (*Burhān al-Taṭbīq*) that gets you from "at least one contingent thing exists" to "a Necessary Being exists." This is the load-bearing argument of the *Tajrīd*'s ontology section and the one piece genuinely suited to a complete, checkable formalization at this scale.

**Explicitly deferred, not cut** — these stay in the source draft as a roadmap, but nothing about them ships in v1:
- The *Walāyah*/Luṭf "deontic game theory" section (Section IV of the draft). No agents, strategies, or payoffs are actually defined in the draft; dressing classical *Luṭf* doctrine in game-theory vocabulary without a real model is exactly the overclaiming pattern to avoid. It can return later as an honestly-scoped deontic logic project, separately verified.
- The four-layer NLP/knowledge-graph/AST pipeline (Section V). That's a real, larger engineering project (Arabic NLP, a curated ontology of *Tajrīd*'s technical vocabulary) — worth doing eventually, out of scope for a v1 that's supposed to ship something complete.
- The HoTT (Homotopy Type Theory) framing. Modal logic (S5) is the right, standard tool for necessity/contingency; HoTT doesn't add anything here and mixing formalisms without using either rigorously is part of what made the draft read as decoration.

## 3. The argument itself, worked honestly

**Premises** (stated as formal axioms — not proven, stated plainly as premises so the reader can see exactly what's assumed):

- **A1 (Trichotomy).** Every entity's modal status is exactly one of Necessary, Contingent, or Impossible.
- **A2 (No impossible existents).** If an entity's status is Impossible, it does not exist. *(Definitional — uncontroversial.)*
- **A3 (Principle of Sufficient Reason for contingents).** If a Contingent entity exists, it has a cause — some other existing entity that explains it. *(This is the substantive metaphysical premise. A philosopher who accepts brute, uncaused contingent facts rejects this one — the argument's validity doesn't depend on A3 being true, only its soundness does. This should be stated on the site exactly this bluntly.)*
- **A4 (Well-foundedness of causation).** The causal-dependency relation admits no infinite descending chain — you cannot regress backward through causes forever. *(This is where* Burhān al-Taṭbīq *comes in historically, and where the argument is genuinely contested — see §4.)*

**Theorem.** If at least one Contingent entity exists, then a Necessary entity exists.

**Proof.** Let S be the set of existing, Contingent causal ancestors of the given contingent entity x₀ (including x₀ itself). S is nonempty (x₀ ∈ S). By A4, the causal relation is well-founded, so S has a minimal element m — meaning nothing in S causes m (this is a direct application of what a well-founded relation *is*; Lean's `mathlib` supplies it off the shelf as `WellFounded.min`, no reinvention needed). Since m ∈ S, m exists and is Contingent, so by A3 it has a cause c, and c exists. If c were also Contingent, c would be a causal ancestor of x₀ too (ancestry is transitive) and thus c ∈ S — but c causes m, contradicting m's minimality in S. So c is not Contingent. Since c exists, A2 rules out c being Impossible. By A1, c is Necessary. □

That's a complete, valid proof — no `sorry`, no gap. The next implementation step (§6, milestone M2) is transcribing exactly this into Lean 4 against `mathlib`'s well-founded-relation API, which was built for precisely this shape of argument.

## 4. The honest complication: *Burhān al-Taṭbīq* and Cantor

Premise A4 needs its own justification, and *Tajrīd al-Iʿtiqād* inherits the standard one from Avicenna's falsafa toolkit (the *Burhān al-Taṭbīq*, "the argument from correspondence/mapping"): if an infinite causal chain existed, you could biject a proper sub-chain of it onto the whole chain, which the argument treats as an impossible "part equals whole." Tūsī restates and relies on this Avicennian argument rather than originating it — the site should attribute it to Avicenna's *al-Shifāʾ* with Ṭūsī's use of it noted separately, not credit it to Ṭūsī outright.

The complication: Cantor showed exactly this kind of bijection is completely consistent for infinite sets (ℕ bijects with the even numbers without contradiction), which is precisely the move *Burhān al-Taṭbīq* rules out. This is a live, published scholarly discussion, not something I'm introducing:
- [Avicenna's argument against infinite regress in *The Metaphysics of the Healing*](https://www.academia.edu/8350907/Avicenna_s_argument_against_infinite_regress_in_The_Metaphysics_of_the_Healing_as_a_step_in_proving_the_existence_of_God)
- [Avicenna on Mathematical Infinity — Cambridge repository](https://www.repository.cam.ac.uk/bitstreams/66000c81-dae8-4d2b-89e7-e2990e1f50f9/download) *(forthcoming in Archiv für Geschichte der Philosophie)*
- ["Has Cantor Proved the Muslim Theologians Wrong?" — SeekersGuidance](https://seekersguidance.org/answers/islamic-belief/has-cantor-proved-the-muslim-theologians-wrong/)

The standard defense (also in the original draft) is that the argument targets *concrete, ordered, existential* dependency chains, not abstract set cardinality — bijection-without-contradiction is a fact about abstract infinite sets, and whether it transfers to a chain of *really existing, temporally or causally ordered* things is exactly what's disputed. That's a live philosophical position, not a settled rebuttal of Cantor, and not a settled defeat by Cantor either.

**How this gets handled on the site, concretely:** the proof in §3 is presented as *valid* — the conclusion genuinely follows from A1–A4, machine-checked. Then, separately and just as prominently, A4's own traditional justification is presented as contested, with both directions of the Cantor exchange linked and summarized in the author's own voice as argument, not fact. This is the same move already used for Jinnah's religious identity and the *Tajrīd*'s sectarian reception elsewhere on the hub: state what's proven, state what's disputed, don't blur the two.

## 5. Site integration

Per your call: this ships as a new tier of Alvid Scriptorium, not a separate site/repo/brand. Concretely:

- **New nav item** alongside Framework / Corridors / Essays / Publications / Codicology / Methodology — something like **Formal** or **Kalām Engine**, linking to a new page (`kalam.html` or `formal.html`) built in the same design system (paper/verdigris palette, Fraunces/Source Sans/IBM Plex Mono) as the other four content pages already live.
- **That page's content:** the argument from §3 in plain prose (mirroring the existing essay format — tier badge, abstract, numbered sections, editorial note), an embedded or linked view of the actual Lean proof, the §4 discussion of *Burhān al-Taṭbīq* and Cantor with citations, and a link out to the Hugging Face Space for anyone who wants to interact with or re-run the proof themselves.
- **The GitHub repo:** a new, separate repository (e.g. `sacredcivilization/kalam-engine` or similar — your call on naming) holding the actual Lean 4 project — this is a code repo, not a Pages site, so it stays distinct from `sacredcivilization.github.io` even though the *content* it produces is linked into the hub.
- **The Hugging Face Space:** a small Gradio or Streamlit app that displays the formalized argument, runs the compiled proof (or a Z3 sanity-check encoding of the propositional skeleton) live, and states the same honest caveats as the site page — the Space should never claim more certainty than the write-up next to it.

## 6. Milestones

- **M1 — done here.** Philosophical/formal spec locked: premises stated, proof completed on paper, the Cantor tension surfaced and sourced.
- **M2.** Real Lean 4 project: transcribe §3 using `mathlib`'s well-founded-relation lemmas, compile it, and run `#print axioms` on the final theorem so the page can honestly list exactly which axioms (A1–A4, or their Lean equivalents) it actually rests on — no hidden `sorry`, no hidden `axiom` beyond A1–A4 themselves.
- **M3.** GitHub repo public, with CI (GitHub Actions) that recompiles the proof on every push, so "verified" is a live badge, not a claim.
- **M4.** Hugging Face Space live, wired to the same proof.
- **M5.** `kalam.html` (or similar) built and linked into Alvid Scriptorium's nav; homepage's Framework/Publications sections updated to reference it.

## 7. Explicitly out of scope for v1

Deontic/game-theoretic formalization of *Walāyah*; the Arabic NLP/knowledge-graph pipeline; HoTT; any claim of "first ever" (only "no prior work found" is defensible); any page copy that states A4 (or the *Burhān al-Taṭbīq* defense of it) as settled rather than as one live position in an ongoing philosophical dispute.
