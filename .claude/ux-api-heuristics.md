# UX – API Design Heuristics (Nielsen-adapted)

_Use when designing HTTP endpoints, RPC, internal APIs._

## 1. Visibility of System Status

- Clear status codes + structured error responses.

## 2. Match with Real World

- Resource/field names match domain concepts.

## 3. User Control & Freedom

- Idempotent/safe methods; support pagination, cancellation.

## 4. Consistency & Standards

- Consistent naming, HTTP methods, error envelope.

## 5. Error Prevention

- Strong Zod/OpenAPI validation; reject invalid input precisely.

## 6. Recognition vs Recall

- Discoverable via OpenAPI docs + introspection.

## 7. Flexibility & Efficiency

- Filtering, sorting, pagination, bulk operations.

## 8. Minimalist Design

- Single responsibility per endpoint.

## 9. Help Recover from Errors

- Error responses include field-level hints.

## 10. Help & Documentation

- Up-to-date OpenAPI spec + examples.
