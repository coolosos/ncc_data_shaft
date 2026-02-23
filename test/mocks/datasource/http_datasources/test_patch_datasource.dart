part of '../implementation_datasource.dart';

final class TestHttpPatchDataSource extends DatasourcePatchHttp<MockModel>
    with ImplementationDatasource {
  TestHttpPatchDataSource({required super.driver});

  @override
  PatchParams? generateCallRequirement({required Params params}) {
    return const PatchParams();
  }
}
