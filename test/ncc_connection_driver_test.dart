import 'package:ncc/ncc.dart' as http;
import 'package:ncc_data_shaft/driver.dart';
import 'package:test/test.dart';

import 'mocks/ncc_client_mock.dart';

void main() {
  group('NccConnectionDriver Tests', () {
    late NccClientMock nccClientMock;
    late HttpDataShaftDriver driver;
    final testUri = Uri.parse('https://api.cool.com/resource');

    setUp(() {
      nccClientMock = NccClientMock(client: http.Client());
      driver = HttpDataShaftDriver(client: nccClientMock);
    });

    test('should execute GET request correctly', () async {
      final response = await driver.get(testUri, headers: {'auth': 'token'});

      expect(nccClientMock.lastMethod, equals('GET'));
      expect(nccClientMock.lastUrl, equals(testUri));
      expect(nccClientMock.lastHeaders?['auth'], equals('token'));
      expect(response.statusCode, equals(200));
    });

    test('should execute POST request with body correctly', () async {
      final body = {'name': 'Gemini'};
      await driver.post(testUri, body: body);

      expect(nccClientMock.lastMethod, equals('POST'));
      expect(nccClientMock.lastBody, equals(body));
    });

    test('should execute PUT request correctly', () async {
      await driver.put(testUri, body: 'plain text');

      expect(nccClientMock.lastMethod, equals('PUT'));
      expect(nccClientMock.lastBody, equals('plain text'));
    });

    test('should execute PATCH request correctly', () async {
      await driver.patch(testUri, body: {'status': 'updated'});

      expect(nccClientMock.lastMethod, equals('PATCH'));
      expect(nccClientMock.lastBody, equals({'status': 'updated'}));
    });

    test('should execute DELETE request correctly', () async {
      await driver.delete(testUri);

      expect(nccClientMock.lastMethod, equals('DELETE'));
    });

    test('should execute HEAD request correctly', () async {
      await driver.head(testUri);

      expect(nccClientMock.lastMethod, equals('HEAD'));
    });

    test('should return RequestResponse with correct mapping', () async {
      nccClientMock
        ..responseStatus = 201
        ..responseBody = '{"id": 1}';

      final response = await driver.get(testUri);

      expect(response.statusCode, equals(201));
      expect(response.body!(), equals('{"id": 1}'));
    });
  });
}
