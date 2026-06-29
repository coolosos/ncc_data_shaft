part of '../implementation_datasource.dart';

final class TestSessionGetDataSource extends DatasourceSessionGet<MockModel>
    with ImplementationDatasource {
  TestSessionGetDataSource({required super.driver});

  @override
  GetParams generateCallRequirement({required Params params}) {
    return const GetParams();
  }
}
