# ncc_data_shaft Patterns

## 1. Codable Model
Models must implement `Codable<RemoteType, SelfType>`.

### Manual Decoding
```dart
import 'package:data_shaft/data_shaft.dart';

final class UserRemote extends Codable<String, UserRemote> {
  const UserRemote({this.id = 0, this.name = ''});
  
  final int id;
  final String name;

  @override
  UserRemote decode(String remote) {
    final map = json.decode(remote);
    if (map is Map<String, dynamic>) {
      return UserRemote(
        id: map['id'] as int,
        name: map['name'] as String? ?? '',
      );
    }
    return const UserRemote();
  }

  @override
  List<Object?> get props => [id, name];

  @override
  JsonCodec? get serializer => null;
  
  @override
  bool? get stringify => true;
  
  @override
  Encoding? get encoding => null;
}
```

### JSON Serializable Decoding
```dart
import 'package:data_shaft/data_shaft.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_remote.g.dart';

@JsonSerializable(createToJson: false)
final class UserRemote extends Codable<String, UserRemote> {
  const UserRemote({this.id = 0, this.name = ''});
  
  final int id;
  final String name;

  factory UserRemote.fromJson(Map<String, dynamic> json) => _$UserRemoteFromJson(json);

  @override
  UserRemote decode(String remote) {
    final map = json.decode(remote);
    if (map is Map<String, dynamic>) {
      return UserRemote.fromJson(map);
    }
    return const UserRemote();
  }

  @override
  List<Object?> get props => [id, name];

  @override
  JsonCodec? get serializer => null;
  
  @override
  bool? get stringify => true;
  
  @override
  Encoding? get encoding => null;
}
```

## 2. Params
Parameters for DataSources and Repositories must extend `Params`.

```dart
final class UserParams extends Params {
  const UserParams({required this.id});
  final int id;

  @override
  bool get isValid => id > 0;

  @override
  List<Object?> get props => [id];
}
```

## 3. DataSources

Every DataSource must define two status code sets that control error classification:

- **`admissibleStatusCode`** (`Set<int>`) — HTTP status codes considered successful. Responses with these codes flow to `transformation()`. Default: `{200}`.
- **`inadmissibleStatusCode`** (`Set<int>`) — status codes that trigger an `InadmissibleDataSourceException`. These are controlled, business-level failures (e.g., 400, 401, 403, 404). Default: `{400, 401, 403, 404}`.
- Any status code that falls outside both sets triggers an `UnControlDataSourceException` (unexpected errors like 500 or unknown codes).

```dart
@override
Set<int> get admissibleStatusCode => {200};

@override
Set<int> get inadmissibleStatusCode => {400, 401, 403, 404};
```

### Public (HTTP)
```dart
@LazySingleton()
final class UserDataSource 
    extends DatasourceHttpGet<UserRemote> {
  UserDataSource({required super.driver});

  @override
  List<int> get admissibleStatusCode => [200];

  @override
  String get host => 'https://api.example.com/';

  @override
  String? get path => 'users/{id}';

  @override
  final Map<String, String> pathModification = {'{id}': ''};

  @override
  GetParams generateCallRequirement({required UserParams params}) {
    pathModification.update('{id}', (value) => params.id.toString());
    
    return const GetParams();
  }

  @override
  UserRemote transformation({required RequestResponse remoteResponse}) =>
      const UserRemote().decode(remoteResponse.body!());
}
```

### Authenticated (Session)
```dart
@LazySingleton()
final class UpdateUserDataSource 
    extends DatasourceSessionPatch<UserRemote> {
  UpdateUserDataSource({required super.driver});

  @override
  List<int> get admissibleStatusCode => [200];

  @override
  String get host => 'https://api.example.com/';

  @override
  String? get path => 'users/{id}';

  @override
  final Map<String, String> pathModification = {'{id}': ''};

  @override
  PatchParams generateCallRequirement({required UserParams params}) {
    pathModification.update('{id}', (value) => params.id.toString());

    return PatchParams(
      encodeBody: () => jsonEncode({'name': 'Updated Name'}),
    );
  }

  @override
  UserRemote transformation({required RequestResponse remoteResponse}) =>
      const UserRemote().decode(remoteResponse.body!());
}
```

