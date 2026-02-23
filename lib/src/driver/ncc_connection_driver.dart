import 'package:data_shaft/data_shaft.dart';
import 'package:meta/meta.dart';
import 'package:ncc/ncc.dart';

part 'http_data_shaft_driver.dart';
part 'session_data_shaft_driver.dart';

enum RequestType { get, delete, post, put, patch, head }

/// {@template ncc_data_shaft.ncc_connection_driver}
/// A [RemoteDriver] implementation powered by the `ncc` [BaseClient].
///
/// This class acts as a bridge between `data_shaft`'s data abstraction layer
/// and `ncc`'s connection management capabilities.
///
/// It allows `data_shaft` repositories to perform HTTP requests using
/// the configurations, interceptors, and session logic defined in `ncc`.
/// {@endtemplate}
base class NccConnectionDriver<CustomClient extends BaseClient>
    implements RemoteDriver {
  /// {@macro ncc_data_shaft.ncc_connection_driver}
  const NccConnectionDriver({required this.client});

  /// The underlying `ncc` client responsible for executing the network calls.
  final CustomClient client;

  /// Manages the request execution on the [client] based on the [RequestType].
  ///
  /// This method is marked as [@protected] and can be overridden if custom
  /// logic is required before the client execution.
  @protected
  Future<Response> driverRequestManagement(
    Uri url, {
    required RequestType type,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) {
    // Note: The 'options' parameter from data_shaft is currently
    // preserved for future compatibility if ncc's BaseClient adds
    // extra configuration support.
    return switch (type) {
      RequestType.get => client.get(url, headers: headers),
      RequestType.delete => client.delete(
          url,
          headers: headers,
          body: body,
          encoding: encoding,
        ),
      RequestType.post => client.post(
          url,
          headers: headers,
          body: body,
          encoding: encoding,
        ),
      RequestType.put => client.put(
          url,
          headers: headers,
          body: body,
          encoding: encoding,
        ),
      RequestType.patch => client.patch(
          url,
          headers: headers,
          body: body,
          encoding: encoding,
        ),
      RequestType.head => client.head(url, headers: headers),
    };
  }

  /// Converts an `ncc` [Response] into a `data_shaft` [RequestResponse].
  @protected
  RequestResponse obtainResponse({required Response response}) {
    return RequestResponse(
      statusCode: response.statusCode,
      body: response.body,
      headers: response.headers,
      originalResponse: response,
    );
  }

  /// Internal orchestrator for request execution and response transformation.
  Future<RequestResponse> _executeRequest(
    Uri url, {
    required RequestType type,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) async {
    final response = await driverRequestManagement(
      url,
      type: type,
      headers: headers,
      body: body,
      encoding: encoding,
      options: options,
    );

    return obtainResponse(response: response);
  }

  // --- RemoteDriver Implementation ---

  @override
  Future<RequestResponse> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) {
    return _executeRequest(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
      options: options,
      type: RequestType.delete,
    );
  }

  @override
  Future<RequestResponse> get(
    Uri url, {
    Map<String, String>? headers,
    Object? options,
  }) {
    return _executeRequest(
      url,
      headers: headers,
      options: options,
      type: RequestType.get,
    );
  }

  @override
  Future<RequestResponse> head(
    Uri url, {
    Map<String, String>? headers,
    Object? options,
  }) {
    return _executeRequest(
      url,
      headers: headers,
      options: options,
      type: RequestType.head,
    );
  }

  @override
  Future<RequestResponse> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) {
    return _executeRequest(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
      options: options,
      type: RequestType.patch,
    );
  }

  @override
  Future<RequestResponse> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) {
    return _executeRequest(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
      options: options,
      type: RequestType.post,
    );
  }

  @override
  Future<RequestResponse> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) {
    return _executeRequest(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
      options: options,
      type: RequestType.put,
    );
  }
}
