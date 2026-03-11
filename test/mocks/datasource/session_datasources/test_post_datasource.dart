part of '../implementation_datasource.dart';

final class TestSessionPostDataSource extends DatasourcePostSession<MockModel>
    with ImplementationDatasource {
  TestSessionPostDataSource({required super.driver});

  @override
  PostParams generateCallRequirement({required Params params}) {
    return const PostParams();
  }
}
