# ncc_data_shaft ⚡️

**Bridge between robust networking and clean data architecture. Ncc and data_shaft**

[![Pub Version](https://badgen.net/pub/v/ncc_data_shaft)](https://pub.dev/packages/ncc_data_shaft/)
[![Pub Likes](https://badgen.net/pub/likes/ncc_data_shaft)](https://pub.dev/packages/ncc_data_shaft/score)
[![Pub Points](https://badgen.net/pub/points/ncc_data_shaft)](https://pub.dev/packages/ncc_data_shaft/score)
[![Pub Downloads](https://badgen.net/pub/dm/ncc_data_shaft)](https://pub.dev/packages/ncc_data_shaft)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/ncc_data_shaft)](https://pub.dev/packages/ncc_data_shaft/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/coolosos/ncc_data_shaft/blob/main/LICENSE)
[![](https://img.shields.io/badge/linted%20by-coolint-0553B1)](https://pub.dev/packages/coolint)
[![codecov](https://codecov.io/gh/coolosos/ncc_data_shaft/graph/badge.svg)](https://codecov.io/gh/coolosos/ncc_data_shaft)

**ncc_data_shaft** is the official glue that joins the power of [Ncc](https://pub.dev/packages/ncc) (session management, auto-renewal, and network state tracking) with the architectural rigor of [data_shaft](https://pub.dev/packages/data_shaft) (Clean Architecture, strict typing, and error handling).

This package provides a standardized RemoteDriver implementation powered by the Ncc BaseClient. It eliminates the need for manual adapters by offering pre-configured drivers and specialized data sources for both public and authenticated communication.

---

## Key Features

* 🛡️ Context-Strict Typing: The compiler prevents you from using a public client for an endpoint requiring a session (e.g., DatasourceGetSession vs DatasourceGetHttp).
* 🚀 Zero Boilerplate: Includes HttpDataShaftDriver and SessionDataShaftDriver ready to use.
* 📦 All-in-One: Seamlessly bridges data_shaft repositories with ncc session logic and interceptors.
* 🔄 Transparent Auto-Renewal: Requests failing due to expired tokens are paused; ncc handles renewal, and data_shaft retries the request seamlessly.
* ✨ Clean Architecture Ready: Built on top of data_shaft principles to ensure a decoupled and testable data layer.

---

## 📖 Implementation Examples

### 1. Driver Configuration
Initialize the drivers by injecting the corresponding ncc client:

```dart
import 'package:ncc_data_shaft/ncc_data_shaft.dart';

// Driver for Public APIs (Uses NccClient)
final publicClient = NccClient(id: 'public-api');
final publicDriver = HttpDataShaftDriver(client: publicClient);

// Driver for Authenticated APIs (Uses SessionClient)
final authClient = MySessionClient(id: 'secure-api'); 
final sessionDriver = SessionDataShaftDriver(client: authClient);
```

### 2. Specialized DataSources
Create data sources by extending the specific verb and context needed:

#### Public GET Request
Use DatasourceGetHttp to ensure this endpoint uses the session-less driver.
```dart
class GetProductsDataSource extends DatasourceGetHttp<ProductModel> {
  GetProductsDataSource({required super.driver});

  @override
  GetParams? generateCallRequirement({required Params params}) {
    return GetParams(baseUrl: 'https://api.example.com/products');
  }
}
```

#### Authenticated POST Request
Use DatasourcePostSession for protected endpoints. The compiler will demand a session driver, ensuring tokens are attached to the headers.
```dart
class CreateOrderDataSource extends DatasourcePostSession<OrderModel> {
  CreateOrderDataSource({required super.driver});

  @override
  PostParams generateCallRequirement({required Params params}) {
    return PostParams(
      baseUrl: 'https://api.example.com/secure/orders',
      encodeBody: () => jsonEncode({'itemId': params.id}),
    );
  }
}
```

### 3. Repository Usage
Wrap your DataSource in a data_shaft repository. The repository catches network exceptions and converts them into controlled domain errors.
```dart
final repository = SafeRepositoryDatasourceCallable(
  dataSource: GetProductsDataSource(driver: publicDriver),
);

final result = await repository(repositoryParams: const NoParams());

result.fold(
  (error) => print('Error: ${error.message}'),
  (data) => print('Success: ${data.name}'),
);
```
---

## 🏗️ Available Class Hierarchy

The package includes base classes for all standard HTTP operations, strictly tied to their security context:

| Operation | Public (HttpDataShaftDriver) | Session (SessionDataShaftDriver) |
| :--- | :--- | :--- |
| GET | DatasourceGetHttp | DatasourceGetSession |
| POST | DatasourcePostHttp | DatasourcePostSession |
| PUT | DatasourcePutHttp | DatasourcePutSession |
| PATCH | DatasourcePatchHttp | DatasourcePatchSession |
| DELETE | DatasourceDeleteHttp | DatasourceDeleteSession |

---

## Observability & Safety

* Error Handling: Automatically maps exceptions to data_shaft's structured error levels: Inadmissible, OnException, and UnControl.
* Logging: Full observability of network traffic and repository logic powered by dart:developer tags like DS.REMOTE.

Customize logging by implementing `HttpDatasourceObserver` or `RepositoryObserver`:

```dart
DatasourceObserverInstances.httpDatasourceObserver = MyCustomLogStrategy();
```
---

## 🤝 Contributing

Contributions are welcome!

- Open issues for bugs or feature requests
- Fork the repo and submit a PR
- Run `dart format` and `dart test` before submitting


# Authors & Maintainers

This project was created and is primarily maintained by:

<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Mithos5r"><img src="https://github.com/Mithos5r.png?size=100" width="100px;" alt="Cayetano Bañón Rubio"/><br /><sub><b>Cayetano Bañón Rubio</b></sub></a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/3d24rd0"><img src="https://github.com/3d24rd0.png?size=100" width="100px;" alt="Eduardo Martínez Catalá"/><br /><sub><b>Eduardo Martínez Catalá</b></sub></a></td><td align="center" valign="top" width="14.28%"><a href="https://github.com/GsusBS"><img src="https://github.com/GsusBS.png?size=100" width="100px;" alt="Jesus Bernabeu"/><br /><sub><b>Jesus Bernabeu</b></sub></a></td>
    </tr>
  </tbody>
</table>

---

## License

MIT © 2026 Coolosos