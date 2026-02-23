import 'package:data_shaft/data_shaft.dart';
import 'package:ncc_data_shaft/src/datasources/datasource_ncc.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart';

/// {@template datasource_patch_http}
/// A standard remote datasource for **PATCH** operations using [HttpDataShaftDriver].
///
/// This class specializes [DatasourceNccPatch] by binding it to the
/// [HttpDataShaftDriver]. It is intended for performing partial updates on
/// resources via public endpoints or APIs where a persistent session is
/// not required.
///
/// The [RemoteObject] facilitates the mapping of the partial dataset, while
/// the [HttpDataShaftDriver] manages the underlying network request without
/// session overhead.
/// {@endtemplate}
abstract base class DatasourcePatchHttp<
        RemoteObject extends Codable<Object, RemoteObject>>
    extends DatasourceNccPatch<RemoteObject, HttpDataShaftDriver> {
  /// {@macro datasource_patch_http}
  ///
  /// Requires an [HttpDataShaftDriver] to execute the partial update request.
  DatasourcePatchHttp({required super.driver});
}
