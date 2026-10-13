import 'dart:async';

import 'package:data_shaft/data_shaft.dart';
import 'package:ncc/ncc.dart' show Response;
import 'package:ncc_data_shaft/src/datasources/datasource_ncc.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart';

/// {@template datasource_head_http}
/// A standard remote datasource for **HEAD** operations using [HttpDataShaftDriver].
///
/// This class specializes [DatasourceNccHead] by binding it to the
/// [HttpDataShaftDriver]. It is the ideal choice for checking resource
/// availability or reading headers from public APIs or endpoints that do not
/// require an authenticated session.
///
/// The [RemoteObject] handles the mapping of the response, while the
/// [HttpDataShaftDriver] manages the standard HTTP communication.
/// {@endtemplate}
abstract base class DatasourceHttpHead<
  RemoteObject extends Codable<Object, RemoteObject>
>
    extends DatasourceNccHead<RemoteObject, HttpDataShaftDriver> {
  /// {@macro datasource_head_http}
  ///
  /// Requires an [HttpDataShaftDriver] to execute the metadata request.
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
