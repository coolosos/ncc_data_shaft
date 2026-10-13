part of '../implementation_datasource.dart';

final class TestHttpHeadDataSource extends DatasourceHttpHead<MockModel>
    with ImplementationDatasource {
  new({required super.driver});

  @override
  HeadParams generateCallRequirement({required Params params}) {
    return const HeadParams();
  }
}
