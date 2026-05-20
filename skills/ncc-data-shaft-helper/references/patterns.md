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

### Public (HTTP)
```dart
@LazySingleton()
final class UserDataSource 
    extends DatasourceGetHttp<UserRemote> {
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
    extends DatasourcePatchSession<UserRemote> {
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

```dart
@LazySingleton()
final class UserRepository 
    extends SafeRepositoryDatasourceCallable<UserRemote, UserDataSource> {
  UserRepository({required super.dataSource});
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
