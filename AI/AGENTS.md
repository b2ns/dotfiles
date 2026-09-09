# Engineering Guidelines

Build the simplest correct solution to the user's problem. Use first-principles thinking to derive requirements, inspect evidence, and challenge unnecessary complexity while respecting established conventions.

Apply these guidelines alongside project-specific instructions. Scale planning, testing, and review to the change's complexity and consequences; trivial edits need a proportionate check, not a lengthy process. The goal is evidence-backed confidence, never a promise of bug-free code.

## Implementation and Verification Loop

Follow this workflow for nontrivial code changes:

```text
Define requirements → Inspect → Plan → Implement → Verify → Adversarial review

Confirmed defect → Revise design if needed → Implement → Verify → Review again
Material open question → Investigate → Resume the appropriate phase
All completion gates pass → Done
```

### 1. Establish the Contract

- State the intended observable behavior, constraints, and non-goals.
- Identify invariants: properties that must remain true, including existing behavior that the change must preserve.
- Separate verified facts from assumptions. Surface interpretations that would materially change the solution.
- Ask before dependent work when missing information affects correctness or scope. For routine, reversible choices, state a reasonable assumption and proceed.
- Define acceptance checks before implementation. Do not weaken requirements or checks merely to make an implementation pass.

### 2. Inspect and Plan from Requirements

- Read relevant code, callers, tests, and repository instructions. Verify assumptions against the actual system.
- Look for existing functions, types, and utilities to reuse or extend.
- Break the problem into fundamental requirements and choose the simplest design that satisfies them. Explain a simpler approach when one exists.
- State key decisions, assumptions, and tradeoffs briefly. Revisit established conventions only when evidence justifies doing so.
- For multi-step tasks, give a short plan that connects each implementation step to a requirement and a verification check.

Translate requests into observable checks, for example:

- Add validation → invalid inputs are rejected and valid inputs still work.
- Fix a bug → reproduce the failure, then verify the correction.
- Refactor → relevant behavior checks pass before and after.

#### Stress-Test the Design

- Before implementation, challenge the plan's key assumptions: does it solve the actual problem, what could invalidate it, and could a simpler approach satisfy the same contract?
- Identify consequential decisions and their dependencies. Resolve prerequisites before deciding details that depend on them; revisit downstream decisions if a prerequisite changes.
- Find discoverable facts in the code, documentation, or tools yourself. Ask the user about unresolved intent, priorities, and tradeoffs that materially affect the solution, with a recommended answer and its consequences.
- When several user decisions are needed, group independent questions into a concise round. Wait for answers before asking dependent questions, while continuing work that does not depend on them.
- Proceed once material decisions are resolved and remaining assumptions are explicit and reasonable. Reopen design questions during revision only when new evidence warrants it.
- Use the `grilling` skill for an explicitly requested grilling session or structured design interview. Its exhaustive interview and confirmation steps are opt-in; routine planning uses the focused checks above.

### 3. Implement Focused Changes

- Implement only what the contract requires, following the code standards below.
- For bug fixes, reproduce the failure before correcting it when practical.
- Add meaningful tests for changed behavior and relevant failure cases. Test expected outcomes rather than copying implementation details into assertions.
- Preserve unrelated behavior and existing user changes.

### 4. Verify Against the Contract

- Run relevant tests and required repository checks, including build, type, or lint checks where applicable.
- Check observable outcomes against acceptance criteria and invariants. Passing existing tests alone does not establish correctness.
- Distinguish new failures from pre-existing or environmental failures. Never treat skipped, unavailable, or inconclusive checks as passing.
- Do not delete or weaken a valid test to hide a defect. Change an expectation only when the contract supports the new behavior.
- Broaden testing when changed behavior, failures, or unresolved risks justify it; avoid repeating unchanged checks without a reason.

### 5. Adversarial Review

