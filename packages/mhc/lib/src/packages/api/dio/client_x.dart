import '../../api.dart';
import '../../core.dart';

extension DioClientX<ErrorT> on DioClient<ErrorT> {
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

  static Options _checkOptions(String method, Options? options) =>
      (options ?? Options())..method = method;

  Future<DioServiceResponse<ResultT, ErrorT, ResponseT>>
      _request<ResultT, ResponseT>(
    String path, {
    Object? data,
    JSON? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    required DioResponseTransformer<ResultT, ErrorT, ResponseT> transformer,
  }) async {
    try {
      return await dio
          .request<ResponseT>(
            path,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          )
          .then(transformer);
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.badResponse) {
        return DioServiceError(
          extra: makeResponseExtraFailure(e.response!),
          error: transformError(e.response!),
        );
      }
      rethrow;
    }
  }

  Future<DioServiceResponse<ResultT, ErrorT, JSON>> getOne<ResultT>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) =>
      _request<ResultT, JSON>(
        path,
        transformer: transformOne,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions('GET', options),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

  Future<DioServiceResponse<List<ResultT>, ErrorT, List<dynamic>>>
      getMany<ResultT>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) =>
          _request<List<ResultT>, List<dynamic>>(
            path,
            transformer: transformMany<ResultT>,
            data: data,
            queryParameters: queryParameters,
            options: _checkOptions('GET', options),
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
          );

  Future<DioServiceResponse<void, ErrorT, dynamic>> getZero(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) =>
      _request<void, dynamic>(
        path,
        transformer: transformZero,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions('GET', options),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

  Future<DioServiceResponse<ResultT, ErrorT, JSON>> postOne<ResultT>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      _request<ResultT, JSON>(
        path,
        transformer: transformOne,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions('POST', options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

  Future<DioServiceResponse<List<ResultT>, ErrorT, List<dynamic>>>
      postMany<ResultT>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
          _request<List<ResultT>, List<dynamic>>(
            path,
            transformer: transformMany<ResultT>,
            data: data,
            queryParameters: queryParameters,
            options: _checkOptions('POST', options),
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );

  Future<DioServiceResponse<void, ErrorT, dynamic>> postZero(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      _request<void, dynamic>(
        path,
        transformer: transformZero,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions('POST', options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

  Future<DioServiceResponse<ResultT, ErrorT, JSON>> putOne<ResultT>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      _request<ResultT, JSON>(
        path,
        transformer: transformOne,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions('PUT', options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

  Future<DioServiceResponse<List<ResultT>, ErrorT, List<dynamic>>>
      putMany<ResultT>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
          _request<List<ResultT>, List<dynamic>>(
            path,
            transformer: transformMany<ResultT>,
            data: data,
            queryParameters: queryParameters,
            options: _checkOptions('PUT', options),
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );

  Future<DioServiceResponse<void, ErrorT, dynamic>> putZero(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      _request<void, dynamic>(
        path,
        transformer: transformZero,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions('PUT', options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

  Future<DioServiceResponse<ResultT, ErrorT, JSON>> patchOne<ResultT>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      _request<ResultT, JSON>(
        path,
        transformer: transformOne,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions('PATCH', options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

  Future<DioServiceResponse<List<ResultT>, ErrorT, List<dynamic>>>
      patchMany<ResultT>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
          _request<List<ResultT>, List<dynamic>>(
            path,
            transformer: transformMany<ResultT>,
            data: data,
            queryParameters: queryParameters,
            options: _checkOptions('PATCH', options),
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );

  Future<DioServiceResponse<void, ErrorT, dynamic>> patchZero(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      _request<void, dynamic>(
        path,
        transformer: transformZero,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions('PATCH', options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

  Future<DioServiceResponse<ResultT, ErrorT, JSON>> deleteOne<ResultT>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      _request<ResultT, JSON>(
        path,
        transformer: transformOne,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions('DELETE', options),
        cancelToken: cancelToken,
      );

  Future<DioServiceResponse<List<ResultT>, ErrorT, List<dynamic>>>
      deleteMany<ResultT>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) =>
          _request<List<ResultT>, List<dynamic>>(
            path,
            transformer: transformMany<ResultT>,
            data: data,
            queryParameters: queryParameters,
            options: _checkOptions('DELETE', options),
            cancelToken: cancelToken,
          );

  Future<DioServiceResponse<void, ErrorT, dynamic>> deleteZero(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      _request<void, dynamic>(
        path,
        transformer: transformZero,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions('DELETE', options),
        cancelToken: cancelToken,
      );
}
