## 2.0.0

### Breaking Changes

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