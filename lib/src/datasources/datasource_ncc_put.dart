import 'package:data_shaft/data_shaft.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart'
    show NccConnectionDriver;

/// {@template datasource_ncc_put}
/// A specialized remote datasource for **PUT** operations using an [NccConnectionDriver].
///
/// This class provides the foundational structure for replacing or updating
/// entire resources on a remote server. It integrates the `ncc` transport
/// layer with the `data_shaft` remote data flow.
///
/// [RemoteObject] handles the full serialization of the resource to be
/// updated, while [NccDriver] manages the HTTP PUT execution.
/// {@endtemplate}
abstract base class DatasourceNccPut<
        RemoteObject extends Codable<Object, RemoteObject>,
        NccDriver extends NccConnectionDriver>
    extends DatasourcePutRemote<RemoteObject, NccDriver> {
  /// {@macro datasource_ncc_put}
  ///
  /// Requires an [NccDriver] instance to execute the resource replacement request.
  DatasourceNccPut({required super.driver});
}
