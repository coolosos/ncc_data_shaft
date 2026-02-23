import 'package:data_shaft/data_shaft.dart';
import 'package:ncc_data_shaft/src/datasources/datasource_ncc.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart';

/// {@template datasource_patch_session}
/// A session-aware remote datasource for **PATCH** operations.
///
/// This class specializes [DatasourceNccPatch] by binding it to the
/// [SessionDataShaftDriver]. It is intended for performing partial updates
/// on remote resources that require an authenticated context.
///
/// The [RemoteObject] facilitates the mapping of the partial dataset,
/// while the [SessionDataShaftDriver] ensures the request is executed
/// within the current `ncc` session.
/// {@endtemplate}
abstract base class DatasourcePatchSession<
  RemoteObject extends Codable<Object, RemoteObject>
>
    extends DatasourceNccPatch<RemoteObject, SessionDataShaftDriver> {
  /// {@macro datasource_patch_session}
  ///
  /// Requires a [SessionDataShaftDriver] to execute the authenticated
  /// partial update request.
  DatasourcePatchSession({required super.driver});
}
