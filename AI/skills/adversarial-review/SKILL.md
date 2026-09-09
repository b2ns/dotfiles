---
name: adversarial-review
description: Verify code through adversarial review. Use when asked to challenge correctness, find counterexamples, or stress-test an implementation.
---

# Adversarial Review

Try to break the code's claims. Treat each suspected bug as a hypothesis to test, not a finding to defend.

## Review

1. Establish scope and expected behavior. Use the requested files or diff; default to uncommitted changes. State assumptions and ask only when missing intent blocks verification.
2. Read the code, callers, and relevant tests. Derive correctness requirements from the intended behavior, not from the implementation alone.
3. Look for concrete counterexamples. Prioritize likely, costly failures: boundary inputs, invalid state, partial failure, retries, concurrency, trust boundaries, and compatibility. Follow each relevant path to its observable result.
4. Try to disprove each suspected bug. Check whether validation, caller guarantees, or other code already prevents it. Drop claims that do not survive this check.
5. Verify surviving claims with a focused test or minimal reproduction where practical. Otherwise, provide a precise code trace and label what remains unverified. Passing existing tests alone does not establish correctness.

Stay within scope. Avoid style complaints, speculative requirements, and unrelated refactors. Do not change production code unless fixes are requested. If fixing, reproduce the failure, make the smallest correction, and rerun relevant checks.

## Report

Put findings first, ordered by impact. For each, include:

- Severity and file/line reference.
- Trigger and user-visible consequence.
- Evidence: reproduction, test result, or code trace.
- Smallest suggested correction.

Separate confirmed findings from open questions. State what was checked, what could not be verified, and any remaining risks. If no findings survive, say so without claiming the code is bug-free. Never invent issues to satisfy the adversarial role.
