import 'package:data_shaft/data_shaft.dart';
import 'package:ncc_data_shaft/src/datasources/datasource_ncc.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart';

/// {@template datasource_delete_http}
/// A standard remote datasource for **DELETE** operations using [HttpDataShaftDriver].
///
/// This class specializes [DatasourceNccDelete] for scenarios that do not
/// require an active `ncc` session. It is typically used for public endpoints
/// or APIs where authentication is handled manually per request rather than
/// through a global session client.
///
/// The [RemoteObject] defines the resource being deleted, and the
/// [HttpDataShaftDriver] provides the standard HTTP transport layer.
/// {@endtemplate}
abstract base class DatasourceDeleteHttp<
        RemoteObject extends Codable<Object, RemoteObject>>
    extends DatasourceNccDelete<RemoteObject, HttpDataShaftDriver> {
  /// {@macro datasource_delete_http}
  ///
  /// Requires an [HttpDataShaftDriver] instance to perform the network operation.
  DatasourceDeleteHttp({required super.driver});
}
