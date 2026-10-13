import 'dart:async';

import 'package:ncc_data_shaft/ncc_data_shaft.dart';

/// {@template datasource_ncc_head}
/// A specialized remote datasource for **HEAD** operations using an [NccConnectionDriver].
///
/// This class provides the foundational structure for retrieving response
/// metadata (e.g. headers) without transferring the body. It integrates the
/// robust networking of `ncc` with the standardized request flow of `data_shaft`.
///
/// [RemoteObject] handles the mapping of the incoming data, while the
/// [NccDriver] manages the underlying HTTP HEAD request.
/// {@endtemplate}
abstract base class DatasourceNccHead<
  RemoteObject extends Codable<Object, RemoteObject>,
  NccDriver extends NccConnectionDriver
>
    extends DatasourceHeadRemote<RemoteObject, NccDriver> {
  /// {@macro datasource_ncc_head}
  ///
  /// Requires an [NccDriver] to execute the metadata request.
  new({required super.driver});

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
  });
}
