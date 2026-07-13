# Tool Preferences

## Frontend & node.js server

- Prefer `pnpm` when installing dependencies in javascript project.
- Prefer `typescript` when coding javascript code.
- Prefer `react` when writing frontend ui.
- Prefer `tailwindcss` when styling css.
- Prefer `tsdown` when buiding javascript librarius.
- Prefer `vite` when buiding complex javascript project.

# Code Guidelines

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

# Code Quality Standards

Write code like a senior engineer who cares about long-term maintainability, not just getting something to run.

## Organization & modularity

- Split code into small, focused modules/files/packages, each with a single clear responsibility. Avoid dumping unrelated logic into one file.
- Group related functionality together (by domain/feature, not by type) so related code is easy to find and change together.
- Keep public/exported surfaces minimal — expose only what other modules actually need; keep implementation details unexported/private.
- Prefer clear boundaries between layers (e.g. data access, business logic, presentation/API) so each can change independently.

## Reuse

- Before writing new code, look for existing functions/types/utilities in the codebase that already do what's needed — reuse or extend them instead of duplicating logic.
- When the same logic appears twice, extract it into a shared function/module. Don't wait for a third occurrence if the duplication is already clearly the same concept.
- Design functions and types to be composable (small, orthogonal pieces) rather than monolithic, so future code can reuse them without modification.
- Don't over-abstract speculatively — only extract shared abstractions for logic that is actually duplicated or clearly reusable now, not for hypothetical future needs.

## General discipline

- Favor clarity and explicitness over cleverness.
- Use descriptive names for files, packages, functions, and variables so intent is obvious without extra comments.
- Keep functions small and focused on one task; keep files focused on one concern.
- Maintain consistent structure/conventions across the codebase so modules feel like they were written by the same disciplined author.
