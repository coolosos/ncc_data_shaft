part of '../implementation_datasource.dart';

final class TestHttpPutDataSource extends DatasourcePutHttp<MockModel>
    with ImplementationDatasource {
  TestHttpPutDataSource({required super.driver});

  @override
  PutParams generateCallRequirement({required Params params}) {
    return const PutParams();
  }
}
