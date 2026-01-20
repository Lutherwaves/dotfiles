# UX – Library/SDK Design Heuristics

_Use when building hooks, utilities, shared components._

## 1. Visibility of System Status

- Clear errors/logs; predictable thrown error types.

## 2. Match with Real World

- API shaped like domain model + React patterns.

## 3. User Control & Freedom

- No magic; provide escape hatches + configuration.

## 4. Consistency & Standards

- Follow project naming (`useX` hooks, `createX` factories).

## 5. Error Prevention

- Strong TS types, discriminated unions, exhaustive checks.

## 6. Recognition vs Recall

- Self-explanatory names + IntelliSense docs.

## 7. Flexibility & Efficiency

- Composable primitives; tree-shakeable modules.

## 8. Minimalist Design

- Small, focused exports; no "god" utilities.

## 9. Help Recover from Errors

- Clear messages with suggested remedies.

## 10. Help & Documentation

- JSDoc + README examples.
