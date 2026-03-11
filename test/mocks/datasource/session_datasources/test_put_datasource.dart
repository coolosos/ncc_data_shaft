part of '../implementation_datasource.dart';

final class TestSessionPutDataSource extends DatasourcePutSession<MockModel>
    with ImplementationDatasource {
  TestSessionPutDataSource({required super.driver});

  @override
  PutParams generateCallRequirement({required Params params}) {
    return const PutParams();
  }
}
