## 1.0.0 - 2026-02-23
### Added
- **Initial Release**: Complete integration between `network_cool_client` and `data_shaft`.
- **NccConnectionDriver**: Base implementation of `RemoteDriver` using `ncc`'s `BaseClient`.
- **Specialized Drivers**:
  - `HttpDataShaftDriver`: Specifically designed for public API communication using `NccClient`.
  - `SessionDataShaftDriver`: Specifically designed for authenticated communication using `SessionClient` (handles token injection and renewal).
- **Type-Safe DataSources**:
  - **Public Context**: Added `DatasourceGetHttp`, `DatasourcePostHttp`, `DatasourcePutHttp`, `DatasourcePatchHttp`, and `DatasourceDeleteHttp`.
  - **Session Context**: Added `DatasourceGetSession`, `DatasourcePostSession`, `DatasourcePutSession`, `DatasourcePatchSession`, and `DatasourceDeleteSession`.
- **Core Abstractions**: Base classes `DatasourceNccGet`, `DatasourceNccPost`, etc., to allow custom driver extensions.
- **Barrel Exports**: Organized export system (`datasource_http.dart`, `datasource_session.dart`, `driver.dart`) to simplify package usage.
- **Enhanced DX**: Re-export of `Codable` from `data_shaft` to reduce boilerplate in domain models.