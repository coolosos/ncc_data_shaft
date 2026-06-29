part of '../implementation_datasource.dart';

final class TestHttpGetDataSource extends DatasourceHttpGet<MockModel>
    with ImplementationDatasource {
  TestHttpGetDataSource({required super.driver});

  @override
  GetParams generateCallRequirement({required Params params}) {
    return const GetParams();
  }
}
