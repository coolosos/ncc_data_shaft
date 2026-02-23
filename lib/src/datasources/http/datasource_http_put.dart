import 'package:data_shaft/data_shaft.dart';
import 'package:ncc_data_shaft/src/datasources/datasource_ncc.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart';

/// {@template datasource_put_http}
/// A standard remote datasource for **PUT** operations using [HttpDataShaftDriver].
///
/// This class specializes [DatasourceNccPut] by binding it to the
/// [HttpDataShaftDriver]. It is intended for replacing entire resources on
/// remote servers via public endpoints or APIs that do not require
/// active session management.
///
/// The [RemoteObject] handles the full serialization of the resource,
/// while the [HttpDataShaftDriver] manages the HTTP PUT execution.
/// {@endtemplate}
abstract base class DatasourcePutHttp<
        RemoteObject extends Codable<Object, RemoteObject>>
    extends DatasourceNccPut<RemoteObject, HttpDataShaftDriver> {
  /// {@macro datasource_put_http}
  ///
  /// Requires an [HttpDataShaftDriver] instance to perform the resource
  /// replacement request.
  DatasourcePutHttp({required super.driver});
}
