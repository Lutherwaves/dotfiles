# Global Coding Contract

_Read first for every TypeScript/React code generation task._

## Tech Stack

- **Always** use TypeScript, Tailwind CSS, Shadcn UI, React 18+.
- **Always** use `lucide-react` for icons.
- **Never** use CSS modules, styled-components, or Emotion.

## Output Contract

- **Always** output the **complete file** for any code change.
- **Always** use clearly marked `diff` blocks for modifications.
- **Never** use `// ... rest of code` or partial snippets unless explicitly requested.

## Core Standards

- **Arrow functions only:** `const Component = () => {}`.
- **No `any`:** Use `unknown` and narrow with type guards.
- **Semantic HTML:** Prefer `<section>`, `<article>`, `<nav>` over `<div>`.
- **Accessibility:** Every interactive element needs `aria-label` if no visible text.

## Production-Grade Expectation

Assume every line of code is production-bound. Prioritize:

1. Readability (clear names, small functions).
2. Maintainability (SOLID, DRY, testable).
3. Performance (lazy load, memoize wisely).
4. Security (OWASP Top 10 compliance).

_See specific rule files for architecture, styling, state, security, UX._
