---
name: ncc-data-shaft-helper
description: Assists in creating DataSources, Repositories, and Models using the ncc_data_shaft package. Use when a user needs to implement a data layer, networking, or session-aware endpoints.
---

# Ncc Data Shaft Helper

## Overview
This skill provides standardized workflows and code patterns for implementing a robust data layer using `ncc_data_shaft`. It bridges `ncc` (session management) and `data_shaft` (clean architecture).

## Information Gathering
Before generating any files, **you MUST ask the user** for the following information if it's not already clear from the request:
1.  **Endpoint Context**: Is this a Public API or an Authenticated (Session) API?
2.  **Base URL (Host)**: e.g., `https://api.example.com/`
3.  **Endpoint Path**: e.g., `users/profile` or `posts/{id}`
4.  **Request Parameters**: What inputs does the endpoint need? (e.g., query params, body data, path segments).
5.  **Success Codes**: Default is `[200]`.
6.  **Advanced Features**: Does the project use `json_serializable` or `injectable`?

## Directory Structure
Every component MUST be generated in its own file following this modular structure:

### Source Files (in `lib/`)
```text
lib/src/{{feature}}/
├── {{datasource}}.dart
├── {{repository}}.dart
├── params/
│   └── {{feature_param}}.dart
└── remote/
    └── {{feature_remote_object}}.dart
```

### Test Files (in `test/`)
```text
test/{{feature}}/
├── {{datasource}}_test.dart
├── {{repository}}_test.dart
└── remote/
    └── {{feature_remote_object}}_test.dart
```

## Workflow Decision Tree

Choose the path based on the project's tooling (question 6 in Information Gathering).

### Path A — Manual (without json_serializable / injectable)

1.  **Define Params**: Place in `lib/src/{{feature}}/params/{{feature_param}}.dart`. Extend `Params` and implement `isValid` + `props`.
2.  **Define Model**: Place in `lib/src/{{feature}}/remote/{{feature_remote_object}}.dart`. Implement `Codable` manually with a custom `decode()` method.
3.  **Choose the Context**:
    *   **Public API**: Use `HttpDataShaftDriver` and `DatasourceHttp[Verb]`.
    *   **Authenticated API**: Use `SessionDataShaftDriver` and `DatasourceSession[Verb]`.
4.  **Implement DataSource**: Place in `lib/src/{{feature}}/{{datasource}}.dart`.
    *   Handle `pathModification` vs `urlParams` correctly in `generateCallRequirement`.
    *   Implement `transformation()` to map `RequestResponse` → `RemoteObject`.
5.  **Set up Repository**: Place in `lib/src/{{feature}}/{{repository}}.dart`.
    *   Use `SafeRepositoryDatasourceCallable` for basic error mapping.
    *   Or use `DeduplicationCacheRepository` if caching with TTL is needed.
6.  **Initialize Driver**: Create `HttpDataShaftDriver` or `SessionDataShaftDriver` in your app setup (e.g., `main.dart` or a provider).
7.  **Generate Tests**: Create test files under `test/{{feature}}/` (see Patterns & Templates).

### Path B — With json_serializable + injectable

1.  **Define Params**: Same as Path A. Place in `lib/src/{{feature}}/params/`.
2.  **Define Model**: Place in `lib/src/{{feature}}/remote/`. Use `@JsonSerializable`, `part '*.g.dart'`, and `factory fromJson()`.
3.  **Configure DI Module**: Create a `@module` with `http.Client`, `NccClient`, `SessionClient`, and both drivers as `@LazySingleton`.
4.  **Implement DataSource**: Same as Path A, but annotate with `@LazySingleton()`.
5.  **Set up Repository**: Same as Path A, but annotate with `@LazySingleton()`.
6.  **Global Observability**: Implement `HttpDatasourceObserver` and assign it to `DatasourceObserverInstances.httpDatasourceObserver`.
7.  **Generate Tests**: Same as Path A.

## Patterns & Templates
For specific code implementations, tests, and **DI/Serialization/Logging** patterns, refer to [references/patterns.md](references/patterns.md).

### Quick Reference Table
| Operation | Public (Http) | Session (Authenticated) |
| :--- | :--- | :--- |
| GET | `DatasourceHttpGet` | `DatasourceSessionGet` |
| POST | `DatasourceHttpPost` | `DatasourceSessionPost` |
| PUT | `DatasourceHttpPut` | `DatasourceSessionPut` |
| PATCH | `DatasourceHttpPatch` | `DatasourceSessionPatch` |
| DELETE | `DatasourceHttpDelete` | `DatasourceSessionDelete` |
