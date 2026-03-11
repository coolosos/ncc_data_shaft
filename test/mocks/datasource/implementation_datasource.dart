import 'package:ncc_data_shaft/ncc_data_shaft.dart';
import '../mock_model.dart';

part 'http_datasources/test_delete_datasource.dart';
part 'http_datasources/test_get_datasource.dart';
part 'http_datasources/test_patch_datasource.dart';
part 'http_datasources/test_post_datasource.dart';
part 'http_datasources/test_put_datasource.dart';

part 'session_datasources/test_delete_datasource.dart';
part 'session_datasources/test_get_datasource.dart';
part 'session_datasources/test_patch_datasource.dart';
part 'session_datasources/test_post_datasource.dart';
part 'session_datasources/test_put_datasource.dart';

mixin ImplementationDatasource<RemoteDriver extends NccConnectionDriver>
    on DatasourceRemote<MockModel, RemoteDriver> {
  @override
  List<int> get admissibleStatusCode => [200];

  @override
  String get host => 'https://test.com';

  @override
  String? get path => 'datasource/test';

  @override
  MockModel transformation({required RequestResponse remoteResponse}) {
    return const MockModel().decode(remoteResponse.body!());
  }
}

List<DatasourceRemote<MockModel, NccConnectionDriver>> getAllHttp({
  required HttpDataShaftDriver driver,
}) =>
    [
      TestHttpDeleteDataSource(driver: driver),
      TestHttpGetDataSource(driver: driver),
      TestHttpPatchDataSource(driver: driver),
      TestHttpPostDataSource(driver: driver),
      TestHttpPutDataSource(driver: driver),
    ];

List<DatasourceRemote<MockModel, NccConnectionDriver>> getAllSession({
  required SessionDataShaftDriver driver,
}) =>
    [
      TestSessionDeleteDataSource(driver: driver),
      TestSessionGetDataSource(driver: driver),
      TestSessionPatchDataSource(driver: driver),
      TestSessionPostDataSource(driver: driver),
      TestSessionPutDataSource(driver: driver),
    ];

List<DatasourceRemote<MockModel, NccConnectionDriver>> getAll({
  required HttpDataShaftDriver driverHttp,
  required SessionDataShaftDriver driverSession,
}) =>
    [
      ...getAllHttp(driver: driverHttp),
      ...getAllSession(driver: driverSession),
    ];
