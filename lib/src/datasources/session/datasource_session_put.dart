import 'package:data_shaft/data_shaft.dart';
import 'package:ncc_data_shaft/src/datasources/datasource_ncc.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart';

/// {@template datasource_put_session}
/// A session-aware remote datasource for **PUT** operations.
///
/// This class specializes [DatasourceNccPut] by binding it to the
/// [SessionDataShaftDriver]. It is intended for replacing remote resources
/// within an authenticated context.
///
/// Using this datasource ensures that `ncc` session headers and credentials
/// are correctly applied to the request, while the [RemoteObject]
/// provides the full resource representation for the update.
/// {@endtemplate}
abstract base class DatasourcePutSession<
        RemoteObject extends Codable<Object, RemoteObject>>
    extends DatasourceNccPut<RemoteObject, SessionDataShaftDriver> {
  /// {@macro datasource_put_session}
  ///
  /// Requires a [SessionDataShaftDriver] to execute the authenticated
  /// replacement request.
  DatasourcePutSession({required super.driver});
}
