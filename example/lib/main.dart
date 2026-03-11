import 'dart:async';
import 'dart:developer';

import 'package:ncc_data_shaft/ncc_data_shaft.dart';

Future<void> main(List<String> args) async {
  //1. Init driver
  final driver = HttpDataShaftDriver(
    client: NccClient(client: Client(), id: 'NccClient'),
  );

  //2. Create DATA classes
  final datasource = GetPostRemoteDataSource(
    driver: driver,
  );
  final repository = PostRemoteRepository(dataSource: datasource);

  //3. Execute repository call
  final remotePost = await repository.call(
    repositoryParams: const RemotePostParams(postId: 1),
  );

  //4. Manage result
  if (remotePost.toNullable() case final post?) {
    log(post.toString());
  }
}

final class PostRemote extends Codable<String, PostRemote> {
  const PostRemote({this.body = '', this.id = 0, this.title = ''});
  final int id;
  final String title;
  final String body;

  @override
  PostRemote decode(String remote) {
    final map = json.decode(remote);
    if (map is Map<String, dynamic>) {
      return PostRemote(
        id: map['id'] as int,
        title: map['title'] as String? ?? '',
        body: map['body'] as String? ?? '',
      );
    }
    return const PostRemote();
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
      ];

  @override
  JsonCodec? get serializer => null;

  @override
  Encoding? get stringEncoding => null;

  @override
  bool? get stringify => true;
}

final class RemotePostParams extends Params {
  const RemotePostParams({required this.postId});

  final int postId;
  @override
  bool get isValid => !postId.isNegative;

  @override
  List<Object?> get props => [postId];
}

final class GetPostRemoteDataSource extends DatasourceGetHttp<PostRemote> {
  GetPostRemoteDataSource({required super.driver});

  @override
  List<int> get admissibleStatusCode => [200];

  @override
  List<int> get inadmissibleStatusCode => [400, 404, 403];

  @override
  String get host => 'https://jsonplaceholder.typicode.com/';

  @override
  String? get path => 'posts/{id}';

  @override
  final Map<String, String> pathModification = {'{id}': ''};

  @override
  GetParams generateCallRequirement({required RemotePostParams params}) {
    pathModification.update('{id}', (value) => params.postId.toString());
    return const GetParams();
  }

  @override
  PostRemote transformation({
    required RequestResponse remoteResponse,
  }) =>
      const PostRemote().decode(remoteResponse.body!());
}

final class PostRemoteRepository
    extends DeduplicationCacheRepository<PostRemote, GetPostRemoteDataSource> {
  PostRemoteRepository({
    required super.dataSource,
  }) : super(refreshDuration: const Duration(minutes: 5));

  @override
  Future<Either<RepositoryError, PostRemote>> call({
    required RemotePostParams repositoryParams,
  });
}
