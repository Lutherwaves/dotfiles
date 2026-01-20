# Styling & Shadcn UI Rules

_Use for all Tailwind CSS, className, and visual state logic._

## 1. Tailwind & cn() Utility

- **Never** use string interpolation: ❌ `"bg-blue-${variant}"`.
- **Always** use `cn()` utility: ✅ `cn("bg-blue", variant === "primary" && "bg-blue-500")`.
- Mobile-first responsive: `flex flex-col md:flex-row lg:grid-cols-3`.

## 2. CVA Variants (Class Variance Authority)

- **Always** define visual states with CVA:

```tsx
const buttonVariants = cva("base", {
  variants: { variant: { primary: "bg-blue", secondary: "bg-gray" } },
});
```

- **Never** write complex `className` logic; route to variants.

## 3. Shadcn UI Components

- **Always** use shadcn primitives: Button, Input, Dialog, Sheet, Toast, etc.
- **Always** stay theme-consistent (use design tokens, never hard-code colors).
- Wrap frequently used icons in reusable components.

## 4. Layout Principles

- Prefer `flex`/`grid` composition over absolute positioning.
- Keep layout and spacing simple; avoid "utility soup".
