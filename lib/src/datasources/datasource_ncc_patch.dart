import 'dart:async';

import 'package:ncc_data_shaft/ncc_data_shaft.dart';

/// {@template datasource_ncc_patch}
/// A specialized remote datasource for **PATCH** operations using an [NccConnectionDriver].
///
/// This class serves as a base for datasources designed to perform partial
/// updates on remote resources. It bridges `data_shaft`'s patching logic
/// with `ncc`'s request handling.
///
/// [RemoteObject] must implement [Codable] to facilitate the mapping of
/// partial data, while [NccDriver] provides the network execution context.
/// {@endtemplate}
abstract base class DatasourceNccPatch<
        RemoteObject extends Codable<Object, RemoteObject>,
        NccDriver extends NccConnectionDriver>
    extends DatasourcePatchRemote<RemoteObject, NccDriver> {
  /// {@macro datasource_ncc_patch}
  ///
  /// Requires an [NccDriver] instance to execute the partial update request.
  DatasourceNccPatch({required super.driver});

  @override
  FutureOr<RemoteObject> transformation({
    required RequestResponse<Response> remoteResponse,
  });

  @override
  FutureOr<RemoteObject> checkInformation({
    required RequestResponse<Response> requestResponse,
    required Map<String, String>? requestHeaders,
    required Uri? requestUri,
    Object? requestBody,
  }) {
    return super.checkInformation(
      requestResponse: requestResponse,
      requestHeaders: requestHeaders,
      requestUri: requestUri,
      requestBody: requestBody,
    );
  }
}
