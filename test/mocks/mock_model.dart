import 'package:data_shaft/data_shaft.dart';

final class MockModel extends Codable<String, MockModel> {
  const MockModel({this.message});
  final String? message;

  @override
  MockModel decode(String body) {
    final map = jsonDecode(body) as Map<String, dynamic>;
    return MockModel(message: map['message'] as String?);
  }

  Object encode() => {'message': message};

  @override
  List<Object?> get props => [message];

  @override
  JsonCodec? get serializer => throw UnimplementedError();

  @override
  Encoding? get encoding => throw UnimplementedError();
}
