import '../../api.dart';
import '../../core.dart';

export 'package:dio/dio.dart';

class DioRequestExtra {
  const DioRequestExtra({this.ignoreAuth = false});

  final bool ignoreAuth;
}

class DioClient<ErrorT> {
  DioClient({
    required this.dio,
    required this.factoryConfig,
  }) {
    dio.transformer = SyncTransformer();
  }

  final Dio dio;
  final FactoryConfig<ErrorT> factoryConfig;

  DioResponseExtraSuccess<DataT> makeResponseExtraSuccess<DataT>(
    Response<DataT> response,
  ) =>
      DioResponseExtraSuccess<DataT>(response);

  DioResponseExtraFailure<DataT> makeResponseExtraFailure<DataT>(
    Response<dynamic> response,
  ) =>
      DioResponseExtraFailure<DataT>(response);

  DioRequestExtra getExtra(RequestOptions options) {
    if (options.extra.containsKey('dio_client_extra')) {
      return options.extra['dio_client_extra'] as DioRequestExtra;
    }
    return const DioRequestExtra();
  }

  JsonFactory<T> _checkFactory<T>() {
    final factory = factoryConfig.get<T>();
    if (factory == null) {
      throw const ClientError.wrongConfiguration();
    }
    return factory;
  }

  Future<DioServiceResult<R, ErrorT, JSON>> transformOne<R>(
    Response<JSON> response,
  ) {
    final factory = _checkFactory<R>();
    final data = response.data;
    if (data is! JSON) {
      throw const ClientError.middlewareError();
    }
    final json = JSON.from(data);
    try {
      return Future.value(
        DioServiceResult(
          extra: makeResponseExtraSuccess(response),
          result: factory(json),
        ),
      );
    } on Error catch (e, s) {
      throw const ClientError.middlewareError();
    }
  }

  Future<DioServiceResult<List<R>, ErrorT, List<dynamic>>> transformMany<R>(
    Response<List<dynamic>> response,
  ) {
    try {
      final factory = _checkFactory<R>();
      final data = response.data;
      if (data is! List<JSON>) {
        throw const ClientError.middlewareError();
      }
      final json = List<JSON>.from(data);
      final result = json.map(factory).toList();

      return Future.value(
        DioServiceResult(
          extra: makeResponseExtraSuccess(response),
          result: result,
        ),
      );
    } on Error catch (e, s) {
      throw const ClientError.middlewareError();
    }
  }

  Future<DioServiceResult<void, ErrorT, dynamic>> transformZero(
    Response<dynamic> resp,
  ) =>
      Future.value(
        DioServiceResult(
          extra: makeResponseExtraSuccess(resp),
          result: null,
        ),
      );

  ErrorT transformError(Response<dynamic> response) {
    final group = factoryConfig.errorGroup;
    final data = response.data;
    if (data == null || ((data is String) && data.isEmpty)) {
      return group.empty(response);
    }

    try {
      return switch (data) {
        null => group.empty(response),
        final String string when string.isEmpty => group.empty(response),
        final String string => group.string(string),
        final JSON json => group.json(json),
        _ => throw const ClientError.middlewareError(),
      };
    } on Error catch (e, s) {
      throw const ClientError.middlewareError();
    }
  }
}
