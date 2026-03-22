## Code Quality Standards
- Make minimal, surgical changes
- Never compromise type safety: no any, no non-null assertion operator (!), no unsafe type assertions
- Parse and validate inputs at boundaries; keep internal states typed and explicit
- Make illegal states unrepresentable; prefer ADTs/discriminated unions over boolean flags and loosely optional fields
- Prefer existing helpers/patterns over new abstractions
- Abstractions: consciously constrained, pragmatically parameterised, documented when non-obvious

## Error Handling
- Prefer errors as values over throwing exceptions for expected failure paths
- Prefer tagged/structured error types over untyped error strings
- Reserve thrown exceptions for truly exceptional, unrecoverable, or framework-boundary cases
- Propagate errors explicitly; do not swallow them or replace them with success-shaped fallbacks

## Applicability
- Apply language-, framework-, and project-specific preferences only when relevant to the current codebase
- Do not introduce new conventions solely to satisfy these instructions when the repository already uses a different intentional pattern