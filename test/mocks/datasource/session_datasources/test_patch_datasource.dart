part of '../implementation_datasource.dart';

final class TestSessionPatchDataSource extends DatasourceSessionPatch<MockModel>
    with ImplementationDatasource {
  new({required super.driver});

  @override
  PatchParams generateCallRequirement({required Params params}) {
    return const PatchParams();
  }
}
