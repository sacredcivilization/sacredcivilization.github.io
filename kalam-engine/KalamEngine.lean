/-
  KalamEngine.lean — The Wājib al-Wujūd (Necessary Existent) argument

  Alvid Scriptorium — Computational Theology Tier, v1, Milestone M2
  Source: `claude/kalam-computational-theology-scope-v1.md`, §3

  This formalizes the tripartite modal-status argument at the core of the ontology
  section of Naṣīr al-Dīn al-Ṭūsī's *Tajrīd al-I'tiqād*, itself inherited from
  Avicenna's modal metaphysics (the Necessary/Contingent/Impossible trichotomy,
  and the regress-blocking argument historically called *Burhān al-Taṭbīq*).

  DESIGN NOTE: this file deliberately uses ONLY Lean 4's core library — no Mathlib
  import. The argument only needs the bare well-founded-recursion machinery that
  ships with the compiler itself (`Acc`, `WellFounded`), so pulling in Mathlib
  would add a large, unnecessary dependency for what the proof actually requires.
  This also keeps CI build times small (see `.github/workflows/build.yml`).

  HONESTY NOTE (this matters more here than in most code): every substantive
  assumption of the argument is stated below as an explicit `axiom`, in Lean's own
  sense of the word — a proposition asserted without proof. `Entity`, `status`,
  `Exists_`, and `cause` are uninterpreted primitives (a standard formalization
  technique, not evidence of anything); A2, A3, and A4 are the actual philosophical
  premises. Running `#print axioms necessary_root_exists` at the bottom of this
  file lists every one of them — nothing is hidden, and nothing here is asserted
  as "proven" beyond what the axioms make deductively available. A4 in particular
  is NOT treated as beyond dispute: see the accompanying essay for why (the
  Cantor/*Burhān al-Taṭbīq* tension).
-/

/-- An abstract domain of "entities." The argument makes no assumption about what
    an entity *is* — only about the modal-status and causal structure imposed on it
    by the axioms below. -/
axiom Entity : Type

/-- **A1 (Trichotomy).** Every entity's modal status is exactly one of Necessary,
    Contingent, or Impossible. This premise is encoded structurally: `Status` is a
    three-constructor inductive type, so `status e` (below) always returns exactly
    one of these three values by construction — there is no separate axiom to state
    for A1 beyond defining the type this way. -/
inductive Status where
  | necessary  : Status
  | contingent : Status
  | impossible : Status
deriving DecidableEq, Repr

/-- `status e` is the modal status of entity `e`. -/
axiom status : Entity → Status

/-- `Exists_ e` holds iff `e` actually exists (as opposed to merely being a
    conceivable/definable entity). Named with a trailing underscore only because
    `Exists` collides with Lean's own `Exists` (the `∃` quantifier). -/
axiom Exists_ : Entity → Prop

/-- `cause c e` reads "c causes e." -/
axiom cause : Entity → Entity → Prop

/-- **A2 (No impossible existents).** Definitional and uncontroversial: whatever is
    modally Impossible does not exist. -/
axiom A2 : ∀ e : Entity, status e = Status.impossible → ¬ Exists_ e

/-- **A3 (Principle of Sufficient Reason for contingents).** Every existing
    Contingent entity has an existing cause. This is the substantive metaphysical
    premise: a philosopher who accepts brute, uncaused contingent facts rejects A3.
    The argument's *validity* does not depend on A3 being true — only its
    *soundness* does. -/
axiom A3 : ∀ e : Entity, Exists_ e → status e = Status.contingent →
    ∃ c : Entity, Exists_ c ∧ cause c e

/-- **A4 (Well-foundedness of causation).** The causal-dependency relation admits no
    infinite descending chain: you cannot regress backward through causes forever.
    This is where *Burhān al-Taṭbīq* enters historically, and where the argument is
    genuinely contested today (see the Cantor discussion in the accompanying essay,
    §4 of the scope document) — A4 is stated here as a premise to be examined, not
    a settled fact. -/
axiom A4 : WellFounded cause

/-!
  ## The theorem

  If at least one Contingent entity exists, then a Necessary entity exists.

  **Proof idea.** Because `cause` is well-founded (A4), every entity is
  `Acc`essible under it — informally, every backward causal chain from any given
  entity eventually bottoms out. We do well-founded induction on the given
  contingent, existing entity: at each step, A3 hands us an existing cause; if that
  cause is Necessary we are done, if it is Impossible A2 gives a contradiction
  (it was asserted to exist), and if it is Contingent we recurse — and the
  recursion is licensed exactly because `cause` is well-founded, so this process
  cannot continue forever and must terminate at a Necessary entity.
-/

/-- **Main theorem** (`necessary_root_exists` — matching the name used in the
    original, unfinished draft this file replaces; here it is actually proved,
    with no `sorry`). -/
theorem necessary_root_exists
    (x0 : Entity) (hx0_exists : Exists_ x0) (hx0_contingent : status x0 = Status.contingent) :
    ∃ n : Entity, Exists_ n ∧ status n = Status.necessary := by
  -- Generalize to: every entity accessible under `cause`, if existing and
  -- Contingent, has a Necessary entity downstream of it in the causal order.
  have main : ∀ e : Entity, Acc cause e →
      Exists_ e → status e = Status.contingent →
      ∃ n : Entity, Exists_ n ∧ status n = Status.necessary := by
    intro e h
    induction h with
    | intro y _ ih =>
      intro hy_exists hy_contingent
      obtain ⟨c, hc_exists, hc_cause⟩ := A3 y hy_exists hy_contingent
      match hstat : status c with
      | .necessary  => exact ⟨c, hc_exists, hstat⟩
      | .impossible => exact absurd hc_exists (A2 c hstat)
      | .contingent => exact ih c hc_cause hc_exists hstat
  exact main x0 (A4.apply x0) hx0_exists hx0_contingent

-- Full transparency: list every axiom this theorem actually rests on. This line's
-- output (captured in CI, see .github/workflows/build.yml) is the honest answer to
-- "what does this proof assume" — it should be exactly {Entity, status, Exists_,
-- cause, A2, A3, A4, propext/Classical.choice if any tactic above pulled them in}
-- and nothing else. No `sorry`.
#print axioms necessary_root_exists
