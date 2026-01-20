# State, Data & Performance Rules

_Use for data fetching, forms, state management, optimization._

## 1. State Management

### Server vs Client State

- **Server State** (fetched data, user prefs): TanStack Query / React Query.
- **Client State** (modals, expanded rows): `useState` / `useReducer`.

### URL as State

- **Always** store ephemeral state in URL: filters, search, pagination.
- Use Next.js `searchParams` or `nuqs`.
- **Never** use `useState` for list query params (breaks back/forward).

### Forms & Validation

- **Always** use React Hook Form + Zod resolver.
- Infer types: `type FormData = z.infer<typeof schema>`.

## 2. Performance Optimization

### Images

- **Always** use `next/image` with explicit `width/height` or `fill` + `sizes` (if using Next.js).

### Dynamic Imports

- **Always** use dynamic imports for heavy components (charts, large lists):

```tsx
const HeavyChart = dynamic(() => import("./HeavyChart"), { ssr: false });
```

### Debouncing

- **Always** debounce search inputs and rapid-fire events: `useDebounce`.

### Memoization

- Use `useMemo`/`useCallback` **only** for:
  - Expensive calculations.
  - Props passed to deep children needing reference stability.
- **Never** wrap primitives or trivial values.
