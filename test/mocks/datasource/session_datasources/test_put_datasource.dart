part of '../implementation_datasource.dart';

final class TestSessionPutDataSource extends DatasourceSessionPut<MockModel>
    with ImplementationDatasource {
  new({required super.driver});

  @override
  PutParams generateCallRequirement({required Params params}) {
    return const PutParams();
  }
}
