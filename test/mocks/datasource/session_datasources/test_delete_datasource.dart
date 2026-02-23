part of '../implementation_datasource.dart';

final class TestSessionDeleteDataSource extends DatasourceDeleteSession<MockModel>
    with ImplementationDatasource {
  TestSessionDeleteDataSource({required super.driver});

  @override
  DeleteParams? generateCallRequirement({required Params params}) {
    return const DeleteParams();
  }
}
