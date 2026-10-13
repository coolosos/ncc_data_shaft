part of '../implementation_datasource.dart';

final class TestSessionHeadDataSource extends DatasourceSessionHead<MockModel>
    with ImplementationDatasource {
  new({required super.driver});

  @override
  HeadParams generateCallRequirement({required Params params}) {
    return const HeadParams();
  }
}