## 4. Repositories
Repositories MUST be concrete classes extending the abstract `data_shaft` repositories.

### SafeRepositoryDatasourceCallable (Basic)
For simple passthrough repositories with automatic error mapping (DataSourceException → RepositoryError).

```dart
@LazySingleton()
final class UserRepository 
    extends SafeRepositoryDatasourceCallable<UserRemote, UserDataSource> {
  UserRepository({required super.dataSource});
}
```

### DeduplicationCacheRepository (With Caching)
For endpoints where in-memory caching with TTL is desired. Requires a `refreshDuration` and an override of the `call()` method.

```dart
@LazySingleton()
final class PostRepository
    extends DeduplicationCacheRepository<PostRemote, GetPostRemoteDataSource> {
  PostRepository({
    required super.dataSource,
  }) : super(refreshDuration: const Duration(minutes: 5));

  @override
  Future<Either<RepositoryError, PostRemote>> call({
    required PostParams repositoryParams,
  });
}
```

## 5. Global Logging
```dart
import 'dart:developer';
import 'package:ncc_data_shaft/ncc_data_shaft.dart';

class GlobalNetworkLogger implements HttpDatasourceObserver {
  @override
  void onInadmissibleResponse(InadmissibleDataSourceException exception) {
    log('❌ INADMISSIBLE: ${exception.message}', name: 'NETWORK');
  }

  @override
  void onResponseSuccess(RequestResponse response) {
    log('✅ SUCCESS [${response.statusCode}]: ${response.originalResponse.url}', name: 'NETWORK');
  }

  @override
  void onUnControlResponse(UnControlDataSourceException exception) {
    log('🚨 UNCONTROLLED: ${exception.message}', name: 'NETWORK');
  }
}
```

## 6. Dependency Injection (injectable)
```dart
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:ncc_data_shaft/ncc_data_shaft.dart';

@module
abstract class DataShaftModule {
  @LazySingleton()
  http.Client get httpClient => http.Client();

  @Named('public_client')
  @LazySingleton()
  NccClient getPublicClient(http.Client client) => 
      NccClient(client: client, id: 'public');

  @Named('session_client')
  @LazySingleton()
  SessionClient getSessionClient(http.Client client) => 
      SessionClient(client: client, id: 'session');

  @LazySingleton()
  HttpDataShaftDriver getPublicDriver(@Named('public_client') NccClient client) => 
      HttpDataShaftDriver(client: client);

  @LazySingleton()
  SessionDataShaftDriver getSessionDriver(@Named('session_client') SessionClient client) => 
      SessionDataShaftDriver(client: client);
}
```

## 7. Testing

### Mock Clients
Use these mocks to simulate all HTTP verbs and session behaviors.

```dart
import 'package:ncc_data_shaft/ncc_data_shaft.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
final class NccClientMock extends NccClient {
  NccClientMock() : super(client: http.Client(), id: 'mock');

  String responseBody = '{}';
  int responseStatus = 200;
  Uri? lastUrl;
  String? lastMethod;
  Object? lastBody;

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    lastUrl = url; lastMethod = 'GET';
    return Response(responseBody, responseStatus);
  }

  @override
  Future<Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    lastUrl = url; lastMethod = 'POST'; lastBody = body;
    return Response(responseBody, responseStatus);
  }
  
  // Implement other verbs as needed...
}
```

### DataSource Tests
Covers success, URL modification, and error handling.

