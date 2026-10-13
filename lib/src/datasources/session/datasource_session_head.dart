import 'package:data_shaft/data_shaft.dart';
import 'package:ncc_data_shaft/src/datasources/datasource_ncc.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart';

/// {@template datasource_head_session}
/// A session-aware remote datasource for **HEAD** operations.
///
/// This class specializes [DatasourceNccHead] by specifically binding it to
/// [SessionDataShaftDriver]. It is designed for checking the availability or
/// metadata of protected or user-specific resources, ensuring that the
/// underlying `ncc` session headers are automatically applied.
///
/// Use this when the [RemoteObject] being inspected requires an authenticated
/// state to be visible or accessible.
/// {@endtemplate}
abstract base class DatasourceSessionHead<
  RemoteObject extends Codable<Object, RemoteObject>
>
    extends DatasourceNccHead<RemoteObject, SessionDataShaftDriver> {
  /// {@macro datasource_head_session}
  ///
  /// Requires a [SessionDataShaftDriver] to execute the authenticated
  /// metadata request.
  new({required super.driver});
}
