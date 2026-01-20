# Development Rules for Claude

You are an expert developer working on a modern TypeScript/React application. Follow these rules for all code generation.

## Tech Stack

- **Always**: TypeScript, React 18+, Tailwind CSS, shadcn/ui, Vite
- **Package Manager**: pnpm with workspace-based monorepo (if applicable)
- **State Management**: TanStack Query for server state, React hooks for client state
- **Routing**: TanStack Router or Next.js App Router
- **Forms**: React Hook Form + Zod validation
- **Icons**: lucide-react
- **Authentication**: JWT with refresh tokens (or your preferred auth solution)
- **API Integration**: Generated API clients from OpenAPI schemas (if applicable)

## Architecture Patterns

### Monorepo Structure (if applicable)

- Apps in `apps/` directory
- Shared packages in `packages/` directory
- Use workspace imports: `import { Component } from "@workspace/ui"`

### Layout System

- Consider progressive disclosure patterns
- Use semantic HTML and accessible components
- Implement responsive design (mobile-first)

### Component Patterns

- Use compound component pattern for complex UI
- Implement `asChild` prop for polymorphic primitives
- Co-locate related logic, styles, types
- Use discriminated unions for component states

### API Integration

- Use generated API client functions when available
- Use TanStack Query for all API calls with proper query keys
- Handle loading/error states properly
- Use consistent query key patterns

## Code Standards

### TypeScript

- Arrow functions only: `const Component = () => {}`
- No `any` type - use `unknown` with type guards
- Infer types from Zod schemas: `type FormData = z.infer<typeof schema>`
- Use shared types from workspace packages when available

### React

- Semantic HTML: `<section>`, `<article>`, `<nav>` over `<div>`
- Accessibility: `aria-label` for interactive elements without visible text
- Error boundaries for async operations
- Guard clauses over deep nesting

### Styling

- Use `cn()` utility, never string interpolation
- CVA variants for component states
- Mobile-first responsive design
- Follow shadcn/ui design system

### State Management

- Server state: TanStack Query
- Client state: `useState`/`useReducer`
- URL state: filters, search, pagination
- Forms: React Hook Form + Zod

## Security

- JWT-based authentication with refresh tokens (or your preferred method)
- Role-based access control (RBAC) when needed
- Validate all inputs with Zod
- Never expose secrets or credentials

## Performance & Best Practices

### Optimization

- Dynamic imports for heavy components
- Memoize expensive calculations only
- Debounce search inputs
- Proper image optimization

### Code Quality

- Production-grade code only
- Clear naming conventions
- Small, focused functions
- Comprehensive error handling

### Testing

- Unit tests for utilities
- Component tests with React Testing Library
- Mock API responses in tests

## Output Requirements

### File Modifications

- Always output complete files
- Use clearly marked diff blocks
- Never use partial snippets unless requested

### Component Structure

```typescript
// Example component structure
import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { Card, CardHeader, CardContent } from '@workspace/ui'
import { cn } from '@workspace/ui/lib/utils'

const EntityCard = ({ entityId }: { entityId: string }) => {
  const { data, isLoading, error } = useQuery({
    queryKey: ['entity', entityId],
    queryFn: () => fetchEntity(entityId)
  })

  if (isLoading) return <div>Loading...</div>
  if (error) return <div>Error: {error.message}</div>

  return (
    <Card className={cn("w-full", "hover:shadow-md")}>
      <CardHeader>{data.name}</CardHeader>
      <CardContent>{data.description}</CardContent>
    </Card>
  )
}

export { EntityCard }
```

## Common Patterns

### Table/List Pages

```typescript
import { useQuery } from '@tanstack/react-query'

const EntitiesPage = () => {
  const { data, isLoading } = useQuery({
    queryKey: ['entities'],
    queryFn: () => fetchEntities()
  })
  
  // Table implementation
}
```

### Forms

```typescript
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const entitySchema = z.object({
  name: z.string().min(2),
  email: z.string().email()
})

type EntityForm = z.infer<typeof entitySchema>

const EntityForm = () => {
  const form = useForm<EntityForm>({
    resolver: zodResolver(entitySchema)
  })
  
  // Form implementation
}
```

### Authentication

```typescript
import { useAuth } from '@/lib/auth/AuthProvider'

const ProtectedComponent = () => {
  const { authState } = useAuth()
  const { user } = authState
  
  if (!user?.roles.includes('required-role')) {
    return <div>Access denied</div>
  }
  
  return <div>Protected content</div>
}
```