```dart
import 'package:test/test.dart';
import 'package:package_name/feature/user_data_source.dart';
import 'package:package_name/feature/params/user_params.dart';

void main() {
  group('UserDataSource Tests', () {
    late NccClientMock mockClient;
    late HttpDataShaftDriver driver;
    late UserDataSource dataSource;

    setUp(() {
      mockClient = NccClientMock();
      driver = HttpDataShaftDriver(client: mockClient);
      dataSource = UserDataSource(driver: driver);
    });

    test('should return UserRemote on success (200)', () async {
      mockClient.responseBody = '{"id": 1, "name": "John"}';
      mockClient.responseStatus = 200;

      final result = await dataSource.call(params: const UserParams(id: 1));

      expect(result.id, equals(1));
      expect(mockClient.lastUrl.toString(), contains('users/1'));
    });

    test('should throw InadmissibleDataSourceException on 401/403/404', () async {
      mockClient.responseStatus = 404;
      expect(() => dataSource.call(params: const UserParams(id: 1)),
          throwsA(isA<InadmissibleDataSourceException>()));
    });

    test('should throw UnControlDataSourceException on network error', () async {
      // Forcing a network error by making a verb throw or using a specialized mock
    });
  });
}
```

### Repository Tests
Covers mapping from DataSource result to Repository result.

```dart
import 'package:test/test.dart';
import 'package:package_name/feature/user_repository.dart';
import 'package:package_name/feature/params/user_params.dart';

void main() {
  group('UserRepository Tests', () {
    late NccClientMock mockClient;
    late UserDataSource dataSource;
    late UserRepository repository;

    setUp(() {
      mockClient = NccClientMock();
      dataSource = UserDataSource(driver: HttpDataShaftDriver(client: mockClient));
      repository = UserRepository(dataSource: dataSource);
    });

    test('should return Right(UserRemote) on success', () async {
      mockClient.responseBody = '{"id": 1, "name": "John"}';
      final result = await repository.call(repositoryParams: const UserParams(id: 1));
      expect(result.isRight(), isTrue);
    });

    test('should return Left(InadmissibleRepositoryError) on DataSource error', () async {
      mockClient.responseStatus = 404;
      final result = await repository.call(repositoryParams: const UserParams(id: 1));
      expect(result.isLeft(), isTrue);
      result.fold((l) => expect(l, isA<InadmissibleRepositoryError>()), (r) => null);
    });
  });
}
```

### Session Driver Tests
Use `SessionClientMock` to verify session-aware behavior. The mock tracks `tokenCalls` and `renewCalls` to assert session lifecycle.

```dart
import 'package:test/test.dart';
import 'package:ncc/ncc.dart' as http;
import 'package:ncc_data_shaft/ncc_data_shaft.dart';

void main() {
  group('SessionDataShaftDriver Tests', () {
    late SessionClientMock sessionMock;
    late SessionDataShaftDriver driver;
    final testUri = Uri.parse('https://api.example.com/secure');

    setUp(() {
      sessionMock = SessionClientMock(client: http.Client());
      driver = SessionDataShaftDriver(client: sessionMock);
    });

    test('should inject bearer token on each request', () async {
      sessionMock.mockToken = 'my-token';
      await driver.get(testUri);
      expect(sessionMock.tokenCalls, greaterThan(0));
    });

    test('should attempt renewSession on 401 responses', () async {
      sessionMock.responseStatus = 401;
      // The driver delegates to ncc; SessionClient handles renew internally.
      // Verify renewCalls increased after the request.
      await driver.get(testUri);
      // ncc calls renewSession() when a 401 is received.
      expect(sessionMock.renewCalls, greaterThan(0));
    });

    test('should propagate network exceptions', () async {
      final throwingDriver = SessionDataShaftDriver(
        client: ExceptionThrowingClient(client: http.Client()),
      );
      expect(
        () => throwingDriver.get(testUri),
        throwsA(isA<NetworkThrowException>()),
      );
    });
  });
}
```

### Session DataSource Tests
Verify that session datasources work correctly with `SessionDataShaftDriver`.