- Use the `adversarial-review` skill when available; otherwise follow the review procedure here.
- Review the complete task diff, including added files and affected callers, not only the latest correction. Keep unrelated changes outside the review scope.
- Derive expectations from the contract independently of the implementation. Seek concrete counterexamples in relevant boundaries, state transitions, partial failures, retries, concurrency, trust boundaries, and compatibility.
- Treat suspected defects as hypotheses. Try to disprove each one by checking validation, caller guarantees, and surrounding code before reporting it.
- Support surviving findings with a focused test or minimal reproduction where practical; otherwise provide a precise code trace and label what remains unverified.
- For each finding, record severity, file and line, trigger, observable consequence, evidence, and the smallest suggested correction. Separate confirmed defects from unresolved questions.
- Avoid style complaints, speculative requirements, unrelated refactors, and invented findings.
- When a separate reviewer is available and delegation is authorized, prefer a fresh reviewer context. Provide the task, contract, repository guidance, complete diff, and access to relevant code. Let the reviewer form an assessment before reading the implementer's justification.
- During review, identify findings without editing production code. Apply corrections in the implementation phase; a review-only request does not authorize fixes.

### 6. Revise Based on Evidence

- For each confirmed defect, identify the violated requirement and root cause.
- Redesign only when evidence shows the design's assumptions or structure are wrong. Otherwise make the smallest correct fix.
- Add a regression test when practical, then repeat verification and adversarial review after changes.
- Track findings and their evidence so resolved or disproven findings are not reopened without new evidence.
- Investigate material open questions before declaring success. Do not turn unsupported suspicions into unnecessary code changes.

### 7. Finish or Report an Impasse

- Finish when acceptance checks and required checks pass, no confirmed in-scope defects remain, and no material correctness question is unresolved.
- Ensure verification and review apply to the final code state. Subsequent edits require renewed checks and review appropriate to their impact.
- Continue while meaningful progress is possible. If attempts repeat without new evidence or a configured time or iteration budget is exhausted, report the work as incomplete with the unresolved issue, attempted approaches, and the evidence or decision needed to proceed.
- Report what changed, verification results, review findings, and remaining limitations. Never claim the result is bug-free.

## Code Standards

### Simplicity and Scope

- Add no unrequested features, speculative configurability, or abstractions for hypothetical reuse.
- Handle failures supported by the system's inputs and boundaries; avoid defensive branches for states already proven impossible.
- Every changed line should trace to the task. Do not refactor adjacent code, alter unrelated formatting, or remove pre-existing dead code without a task-related reason. Mention unrelated issues when useful.
- Remove imports, variables, functions, and other code made unused by your changes.

### Organization and Reuse

- Keep functions, modules, files, and packages focused on a clear responsibility. Group related functionality by domain or feature within established repository conventions.
- Keep public surfaces minimal and maintain clear boundaries between data access, business logic, and presentation.
- Reuse existing functionality before adding new code. When duplicated logic represents the same concept, extract it into a shared function or module; do not wait for a third occurrence.
- Prefer small, composable functions and types. Avoid abstractions that merely combine superficially similar code or add indirection without current value.
- Favor clarity over cleverness. Use descriptive names and consistent structure and style.

## Automated Execution

When implementing an external controller for this workflow:

- Record the exact code state reviewed and tested, including uncommitted changes. Invalidate affected results after edits.
- Run required checks through the controller and inspect exit codes; do not rely solely on an agent's success claim.
- Require structured review results and treat missing, malformed, or incomplete results as unsuccessful.
- Route confirmed defects back to implementation and unresolved material questions to investigation.
- Enforce a configured time or iteration budget. Exhausting it means incomplete, not successful.

## Tool Preferences

Follow established project tooling; for new choices, prefer:

- `pnpm` for JavaScript dependency management.
- TypeScript for JavaScript projects.
- React for frontend UI.
- Tailwind CSS for styling.
- `tsdown` for building JavaScript libraries.
- Vite for complex JavaScript applications.
