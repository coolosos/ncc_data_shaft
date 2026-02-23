part of '../implementation_datasource.dart';

final class TestSessionPatchDataSource extends DatasourcePatchSession<MockModel>
    with ImplementationDatasource {
  TestSessionPatchDataSource({required super.driver});

  @override
  PatchParams? generateCallRequirement({required Params params}) {
    return const PatchParams();
  }
}
