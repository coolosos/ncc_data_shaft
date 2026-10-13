part of '../implementation_datasource.dart';

final class TestHttpPutDataSource extends DatasourceHttpPut<MockModel>
    with ImplementationDatasource {
  new({required super.driver});

  @override
  PutParams generateCallRequirement({required Params params}) {
    return const PutParams();
  }
}
