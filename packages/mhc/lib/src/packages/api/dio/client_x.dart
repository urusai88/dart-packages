import 'dart:typed_data';

import '../../api.dart';
import '../../core.dart';

class DioServiceRequestBuilder<T, ERR> {
  const DioServiceRequestBuilder._(
    this._client,
    this.path, {
    required this.method,
    this.data,
    this.queryParameters,
    this.options,
    this.cancelToken,
    this.onSendProgress,
    this.onReceiveProgress,
  });

  final DioClient<ERR> _client;

  final String path;
  final String method;
  final Object? data;
  final JSON? queryParameters;
  final Options? options;
  final CancelToken? cancelToken;
  final ProgressCallback? onSendProgress;
  final ProgressCallback? onReceiveProgress;

  Future<DioServiceResponse<R, ERR /*, DataT*/ >> _call<R, D>(
    ResponseType responseType,
    DioResponseTransformer<R, ERR, D> transformer,
  ) =>
      _client._request<R, D>(
        path,
        transformer,
        data: data,
        queryParameters: queryParameters,
        options: DioClientX._checkOptions(
          options: options,
          method: method,
          responseType: responseType,
        ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

  Future<DioServiceResponse<T, ERR /*, JSON*/ >> one() =>
      _call<T, JSON>(ResponseType.json, _client.transformOne);

  Future<DioServiceResponse<List<T>, ERR /*, List<dynamic>*/ >> many() =>
      _call<List<T>, List<dynamic>>(ResponseType.json, _client.transformMany);

  Future<DioServiceResponse<Uint8List, ERR /*, Uint8List*/ >> bytes() =>
      _call(ResponseType.bytes, _client.transformBytes);

  Future<DioServiceResponse<void, ERR /*, dynamic*/ >> zero() =>
      _call(ResponseType.plain, _client.transformZero);
}

extension DioClientX<ERR> on DioClient<ERR> {
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

  static Options _checkOptions({
    Options? options,
    required String method,
    ResponseType? responseType,
  }) =>
      (options ?? Options()).copyWith(
        method: method,
        responseType: responseType,
      );

  Future<DioServiceResponse<R, ERR>> _request<R, D>(
    String path,
    DioResponseTransformer<R, ERR, D> transformer, {
    Object? data,
    JSON? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio
          .request<D>(
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

  DioServiceRequestBuilder<R, ERR> get<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) =>
      DioServiceRequestBuilder._(
        this,
        path,
        method: 'GET',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

  DioServiceRequestBuilder<R, ERR> post<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) =>
      DioServiceRequestBuilder._(
        this,
        path,
        method: 'POST',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );

  DioServiceRequestBuilder<R, ERR> put<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      DioServiceRequestBuilder._(
        this,
        path,
        method: 'PUT',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );

  DioServiceRequestBuilder<R, ERR> patch<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      DioServiceRequestBuilder._(
        this,
        path,
        method: 'PATCH',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );

  DioServiceRequestBuilder<R, ERR> delete<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      DioServiceRequestBuilder._(
        this,
        path,
        method: 'DELETE',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
}
