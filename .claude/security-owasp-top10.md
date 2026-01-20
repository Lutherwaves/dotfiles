# Security – OWASP Top 10 Compliance

_Apply to all code: frontend, backend, APIs, config._

## Secure by Default

- **Assume every input is untrusted.**
- **Never** use `dangerouslySetInnerHTML` for user content.

## OWASP Top 10 Guidelines

### A01: Broken Access Control

- Enforce authorization server-side; never trust client flags.

### A02: Cryptographic Failures

- Never roll custom crypto; use platform libraries + secret management.

### A03: Injection

- Always use parameterized queries/ORM; never interpolate user input.

### A04: Insecure Design

- Threat model critical flows; design for least privilege.

### A05: Security Misconfiguration

- Disable debug in production; secure headers; restrict admin endpoints.

### A06: Vulnerable Components

- Keep dependencies updated; avoid unmaintained packages.

### A07: Identification Failures

- Delegate to Auth provider; never store plaintext credentials.

### A08: Integrity Failures

- Pin dependencies; verify CI/CD artifacts.

### A09: Logging Failures

- Log auth failures, access-denied, unexpected errors (without secrets).

### A10: SSRF

- Never fetch arbitrary user-provided URLs; whitelist domains.

## Frontend Security

- Validate URL params and query params with Zod.
- Sanitize/escape user-visible strings.
