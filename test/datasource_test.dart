import 'package:data_shaft/data_shaft.dart';
import 'package:ncc/ncc.dart' as http;
import 'package:ncc_data_shaft/driver.dart';
import 'package:test/test.dart';

import 'mocks/datasource/implementation_datasource.dart';

import 'mocks/ncc_client_mock.dart';

void main() {
  group('NccConnectionDriver Tests', () {
    late NccClientMock nccClient;
    late HttpDataShaftDriver driver;

    setUp(() {
      nccClient = NccClientMock(client: http.Client());
      driver = HttpDataShaftDriver(client: nccClient);
    });

    test(
      'DatasourceGetHttp should use driver to fetch and decode data',
      () async {
        nccClient.responseBody = '{"message": "hello"}';
        final dataSource = TestHttpGetDataSource(driver: driver);

        final result = await dataSource.call(params: const NoParams());

        expect(result.message, equals('hello'));
      },
    );
  });

  group('SessionConnectionDriver Tests', () {
    late SessionClientMock nccClientMock;

    setUp(() {
      nccClientMock = SessionClientMock(client: http.Client());
    });

    test(
      'DatasourceGetHttp should use driver to fetch and decode data',
      () async {
        nccClientMock.responseBody = '{"message": "test-object"}';

        final driver = HttpDataShaftDriver(client: nccClientMock);
        final dataSource = TestHttpGetDataSource(driver: driver);

        final result = await dataSource.call(params: const NoParams());

        expect(result.message, equals('test-object'));
        expect(nccClientMock.lastMethod, equals('GET'));
      },
    );
  });

  group('Review all datasource Tests', () {
    late SessionClientMock sessionClientMock;
    late SessionDataShaftDriver sessionDriver;

    late NccClientMock nccClient;
    late HttpDataShaftDriver httpDriver;

    setUp(() {
      sessionClientMock = SessionClientMock(client: http.Client());
      sessionDriver = SessionDataShaftDriver(client: sessionClientMock);

      nccClient = NccClientMock(client: http.Client());
      httpDriver = HttpDataShaftDriver(client: nccClient);
    });

    test('Datasource should use driver to fetch and decode data', () async {
      sessionClientMock.responseBody = '{"message": "test-object"}';
      nccClient.responseBody = '{"message": "test-object"}';
      for (final datasource in getAllSession(driver: sessionDriver)) {
        final result = await datasource.call(params: const NoParams());

        final param = datasource.generateCallRequirement(params: noParams);

        expect(result.message, equals('test-object'));
        switch (param) {
          case DeleteParams():
            expect(sessionClientMock.lastMethod, equals('DELETE'));
            break;
          case GetParams():
            expect(sessionClientMock.lastMethod, equals('GET'));
            break;
          case PatchParams():
            expect(sessionClientMock.lastMethod, equals('PATCH'));
            break;
          case PostParams():
            expect(sessionClientMock.lastMethod, equals('POST'));
            break;
          case PutParams():
            expect(sessionClientMock.lastMethod, equals('PUT'));
            break;
        }
      }

      for (final datasource in getAllHttp(driver: httpDriver)) {
        final result = await datasource.call(params: const NoParams());

        final param = datasource.generateCallRequirement(params: noParams);

        expect(result.message, equals('test-object'));
        switch (param) {
          case DeleteParams():
            expect(nccClient.lastMethod, equals('DELETE'));
            break;
          case GetParams():
            expect(nccClient.lastMethod, equals('GET'));
            break;
          case PatchParams():
            expect(nccClient.lastMethod, equals('PATCH'));
            break;
          case PostParams():
            expect(nccClient.lastMethod, equals('POST'));
            break;
          case PutParams():
            expect(nccClient.lastMethod, equals('PUT'));
            break;
        }
      }
    });
  });
}
