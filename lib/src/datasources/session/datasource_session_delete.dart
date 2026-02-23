import 'package:data_shaft/data_shaft.dart';
import 'package:ncc_data_shaft/src/datasources/datasource_ncc.dart';
import 'package:ncc_data_shaft/src/driver/ncc_connection_driver.dart';

/// {@template datasource_delete_session}
/// A session-aware remote datasource for **DELETE** operations.
///
/// This class specializes [DatasourceNccDelete] by strictly requiring a
/// [SessionDataShaftDriver]. It is intended for removing resources that
/// require an active session or authenticated context (e.g., deleting user-owned data).
///
/// The [RemoteObject] handles the mapping of the data, while the
/// [SessionDataShaftDriver] ensures that session-specific headers or tokens
/// are included in the request.
/// {@endtemplate}
abstract base class DatasourceDeleteSession<
        RemoteObject extends Codable<Object, RemoteObject>>
    extends DatasourceNccDelete<RemoteObject, SessionDataShaftDriver> {
  /// {@macro datasource_delete_session}
  ///
  /// Requires a [SessionDataShaftDriver] instance to perform the authenticated deletion.
  DatasourceDeleteSession({required super.driver});
}
