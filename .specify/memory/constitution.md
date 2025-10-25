<!-- Sync Impact Report:
Version change: 1.0.0
Modified principles: All 5 principles created new
Added sections: Architecture Standards, Code Quality
Removed sections: None
Templates requiring updates: ⚠ .specify/templates/plan-template.md (Constitution Check section), .specify/templates/tasks-template.md (Task categorization)
Follow-up TODOs: None
-->
# React + Rust Clean Architecture Constitution

## Core Principles

### I. Clean Architecture Separation
Frontend (React) and Backend (Rust) MUST be completely separate deployments. React communicates via REST/GraphQL APIs only; No shared state or direct database access from frontend; Clear contract boundaries through API specifications.

### II. Rust Safety & Performance First
All Rust code MUST use Rust's safety features (ownership, borrowing, lifetimes); Prefer composition over inheritance; Use Result<T, E> for error handling; Zero-cost abstractions principle; No unsafe blocks without explicit safety justification.

### III. React Component Cleanliness
React components MUST be single-responsibility and reusable; Custom hooks for shared logic; Functional components with hooks only; Props interface MUST be TypeScript-defined; No direct API calls in components - use service layer.

### IV. Test-Driven Development (NON-NEGOTIABLE)
TDD mandatory: Tests written → User approved → Tests fail → Then implement; Integration tests for API contracts; Component tests for React; Property-based tests for Rust business logic; Minimum 80% code coverage required.

### V. API Contract Stability
API contracts between Rust backend and React frontend MUST be versioned; Breaking changes require new API version; Backward compatibility maintained for at least one version; OpenAPI/Swagger documentation required for all endpoints.

## Architecture Standards

### Project Structure
```
frontend/          # React TypeScript application
├── src/
│   ├── components/    # Reusable UI components
│   ├── pages/        # Route-level components
│   ├── hooks/        # Custom React hooks
│   ├── services/     # API client layer
│   ├── types/        # TypeScript type definitions
│   └── utils/        # Pure utility functions
├── tests/            # Component and integration tests
└── package.json

backend/           # Rust application
├── src/
│   ├── handlers/     # HTTP request handlers
│   ├── services/     # Business logic layer
│   ├── models/       # Data structures and domain models
│   ├── repositories/ # Data access layer
│   └── middleware/   # HTTP middleware
├── tests/            # Unit and integration tests
├── migrations/       # Database migrations
└── Cargo.toml
```

### Communication Protocol
- React → Rust: HTTP/HTTPS REST or GraphQL requests
- Authentication: JWT tokens with refresh mechanism
- Data Format: JSON for requests/responses
- Error Handling: Structured error responses with error codes
- Documentation: Auto-generated OpenAPI specification

## Code Quality Standards

### Rust Requirements
- Use `rustfmt` for consistent formatting
- Use `clippy` with strict rules enabled
- All public functions MUST have documentation comments
- Error handling with `thiserror` or custom error types
- Logging with structured logging (tracing/serde)
- Configuration via environment variables

### React Requirements
- TypeScript strict mode enabled
- ESLint + Prettier for code formatting
- All components MUST have PropTypes/TypeScript interfaces
- Accessibility compliance (WCAG 2.1 AA minimum)
- Performance monitoring with React DevTools Profiler
- State management with Context API or external library (Redux Toolkit/Zustand)

### Database Standards
- All migrations MUST be reversible
- Foreign key constraints enforced
- Connection pooling configured appropriately
- Query optimization for N+1 problems
- Regular backup and restore procedures documented

## Development Workflow

### Quality Gates
- All code MUST pass automated tests before merge
- Zero security vulnerabilities allowed
- Performance budgets must be respected (<200ms API response, <3s FCP)
- Code review required for all changes
- Documentation updates同步 with code changes

### Branch Strategy
- Main branch always deployable
- Feature branches from main
- Pull requests required for all changes
- Automated CI/CD pipeline with quality checks
- Semantic versioning for releases

### Testing Requirements
- Unit tests for all business logic
- Integration tests for API endpoints
- Component tests for React components
- End-to-end tests for critical user journeys
- Performance tests for all endpoints

## Governance

This constitution supersedes all other development practices. Amendments require:
1. Documented proposal with reasoning
2. Team review and approval
3. Version increment according to semantic versioning
4. Migration plan for existing code
5. Updated documentation and templates

All pull requests must verify compliance with these principles. Any deviation must be explicitly justified and approved by team consensus. Use this constitution as the foundation for all architectural decisions and code reviews.

**Version**: 1.0.0 | **Ratified**: 2025-01-24 | **Last Amended**: 2025-01-24