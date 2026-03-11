part of '../implementation_datasource.dart';

final class TestSessionGetDataSource extends DatasourceGetSession<MockModel>
    with ImplementationDatasource {
  TestSessionGetDataSource({required super.driver});

  @override
  GetParams generateCallRequirement({required Params params}) {
    return const GetParams();
  }
}
