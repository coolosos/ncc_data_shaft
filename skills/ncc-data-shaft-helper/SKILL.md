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

1.  **Define the Model**: Use `json_serializable` patterns if supported. Place in `lib/src/{{feature}}/remote/{{feature_remote_object}}.dart`.
2.  **Define Params**: Place in `lib/src/{{feature}}/params/{{feature_param}}.dart`.
3.  **Choose the Context**:
    *   **Public API**: Use `HttpDataShaftDriver` and `Datasource[Verb]Http`.
    *   **Authenticated API**: Use `SessionDataShaftDriver` and `Datasource[Verb]Session`.
4.  **Implement DataSource**: Place in `lib/src/{{feature}}/{{datasource}}.dart`.
    *   Annotate with `@lazySingleton` if using `injectable`.
    *   Handle `pathModification` vs `urlParams` correctly.
5.  **Set up Repository**: Place in `lib/src/{{feature}}/{{repository}}.dart`.
    *   Annotate with `@LazySingleton()` if using `injectable`.
6.  **Driver Setup**: Ensure `NccClient` is initialized with an `http.Client()`. Use the `injectable` module pattern for global registration.
7.  **Global Observability**: Suggest implementing `HttpDatasourceObserver` for centralized logging.
8.  **Generate Tests**: Create the corresponding test files in the `test/` directory.

## Patterns & Templates
For specific code implementations, tests, and **DI/Serialization/Logging** patterns, refer to [references/patterns.md](references/patterns.md).

### Quick Reference Table
| Operation | Public (Http) | Session (Authenticated) |
| :--- | :--- | :--- |
| GET | `DatasourceGetHttp` | `DatasourceGetSession` |
| POST | `DatasourcePostHttp` | `DatasourcePostSession` |
| PUT | `DatasourcePutHttp` | `DatasourcePutSession` |
| PATCH | `DatasourcePatchHttp` | `DatasourcePatchSession` |
| DELETE | `DatasourceDeleteHttp` | `DatasourceDeleteSession` |
