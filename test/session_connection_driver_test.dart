import 'package:ncc/ncc.dart' as http;
import 'package:ncc_data_shaft/ncc_data_shaft.dart';
import 'package:test/test.dart';

import 'mocks/ncc_client_mock.dart';

void main() {
  group('SessionDataShaftDriver Tests', () {
    late SessionClientMock sessionMock;
    late SessionDataShaftDriver driver;
    final testUri = Uri.parse('https://api.cool.com/secure');

    setUp(() {
      sessionMock = SessionClientMock(client: http.Client());
      driver = SessionDataShaftDriver(client: sessionMock);
    });

    test('should allow ncc to manage bearer token retrieval', () async {
      await driver.get(testUri);

      expect(sessionMock.lastMethod, equals('GET'));
    });

    test(
      'should propagate exceptions without catching them internally',
      () async {
        final exceptionDriver = SessionDataShaftDriver(
          client: ExceptionThrowingClient(client: http.Client()),
        );

        expect(
          () => exceptionDriver.get(testUri),
          throwsA(isA<NetworkException>()),
        );
      },
    );

    test('should execute GET request correctly', () async {
      final response = await driver.get(testUri, headers: {'auth': 'token'});

      expect(sessionMock.lastMethod, equals('GET'));
      expect(sessionMock.lastUrl, equals(testUri));
      expect(sessionMock.lastHeaders?['auth'], equals('token'));
      expect(response.statusCode, equals(200));
    });

    test('should execute POST request with body correctly', () async {
      final body = {'name': 'Gemini'};
      await driver.post(testUri, body: body);

      expect(sessionMock.lastMethod, equals('POST'));
      expect(sessionMock.lastBody, equals(body));
    });

    test('should execute PUT request correctly', () async {
      await driver.put(testUri, body: 'plain text');

      expect(sessionMock.lastMethod, equals('PUT'));
      expect(sessionMock.lastBody, equals('plain text'));
    });

    test('should execute PATCH request correctly', () async {
      await driver.patch(testUri, body: {'status': 'updated'});

      expect(sessionMock.lastMethod, equals('PATCH'));
      expect(sessionMock.lastBody, equals({'status': 'updated'}));
    });

    test('should execute DELETE request correctly', () async {
      await driver.delete(testUri);

      expect(sessionMock.lastMethod, equals('DELETE'));
    });

    test('should execute HEAD request correctly', () async {
      await driver.head(testUri);

      expect(sessionMock.lastMethod, equals('HEAD'));
    });

    test(
      'should return correct RequestResponse mapping for error status codes',
      () async {
        sessionMock
          ..responseStatus = 404
          ..responseBody = 'Not Found';

        final response = await driver.get(testUri);

        expect(response.statusCode, equals(404));
        expect(response.body, equals('Not Found'));
      },
    );
  });
}
