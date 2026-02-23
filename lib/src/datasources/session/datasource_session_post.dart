import 'package:data_shaft/data_shaft.dart';
import 'package:ncc_data_shaft/src/datasources/datasource_ncc.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart';

/// {@template datasource_post_session}
/// A session-aware remote datasource for **POST** operations.
///
/// This class specializes [DatasourceNccPost] by strictly requiring a
/// [SessionDataShaftDriver]. It is the primary base for creating new resources
/// within an authenticated context, ensuring that the `ncc` session data
/// (such as Authorization tokens) is automatically injected into the request.
///
/// The [RemoteObject] handles the serialization of the payload and the
/// mapping of the server's response.
/// {@endtemplate}
abstract base class DatasourcePostSession<
  RemoteObject extends Codable<Object, RemoteObject>
>
    extends DatasourceNccPost<RemoteObject, SessionDataShaftDriver> {
  /// {@macro datasource_post_session}
  ///
  /// Requires a [SessionDataShaftDriver] to perform the authenticated creation.
  DatasourcePostSession({required super.driver});
}
