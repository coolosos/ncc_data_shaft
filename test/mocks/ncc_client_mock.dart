import 'dart:convert';

import 'package:ncc/ncc.dart';

// ignore: must_be_immutable MOCK
final class NccClientMock extends NccClient {
  NccClientMock({required super.client}) : super(id: 'mock-client');

  Uri? lastUrl;
  String? lastMethod;
  Map<String, String>? lastHeaders;
  Object? lastBody;

  int responseStatus = 200;
  String responseBody = '{"message": "success"}';

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    lastUrl = url;
    lastMethod = 'GET';
    lastHeaders = headers;
    return Response(responseBody, responseStatus);
  }

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    lastUrl = url;
    lastMethod = 'POST';
    lastHeaders = headers;
    lastBody = body;
    return Response(responseBody, responseStatus);
  }

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    lastUrl = url;
    lastMethod = 'PATCH';
    lastHeaders = headers;
    lastBody = body;
    return Response(responseBody, responseStatus);
  }

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    lastUrl = url;
    lastMethod = 'DELETE';
    lastHeaders = headers;
    lastBody = body;
    return Response(responseBody, responseStatus);
  }

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) async {
    lastUrl = url;
    lastMethod = 'HEAD';
    lastHeaders = headers;
    return Response(responseBody, responseStatus);
  }

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    lastUrl = url;
    lastMethod = 'PUT';
    lastHeaders = headers;
    lastBody = body;
    return Response(responseBody, responseStatus);
  }
}

// ignore: must_be_immutable MOCK
base class SessionClientMock extends SessionClient {
  SessionClientMock({required super.client}) : super(id: 'mock-client');

  Uri? lastUrl;
  String? lastMethod;
  Map<String, String>? lastHeaders;
  Object? lastBody;

  // Configuration
  int responseStatus = 200;
  String responseBody = '{"status": "success"}';
  String? mockToken = 'valid_token';
  bool mockRenewResult = true;

  // Counters to verify session logic
  int tokenCalls = 0;
  int renewCalls = 0;

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    lastUrl = url;
    lastMethod = 'GET';
    lastHeaders = headers;
    return Response(responseBody, responseStatus);
  }

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    lastUrl = url;
    lastMethod = 'POST';
    lastHeaders = headers;
    lastBody = body;
    return Response(responseBody, responseStatus);
  }

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    lastUrl = url;
    lastMethod = 'PUT';
    lastHeaders = headers;
    lastBody = body;
    return Response(responseBody, responseStatus);
  }

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    lastUrl = url;
    lastMethod = 'PATCH';
    lastHeaders = headers;
    lastBody = body;
    return Response(responseBody, responseStatus);
  }

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    lastUrl = url;
    lastMethod = 'DELETE';
    lastHeaders = headers;
    lastBody = body;
    return Response(responseBody, responseStatus);
  }

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) async {
    lastUrl = url;
    lastMethod = 'HEAD';
    lastHeaders = headers;
    return Response(responseBody, responseStatus);
  }

  @override
  Future<String?> getBearerToken() async {
    tokenCalls++;
    return mockToken;
  }

  @override
  Future<bool> renewSession() async {
    renewCalls++;
    return mockRenewResult;
  }
}

class NetworkThrowException implements Exception {}

// ignore: must_be_immutable MOCK
final class ExceptionThrowingClient extends SessionClientMock {
  ExceptionThrowingClient({required super.client});

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    throw NetworkThrowException();
  }
}
