part of '../implementation_datasource.dart';

final class TestHttpPostDataSource extends DatasourceHttpPost<MockModel>
    with ImplementationDatasource {
  new({required super.driver});

  @override
  PostParams generateCallRequirement({required Params params}) {
    return const PostParams();
  }
}
