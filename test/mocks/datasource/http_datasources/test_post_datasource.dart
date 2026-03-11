part of '../implementation_datasource.dart';

final class TestHttpPostDataSource extends DatasourcePostHttp<MockModel>
    with ImplementationDatasource {
  TestHttpPostDataSource({required super.driver});

  @override
  PostParams generateCallRequirement({required Params params}) {
    return const PostParams();
  }
}
