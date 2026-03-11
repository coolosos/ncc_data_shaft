import 'dart:async';

import 'package:ncc_data_shaft/ncc_data_shaft.dart';

/// {@template datasource_ncc_put}
/// A specialized remote datasource for **PUT** operations using an [NccConnectionDriver].
///
/// This class provides the foundational structure for replacing or updating
/// entire resources on a remote server. It integrates the `ncc` transport
/// layer with the `data_shaft` remote data flow.
///
/// [RemoteObject] handles the full serialization of the resource to be
/// updated, while [NccDriver] manages the HTTP PUT execution.
/// {@endtemplate}
abstract base class DatasourceNccPut<
        RemoteObject extends Codable<Object, RemoteObject>,
        NccDriver extends NccConnectionDriver>
    extends DatasourcePutRemote<RemoteObject, NccDriver> {
  /// {@macro datasource_ncc_put}
  ///
  /// Requires an [NccDriver] instance to execute the resource replacement request.
  DatasourceNccPut({required super.driver});

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
