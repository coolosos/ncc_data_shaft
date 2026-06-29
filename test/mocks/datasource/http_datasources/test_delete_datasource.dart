part of '../implementation_datasource.dart';

final class TestHttpDeleteDataSource extends DatasourceHttpDelete<MockModel>
    with ImplementationDatasource {
  TestHttpDeleteDataSource({required super.driver});

  @override
  DeleteParams generateCallRequirement({required Params params}) {
    return const DeleteParams();
  }
}
