import 'package:data_shaft/data_shaft.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart'
    show NccConnectionDriver;

/// {@template datasource_ncc_post}
/// A specialized remote datasource for **POST** operations using an [NccConnectionDriver].
///
/// This class provides the base implementation for creating new resources
/// on a remote server. It combines `data_shaft`'s standardized creation flow
/// with the networking features provided by the `ncc` client.
///
/// [RemoteObject] handles the serialization of the new resource and
/// deserialization of the server response, while [NccDriver] manages
/// the network execution.
/// {@endtemplate}
abstract base class DatasourceNccPost<
        RemoteObject extends Codable<Object, RemoteObject>,
        NccDriver extends NccConnectionDriver>
    extends DatasourcePostRemote<RemoteObject, NccDriver> {
  /// {@macro datasource_ncc_post}
  ///
  /// Requires an [NccDriver] to execute the resource creation request.
  DatasourceNccPost({required super.driver});
}
