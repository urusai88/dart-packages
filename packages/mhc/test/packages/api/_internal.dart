import 'package:mhc/mhc.dart';

import '_entities.dart';

const serverPort = 9000;

typedef ResponseError = String;

typedef MyServiceResponse<R, DataT>
    = DioServiceResponse<R, ResponseError, DataT>;

typedef MyServiceResult<R, DataT> = DioServiceResult<R, ResponseError, DataT>;

typedef MyServiceError<R, DataT> = DioServiceError<R, ResponseError, DataT>;

class TestDioService extends DioService<ResponseError> {
  const TestDioService({required super.client});

  Future<MyServiceResponse<Todo, JSON>> getTodo(int id) =>
      client.getOne('/todos/$id');

  Future<MyServiceResponse<List<Todo>, List<dynamic>>> listTodos() =>
      client.getMany('/todos');

  Future<MyServiceResponse<User, JSON>> wrongReturnType(int id) =>
      client.getOne('/todos/$id');

  Future<MyServiceResponse<void, void>> emptyResponse() =>
      client.getZero('/zero');

  Future<MyServiceResponse<void, void>> validationError() =>
      client.getZero('/422');

  Future<MyServiceResponse<void, dynamic>> errorString() =>
      client.getZero('/error_string');

  Future<MyServiceResponse<void, dynamic>> errorJson() =>
      client.getZero('/error_json');
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
// ..interceptors.add(const DioLogInterceptor(debugMode: true))

final client = DioClient<ResponseError>(
  dio: dio,
  factoryConfig: factoryConfiguration,
);

final todosService = TestDioService(client: client);
