import 'dart:async';

import 'package:ncc_data_shaft/ncc_data_shaft.dart';

/// {@template datasource_ncc_delete}
/// A specialized remote datasource for **DELETE** operations using an [NccConnectionDriver].
///
/// This class serves as a base for any datasource that needs to remove resources
/// from a remote API. It leverages the `ncc` client's connection logic while
/// adhering to the `data_shaft` contract for remote deletions.
///
/// [RemoteObject] must implement [Codable] to handle data mapping, and [NccDriver]
/// ensures compatibility with `ncc`'s transport layer.
/// {@endtemplate}
abstract base class DatasourceNccDelete<
        RemoteObject extends Codable<Object, RemoteObject>,
        NccDriver extends NccConnectionDriver>
    extends DatasourceDeleteRemote<RemoteObject, NccDriver> {
  /// {@macro datasource_ncc_delete}
  ///
  /// Requires an [NccDriver] instance (e.g., `HttpDataShaftDriver` or
  /// `SessionDataShaftDriver`) to perform the network operation.
  DatasourceNccDelete({required super.driver});

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
