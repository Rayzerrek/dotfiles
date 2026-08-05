---
name: code-review-and-quality
description: Reviews a change on two independent axes — whether it follows the documented coding standards (Standards) and whether it implements what the originating spec asked for (Spec). Reports each axis separately so one does not mask the other. Use before merging any change, or when the user asks to review "since X", a PR, a working-tree diff, or "review my change". Carries a fixed code-smell baseline and skips tooling-enforced noise.
---

# Code Review & Quality

Review a change on **two independent axes**, reported separately so one cannot mask the other. Review-only: do not edit files, apply patches, or "fix as you go" unless the user explicitly asks after the review.

A change can pass one axis and fail the other:

- Code that follows every documented standard but implements the wrong thing → **Standards pass, Spec fail.**
- Code that does exactly what the issue asked but breaks project conventions → **Spec pass, Standards fail.**

Reporting them apart stops one axis from burying the other.

## 1. Pin the fixed point

Use the user's explicit target when given: files, commit range, branch, tag, PR, staged/unstaged scope.

Otherwise detect it, in order:

1. If the working tree has staged or unstaged changes, review the working-tree diff.
2. Else if the current branch has a merge base with `main`, `master`, or its upstream, review the branch diff.
3. Else ask one question to pin the target.

Record the diff command once: `git diff <fixed-point>...HEAD` (three-dot, so the comparison is against the merge-base) and the commit list `git log <fixed-point>..HEAD --oneline`. Confirm the fixed point resolves (`git rev-parse <fixed-point>`) and the diff is non-empty. A bad ref or empty diff should fail here, not mid-review.

State the selected target before reviewing.

## 2. Identify the spec and the standards

Find the originating spec, in order:

1. Issue/PR references in the commit messages (`#123`, `Closes #45`, GitLab `!67`).
2. A path the user passed as an argument.
3. A spec file under `docs/`, `specs/`, or `.scratch/` matching the branch name or feature.
4. If nothing is found, ask the user where the spec is. If there is none, the **Spec** axis reports "no spec available" and is skipped.

Identify the standards sources: whatever the repo documents about how code should be written (`CODING_STANDARDS.md`, `CONTRIBUTING.md`, `AGENTS.md`, architecture docs). On top of whatever the repo documents, the Standards axis always carries the smell baseline in §5.

Read the diff in full files, not just isolated hunks — code that looks wrong in isolation may be correct given surrounding logic.

## 3. Run both reviews

Review fully on each axis, then report them separately. Do **not** merge or rerank findings across axes — the separation is the point.

### Standards axis

For each hunk: (a) every place the diff violates a documented standard (cite the source + the rule); (b) any baseline smell you spot (name it and quote the hunk).

A documented repo standard overrides the baseline: where the repo endorses something a smell would flag, suppress the smell. Each smell is a labelled heuristic ("possible Feature Envy"), never a hard violation. Run the repo's typecheck and lint first (`npx tsc --noEmit`, `npx eslint`, the project's own check) and skip everything tooling already enforces — findings are only about what the tools cannot see.

### Spec axis

Report: (a) requirements the spec asked for that are missing or partial; (b) behavior in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding.

## 4. Proof for every finding

A finding survives only when you can show concrete evidence: a location, a reachable path or missing contract, and the behavioral consequence. Trace the change through the code, not just the diff:

- external input → parser → domain/application type;
- domain invariant → constructor/transition → persistence;
- function result → caller handling → protocol response / error / sink;
- secret source → log, telemetry, snapshot, serialization sink;
- async work → cancellation, promise ownership, concurrency, retry/idempotency;
- interface → adapter → external dependency;
- test → public interface / real seam → observable behavior.

Look especially for things agents commonly miss:

- validated-but-not-parsed data; `JSON.parse(...) as T`, `Response.json() as T`, row casts;
- expected failures hidden in throws/rejections; broad error unions where callers need semantic cases;
- secrets in messages, telemetry fields, snapshots, or arbitrary serialization;
- pass-through wrappers, dependency bags, hidden globals, raw platform bindings outside seams;
- dropped `AbortSignal`, floating promises, accidental sequential awaits;
- retryable mutations without idempotency or durable side-effect delivery;
- tests using module mocks/spies or implementation details;
- casts, `any`, non-null assertions, mutable exported contracts.