```dart
import 'package:test/test.dart';
import 'package:ncc/ncc.dart' as http;
import 'package:ncc_data_shaft/ncc_data_shaft.dart';

void main() {
  group('Session DataSource Tests', () {
    late SessionClientMock sessionMock;
    late SessionDataShaftDriver sessionDriver;

    setUp(() {
      sessionMock = SessionClientMock(client: http.Client());
      sessionDriver = SessionDataShaftDriver(client: sessionMock);
    });

    test('DatasourceSessionGet should use session driver', () async {
      sessionMock.responseBody = '{"message": "test-object"}';
      final dataSource = TestSessionGetDataSource(driver: sessionDriver);

      final result = await dataSource.call(params: const NoParams());

      expect(result.message, equals('test-object'));
      expect(sessionMock.lastMethod, equals('GET'));
    });
  });
}
```

## 8. Error Handling & Hierarchies

The package defines a clear error hierarchy inherited from `cool_bedrock`:

```
Issue (sealed)
├── Failure (abstract)
├── RepositoryError (abstract)         ← returned as Left in Either
│   ├── InadmissibleRepositoryError    ← InadmissibleDataSourceException
│   ├── OnExceptionRepositoryError     ← cualquier otra Exception
│   └── UnControlRepositoryError       ← UnControlDataSourceException
└── DataSourceException (abstract)     ← thrown, implements Exception
    ├── InadmissibleDataSourceException  (body, statusCode)
    └── UnControlDataSourceException     (body?, statusCode?, reasonPhrase?)
```

### Mapping Rules (automatic in SafeRepositoryDatasourceCallable)

| DataSource Exception | Maps to RepositoryError |
|---|---|
| `InadmissibleDataSourceException` (e.g., 401, 403, 404) | `InadmissibleRepositoryError` |
| `UnControlDataSourceException` (e.g., 500, timeout) | `UnControlRepositoryError` |
| Any other `Exception` | `OnExceptionRepositoryError` |

### Customizing Error Mappers
Override mappers in your repository to customize error messages:

```dart
final class UserRepository
    extends SafeRepositoryDatasourceCallable<UserRemote, UserDataSource> {
  UserRepository({required super.dataSource});

  @override
  InadmissibleRepositoryError onInadmissibleException(
    covariant InadmissibleDataSourceException error,
  ) =>
      InadmissibleRepositoryError(message: 'Custom: ${error.message}');
}
```

## 9. SessionClient Configuration

`SessionClient` from `ncc` manages authentication state. Subclass it to provide your token logic.

### Required Overrides

```dart
final class MySessionClient extends SessionClient {
  MySessionClient({required super.client, required super.id});

  @override
  Future<String?> getBearerToken() async {
    // Return the current access token (e.g., from secure storage)
    return await storage.read(key: 'access_token');
  }

  @override
  Future<bool> renewSession() async {
    // Attempt to refresh the token (e.g., using a refresh token)
    try {
      final newToken = await api.refreshToken();
      await storage.write(key: 'access_token', value: newToken);
      return true;
    } catch (_) {
      return false;
    }
  }
}
```

### Lifecycle

1. `getBearerToken()` is called before every request to attach the token.
2. If the server responds with **401**, `ncc` automatically calls `renewSession()`.
3. If `renewSession()` returns `true`, the original request is retried with the new token.
4. If `renewSession()` returns `false`, the request fails with the original 401 error.

### Session Mock for Tests

Use `SessionClientMock` (provided in the test mocks) to simulate tokens and renewals:

```dart
final sessionMock = SessionClientMock(client: http.Client());
sessionMock.mockToken = 'test-token';
sessionMock.mockRenewResult = true;
// After requests, inspect:
expect(sessionMock.tokenCalls, equals(1));   // getBearerToken() called
expect(sessionMock.renewCalls, equals(0));   // renewSession() not called
```
