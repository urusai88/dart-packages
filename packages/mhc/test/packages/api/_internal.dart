import 'dart:typed_data';

import 'package:mhc/mhc.dart';

import '_entities.dart';

const serverPort = 9000;

typedef ResponseError = String;

typedef MyServiceResponse<R /*, DataT*/ >
    = DioServiceResponse<R, ResponseError>;

typedef MyServiceResult<R /*, DataT*/ > = DioServiceResult<R, ResponseError>;

typedef MyServiceError<R /*, DataT*/ > = DioServiceError<R, ResponseError>;

class DioTestService extends DioService<ResponseError> {
  const DioTestService({required super.client});

  Future<MyServiceResponse<Todo /*, JSON*/ >> todo(int id) =>
      client.get<Todo>('/todos/$id').one();

  Future<MyServiceResponse<List<Todo> /*, List<dynamic>*/ >> todos() =>
      client.get<Todo>('/todos').many();

  Future<MyServiceResponse<Todo /*, JSON*/ >> todoBadResponse(int id) =>
      client.get<Todo>('/users/$id').one();

  Future<MyServiceResponse<Uint8List /*, Uint8List*/ >> bytes() =>
      client.get<Uint8List>('/bytes').bytes();
}

final factoryConfiguration = FactoryConfig<ResponseError>(
  errorGroup: FactoryGroup(
    empty: (response) => 'Неизвестная ошибка',
    string: (string) => string,
    json: (json) => json['message'] as ResponseError,
  ),
)
  ..add<Todo>(Todo.fromJson)
  ..add<User>(User.fromJson);

final dio = Dio(
  BaseOptions(baseUrl: 'http://127.0.0.1:$serverPort/'),
);

final client = DioClient<ResponseError>(
  dio: dio,
  factoryConfig: factoryConfiguration,
);

final todosService = DioTestService(client: client);
