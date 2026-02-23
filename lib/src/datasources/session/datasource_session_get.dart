import 'package:data_shaft/data_shaft.dart';
import 'package:ncc_data_shaft/src/datasources/datasource_ncc.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart';

/// {@template datasource_get_session}
/// A session-aware remote datasource for **GET** operations.
///
/// This class specializes [DatasourceNccGet] by specifically binding it to
/// [SessionDataShaftDriver]. It is designed for retrieving resources that
/// are protected or user-specific, ensuring that the underlying `ncc`
/// session headers are automatically applied.
///
/// Use this when the [RemoteObject] being fetched requires an authenticated
/// state to be visible or accessible.
/// {@endtemplate}
abstract base class DatasourceGetSession<
        RemoteObject extends Codable<Object, RemoteObject>>
    extends DatasourceNccGet<RemoteObject, SessionDataShaftDriver> {
  /// {@macro datasource_get_session}
  ///
  /// Requires a [SessionDataShaftDriver] to execute the authenticated
  /// retrieval request.
  DatasourceGetSession({required super.driver});
}