No praise, no "what's good" section.

## 5. Baseline code smells

The Standards axis always carries this fixed set — a given one is flagged only when it is present in the changed code, and a documented repo standard overrides it.

- **Mysterious Name** — name doesn't reveal what the symbol does or holds → rename; if no honest name comes, the design is murky.
- **Duplicated Code** — same logic shape in more than one hunk/file → extract the shared shape.
- **Feature Envy** — a method reaches into another object's data more than its own → move the method onto the data it envies.
- **Data Clumps** — the same few fields/params keep travelling together (a type wanting to be born) → bundle into one type.
- **Primitive Obsession** — a primitive standing in for a domain concept → give the concept its own small type.
- **Repeated Switches** — the same switch/if-cascade on the same type recurs → replace with polymorphism or one shared map.
- **Shotgun Surgery** — one logical change forces scattered edits across many files → gather into one module.
- **Divergent Change** — one module is edited for several unrelated reasons → split by reason.
- **Speculative Generality** — abstraction/parameters/hooks added for a need the spec doesn't have → delete; inline until a real need shows.
- **Message Chains** — long `a.b().c()` navigation the caller shouldn't depend on → hide behind one method.
- **Middle Man** — a class/function that mostly just delegates → cut it, call the real target.
- **Refused Bequest** — a subclass/implementer that ignores or overrides most of its inheritance → use composition.

## 6. Self-challenge findings

Before final output, try to disprove each finding:

- Does a local convention, helper, adapter, or test setup outside the diff already satisfy the standard?
- Is this a preference with no behavioral consequence?
- Is the value actually sensitive, or safely redacted before the sink?
- Is the async work intentionally sequential or bounded by the contract?
- Is the runtime/platform behavior already covered by representative tests?

Drop or downgrade findings that do not survive.

## Severity labels

- **Blocker** — likely correctness, safety, security, data-loss, runtime, idempotency, boundary, observability, or test-seam issue in changed code; or a changed path violates a documented standard non-negotiable.
- **Should Fix** — a real design, contract, maintainability, diagnosability, or correctness gap that should be addressed before merge, but is not a blocker.
- **Simplification** — a clearer/deeper/smaller design that removes unnecessary complexity without changing behavior.
- **Nit** — small local issue, low behavioral risk, usually documentation/naming/mechanical cleanup.
- **Question** — genuine ambiguity where the right call depends on product/domain intent not in evidence.

## Output format

Start with:

```md
Review target: <target>
Standards loaded: <sources>
Spec: <present (where) / absent>
```

If there are no findings, say so briefly and list the standards areas and smells checked. No praise.

For each finding:

```md
### <Severity>: <short title>

- **Where:** `file:line` or precise symbol/path
- **Standard / Spec / Smell:** <source + rule, or quoted spec/smell>
- **Proof:** <concrete code path, value flow, reachable state, or missing evidence>
- **Why it matters:** <behavioral consequence>
- **Fix direction:** <specific correction shape, not a full patch unless asked>
```

Group by severity in this order: Blocker, Should Fix, Simplification, Nit, Question. Finish with a one-line summary: count of findings per axis and the worst single item within each axis (do not pick one global worst — that is the reranking the separation avoids).

## Principles

- **Evidence over vibes.** A finding without concrete proof is a **Question** or nothing.
- **Respect existing conventions.** Do not flag rules the repo is already deliberately following; but a local convention does not excuse a correctness/safety/boundary/observability/test-integrity drift.
- **Fewer, stronger findings** over wall-of-commentary.
- **Correctness over completeness.** Focus on what a developer would copy — review illustrative examples as if a reader might paste them into a real codebase.
- **No sycophancy.** Push back on approaches with clear problems; do not water down a real bug into "a minor concern".

## Boundaries

- Skip anything tooling enforces.
- Do not claim "fails at runtime" without naming the concrete serialization/async value or state path.
- Pre-existing issues in unchanged code: only if they block merging this change.
- This skill never writes to the repository.
- Keep the review scoped and complete the task with rarely any open threads.