import '../../api.dart';
import '../../core.dart';

extension DioClientX<ERR> on DioServiceClient<ERR> {
  DioClientRequestProxy<R, ERR> get<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) =>
      DioClientRequestProxy(
        this,
        path,
        method: 'GET',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

  DioClientRequestProxy<R, ERR> post<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) =>
      DioClientRequestProxy(
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

  DioClientRequestProxy<R, ERR> put<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      DioClientRequestProxy(
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

  DioClientRequestProxy<R, ERR> patch<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      DioClientRequestProxy(
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

  DioClientRequestProxy<R, ERR> delete<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      DioClientRequestProxy(
        this,
        path,
        method: 'DELETE',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
}
