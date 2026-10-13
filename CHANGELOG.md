## 3.0.0

### Breaking Changes

- **Updated `data_shaft` dependency** to `^3.0.0`. Because `data_shaft` is re-exported by this package, consumers inherit its breaking changes (a new `HeadParams` was added to the sealed `RequestParams`, the minimum SDK was raised to `>=3.13.0`, `cool_bedrock` was bumped to `^3.0.0`, plus changes to error context and caching semantics). Refer to the [data_shaft changelog](https://pub.dev/packages/data_shaft/changelog) for details.
- **Updated `ncc` dependency** to `^2.0.0`. `ncc` is re-exported by this package; its only change is the raised minimum SDK (`>=3.13.0`) and it introduces no public API changes.
- **Minimum SDK raised to Dart 3.13**: `environment.sdk` is now `">=3.13.0 <4.0.0"`.

### Added

- **HEAD support**: Added `DatasourceNccHead`, `DatasourceHttpHead` and `DatasourceSessionHead` to retrieve response metadata (headers) without transferring the body.

### Internal

- **Updated `coolint`** to `3.0.0` and adopted its stricter rule set (`strict-raw-types`, `unnecessary_type_name_in_constructor`, `unnecessary_breaks`, `empty_container_bodies`, etc.).
- Migrated constructor declarations to the Dart 3.13 `new(...)` syntax.
- Updated README, CHANGELOG and the AI skill documentation (HEAD classes, `Set<int>` status codes).

## 2.0.0

### Breaking Changes

- **Updated `data_shaft` dependency** to `^2.0.0`. This includes its own breaking changes from `data_shaft` 1.x (e.g., `admissibleStatusCode` now returns `Set<int>` instead of `List<int>`, and other changes to `Codable`, `RemoteDriver`, and response types). Refer to the [data_shaft changelog](https://pub.dev/packages/data_shaft/changelog) for details.
- **Renamed HTTP Datasource classes** to align with file naming convention:
  - `DatasourceGetHttp` → `DatasourceHttpGet`
  - `DatasourcePostHttp` → `DatasourceHttpPost`
  - `DatasourcePutHttp` → `DatasourceHttpPut`
  - `DatasourcePatchHttp` → `DatasourceHttpPatch`
  - `DatasourceDeleteHttp` → `DatasourceHttpDelete`
- **Renamed Session Datasource classes** to align with file naming convention:
  - `DatasourceGetSession` → `DatasourceSessionGet`
  - `DatasourcePostSession` → `DatasourceSessionPost`
  - `DatasourcePutSession` → `DatasourceSessionPut`
  - `DatasourcePatchSession` → `DatasourceSessionPatch`
  - `DatasourceDeleteSession` → `DatasourceSessionDelete`

### Internal

- Removed redundant `checkInformation` overrides in `DatasourceNcc*` base classes

### Added
- Skill for AI-Assisted Development

## 1.0.2
### Added
- Update dependency for implement covariant on transformation and checkResponse
## 1.0.1
### Added
- Update dependencies of data_shaft for cool_bedrock breaking change update
## 1.0.0 - 2026-02-23
### Added
- **Initial Release**: Complete integration between `network_cool_client` and `data_shaft`.
- **NccConnectionDriver**: Base implementation of `RemoteDriver` using `ncc`'s `BaseClient`.
- **Specialized Drivers**:
  - `HttpDataShaftDriver`: Specifically designed for public API communication using `NccClient`.
  - `SessionDataShaftDriver`: Specifically designed for authenticated communication using `SessionClient` (handles token injection and renewal).
- **Type-Safe DataSources**:
  - **Public Context**: Added `DatasourceHttpGet`, `DatasourceHttpPost`, `DatasourceHttpPut`, `DatasourceHttpPatch`, and `DatasourceHttpDelete`.
  - **Session Context**: Added `DatasourceSessionGet`, `DatasourceSessionPost`, `DatasourceSessionPut`, `DatasourceSessionPatch`, and `DatasourceSessionDelete`.
- **Core Abstractions**: Base classes `DatasourceNccGet`, `DatasourceNccPost`, etc., to allow custom driver extensions.
- **Barrel Exports**: Organized export system (`datasource_http.dart`, `datasource_session.dart`, `driver.dart`) to simplify package usage.
- **Enhanced DX**: Re-export of `Codable` from `data_shaft` to reduce boilerplate in domain models.