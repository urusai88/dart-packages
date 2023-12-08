import 'dart:typed_data';

import '../../../../mhc.dart';

export 'package:dio/dio.dart';

export 'client_x.dart';

const _extraKey = 'dio_client_extra';

class DioServiceClient<ERR> extends BaseServiceClient<ERR, DioResponseExtra> {
  const DioServiceClient({required this.dio, required this.factoryConfig});

  final Dio dio;
  final FactoryConfig<ERR> factoryConfig;

  DioResponseExtra makeResponseExtra(
    Response<dynamic> response,
  ) =>
      DioResponseExtra(response);

  DioRequestExtra makeRequestExtra(RequestOptions options) {
    if (options.extra[_extraKey] is DioRequestExtra) {
      return options.extra[_extraKey] as DioRequestExtra;
    }
    return const DioRequestExtra();
  }

  JsonFactory<T> _checkFactory<T>() {
    final factory = factoryConfig.get<T>();
    if (factory == null) {
      throw ClientError.badConfig(
        message: 'Отсутствует фабрика для $T',
      );
    }
    return factory;
  }

  Future<DioServiceResponse<Uint8List, ERR>> transformBytes(
    Response<Uint8List> response,
  ) =>
      Future.value(
        DioServiceResponse.result(
          extra: makeResponseExtra(response),
          result: response.data!,
        ),
      );

  Future<DioServiceResponse<R, ERR>> transformOne<R>(
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
        DioServiceResponse.result(
          extra: makeResponseExtra(response),
          result: factory(json),
        ),
      );
    } on Error catch (e, s) {
      throw ClientError.middlewareError(stackTrace: s);
    }
  }

  Future<DioServiceResponse<List<R>, ERR>> transformMany<R>(
    Response<List<dynamic>> response,
  ) {
    final factory = _checkFactory<R>();
    final json = response.data?.castChecked<JSON>();
    if (json == null) {
      throw const ClientError.middlewareError();
    }

    try {
      final result = json.map(factory).toList();

      return Future.value(
        DioServiceResponse.result(
          extra: makeResponseExtra(response),
          result: result,
        ),
      );
    } on Error catch (e, s) {
      throw ClientError.middlewareError(stackTrace: s);
    }
  }

  Future<DioServiceResponse<void, ERR>> transformZero(
    Response<dynamic> resp,
  ) =>
      Future.value(
        DioServiceResponse.result(
          extra: makeResponseExtra(resp),
          result: null,
        ),
      );

  ERR transformError(Response<dynamic> response) {
    final group = factoryConfig.errorGroup;
    final data = response.data;
    if (data == null || ((data is String) && data.isEmpty)) {
      return group.empty(response);
    }

    try {
      return switch (data) {
        final String string when string.isEmpty => group.empty(response),
        final String string => group.string(string),
        final JSON json => group.json(json),
        _ => group.empty(response),
      };
    } on Error catch (e, s) {
      throw ClientError.middlewareError(stackTrace: s);
    }
  }

  Future<DioServiceResponse<R, ERR>> request<R, D>(
    String path,
    DioResponseTransformer<R, ERR, D> transformer, {
    Object? data,
    JSON? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    DioRequestExtra? extra,
  }) async {
    extra ??= const DioRequestExtra();
    try {
      return await dio
          .request<D>(
            path,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: checkOptions(options: options, extra: extra),
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          )
          .then(transformer);
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.badResponse) {
        return DioServiceError(
          extra: makeResponseExtra(e.response!),
          error: transformError(e.response!),
        );
      }
      rethrow;
    }
  }

  static Response<T> castResponse<T>(Response<dynamic> response) {
    return Response<T>(
      data: response.data != null ? response.data as T : null,
      requestOptions: response.requestOptions,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      isRedirect: response.isRedirect,
      redirects: response.redirects,
      extra: response.extra,
      headers: response.headers,
    );
  }

  static Options checkOptions({
    Options? options,
    String? method,
    ResponseType? responseType,
    DioRequestExtra? extra,
  }) {
    options ??= Options();
    options = options.copyWith(method: method, responseType: responseType);
    if (options.extra == null) {
      options = options.copyWith(extra: const <String, dynamic>{});
    }
    if (options.extra!.containsKey(_extraKey)) {
      options = options.copyWith(
        extra: <String, dynamic>{...options.extra!, _extraKey: extra},
      );
    }
    return options;
  }
}
