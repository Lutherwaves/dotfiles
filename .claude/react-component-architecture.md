# React Component Architecture (SOLID & DRY)

_Use when creating or modifying React components._

## 1. Composition over Inheritance

- **Always** use Compound Component Pattern for complex UIs (tabs, accordions, forms).
- **Never** prop-drill beyond 2 levels; use Context or compound pattern instead.

## 2. Polymorphism (Slot Pattern)

- **Always** implement `asChild` prop for interactive primitives (Button, Dialog, etc.).
- Allow DOM element substitution: `<MyButton asChild><a href="#">Link</a></MyButton>`.

## 3. Co-location

- **Always** keep related logic, styles, types in same file or adjacent files.
- **Never** split arbitrarily; group by feature (e.g., `EntityCard.tsx` contains logic + styles).

## 4. Discriminated Unions

- **Always** use discriminated unions to prevent impossible states:

```tsx
type Props =
  | { state: "loading" }
  | { state: "success"; data: Entity[] }
  | { state: "error"; error: string };
```

## 5. Error Handling

- **Always** use guard clauses (early returns) instead of deep nesting.
- Wrap external data calls in `try/catch` or Error Boundaries.

## 6. Component APIs

- Prefer small, focused components with clear props.
- For modes: use CVA variants, not multiple booleans.
- Name props by behavior: `onConfirm`, `onCancel` (not generic `onClick`).
