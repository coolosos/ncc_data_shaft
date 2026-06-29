import 'dart:async';

import 'package:data_shaft/data_shaft.dart';
import 'package:ncc/ncc.dart';
import 'package:ncc_data_shaft/src/datasources/datasource_ncc.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart';

/// {@template datasource_get_http}
/// A standard remote datasource for **GET** operations using [HttpDataShaftDriver].
///
/// This class specializes [DatasourceNccGet] by binding it to the
/// [HttpDataShaftDriver]. It is the ideal choice for retrieving resources
/// from public APIs or endpoints that do not require an authenticated session.
///
/// The [RemoteObject] handles the deserialization of the fetched data,
/// while the [HttpDataShaftDriver] manages the standard HTTP communication.
/// {@endtemplate}
abstract base class DatasourceHttpGet<
        RemoteObject extends Codable<Object, RemoteObject>>
    extends DatasourceNccGet<RemoteObject, HttpDataShaftDriver> {
  /// {@macro datasource_get_http}
  ///
  /// Requires an [HttpDataShaftDriver] to execute the data retrieval request.
  DatasourceHttpGet({required super.driver});

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
