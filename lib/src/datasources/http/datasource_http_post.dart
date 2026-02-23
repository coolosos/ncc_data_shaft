import 'package:data_shaft/data_shaft.dart';
import 'package:ncc_data_shaft/src/datasources/datasource_ncc.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart';

/// {@template datasource_post_http}
/// A standard remote datasource for **POST** operations using [HttpDataShaftDriver].
///
/// This class specializes [DatasourceNccPost] by strictly requiring an
/// [HttpDataShaftDriver]. It serves as the base for creating new resources
/// on public APIs or endpoints that do not rely on `ncc` session management.
///
/// The [RemoteObject] handles the serialization of the payload and the
/// mapping of the server response, while the [HttpDataShaftDriver]
/// provides the standard HTTP transport.
/// {@endtemplate}
abstract base class DatasourcePostHttp<
  RemoteObject extends Codable<Object, RemoteObject>
>
    extends DatasourceNccPost<RemoteObject, HttpDataShaftDriver> {
  /// {@macro datasource_post_http}
  ///
  /// Requires an [HttpDataShaftDriver] instance to perform the resource creation.
  DatasourcePostHttp({required super.driver});
}
