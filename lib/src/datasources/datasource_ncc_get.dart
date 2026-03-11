import 'dart:async';

import 'package:ncc_data_shaft/ncc_data_shaft.dart';

/// {@template datasource_ncc_get}
/// A specialized remote datasource for **GET** operations using an [NccConnectionDriver].
///
/// This class provides the foundational structure for fetching resources from
/// a remote API. It integrates the robust networking of `ncc` with the
/// standardized data fetching flow of `data_shaft`.
///
/// [RemoteObject] handles the deserialization of the incoming data, while
/// the [NccDriver] manages the underlying HTTP GET request.
/// {@endtemplate}
abstract base class DatasourceNccGet<
        RemoteObject extends Codable<Object, RemoteObject>,
        NccDriver extends NccConnectionDriver>
    extends DatasourceGetRemote<RemoteObject, NccDriver> {
  /// {@macro datasource_ncc_get}
  ///
  /// Requires an [NccDriver] to execute the retrieval request.
  DatasourceNccGet({required super.driver});

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
