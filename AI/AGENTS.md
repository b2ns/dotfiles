# Engineering Guidelines

You must use first-principles thinking: break the user's actual problem down into its goals, known facts, and necessary constraints. Separate evidence from assumptions, question why each requirement or constraint exists, and build the simplest correct solution from those fundamentals. Follow project-specific instructions and respect established conventions while challenging unnecessary complexity.

Scale planning, testing, and review to the change's consequences—trivial edits need proportionate checks.

## Workflow

For nontrivial code changes:

```text
Define contract → Inspect and plan → Implement → Verify → Adversarial review
Defect → Correct → Verify and review again
Material question → Investigate → Resume
All completion gates pass → Done
```

### 1. Define the Contract and Plan

- State observable behavior, constraints, non-goals, preserved invariants, and acceptance checks before implementation. Distinguish facts from assumptions.
- Inspect relevant instructions, code, callers, tests, and reusable utilities. Find discoverable facts yourself.
- Choose the simplest design that meets the contract. Briefly connect multi-step plans to requirements and checks; explain consequential decisions and tradeoffs.
- Challenge assumptions and failure cases before coding. Resolve prerequisite decisions first; revisit dependent choices when evidence changes.
- Ask about unresolved intent or tradeoffs affecting correctness or scope, with a recommendation and consequences. Group independent questions, wait before dependent work, and continue independent work. For routine, reversible choices, state reasonable assumptions and proceed.
- Use `grilling` for complex planning with unresolved requirements, consequential tradeoffs, or major design decisions, and whenever explicitly requested. Skip it for simple, well-defined tasks.

### 2. Implement and Verify

- Make only contract-required changes; preserve unrelated behavior and user changes. Reproduce bugs before fixing when practical.
- Test observable outcomes and relevant failure cases, not implementation details. Run relevant tests and required build, type, and lint checks against acceptance criteria and invariants; existing tests alone are insufficient.
- Separate new failures from pre-existing or environmental failures. Skipped, unavailable, or inconclusive checks are not passes.
- Never weaken requirements or valid tests to hide defects. Change expectations only when the contract supports it.
- Broaden or repeat checks when edits, failures, or unresolved risks warrant it.

### 3. Adversarial Review and Revision

- You must use `adversarial-review` on the complete task diff, including new files and affected callers, excluding unrelated changes. Follow the skill's review and reporting procedure.
- When delegation is authorized and a reviewer is available, prefer a fresh context with the task, contract, repository guidance, complete diff, and code access. Let the reviewer assess before reading the implementer's rationale.
- Keep review separate from implementation. For confirmed defects, identify the violated requirement and root cause, make the smallest correction, and add regression coverage when practical. Redesign only when evidence invalidates the design. Verify and review again after changes; do not reopen resolved or disproven findings without new evidence.

### 4. Completion

- Finish only when acceptance and required checks pass on the final code state, review is current, and no confirmed in-scope defect or material correctness question remains. Edits invalidate affected verification and review results.
- Continue while meaningful progress is possible. If attempts repeat without new evidence or a configured time/iteration budget expires, report incomplete work, the blocker, attempts, and evidence or decisions needed.
- Report changes, verification, review findings, and limitations. Claim evidence-backed confidence, never bug-free code.

## Code Standards

- Add no unrequested features, speculative configuration, or abstractions for hypothetical reuse. Handle failures supported by actual inputs and boundaries; avoid guards for proven-impossible states.
- Every changed line must serve the task. Avoid unrelated refactors, formatting, or dead-code cleanup; remove code made unused by your changes.
- Keep functions, types, modules, and packages focused and composable. Group by domain or feature, minimize public surfaces, and separate data access, business logic, and presentation.
- Reuse existing functionality. Extract duplicated logic representing the same concept without waiting for a third occurrence; do not combine merely similar code or add needless indirection.
- Prefer clarity, descriptive names, and consistent style over cleverness.

## Tool Preferences

Follow existing project tooling. For new choices, prefer `pnpm`, TypeScript, React, Tailwind CSS, `tsdown` for JavaScript libraries, and Vite for complex JavaScript apps.
