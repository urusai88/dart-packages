import 'dart:typed_data';

import '../../../../mhc.dart';

class DioClientRequestProxy<T, ERR> {
  const DioClientRequestProxy(
    this._client,
    this.path, {
    required this.method,
    this.data,
    this.queryParameters,
    this.options,
    this.cancelToken,
    this.onSendProgress,
    this.onReceiveProgress,
    this.extra,
  });

  final DioServiceClient<ERR> _client;

  final String path;
  final String method;
  final Object? data;
  final JSON? queryParameters;
  final Options? options;
  final CancelToken? cancelToken;
  final ProgressCallback? onSendProgress;
  final ProgressCallback? onReceiveProgress;
  final DioRequestExtra? extra;

  Future<DioServiceResponse<R, ERR>> _call<R, D>(
    ResponseType responseType,
    DioResponseTransformer<R, ERR, D> transformer,
  ) =>
      _client.request<R, D>(
        path,
        transformer,
        data: data,
        queryParameters: queryParameters,
        options: DioServiceClient.checkOptions(
          options: options,
          method: method,
          responseType: responseType,
        ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        extra: extra,
      );

  Future<DioServiceResponse<T, ERR>> one() =>
      _call<T, JSON>(ResponseType.json, _client.transformOne);

  Future<DioServiceResponse<List<T>, ERR>> many() =>
      _call<List<T>, List<dynamic>>(ResponseType.json, _client.transformMany);

  Future<DioServiceResponse<Uint8List, ERR>> bytes() =>
      _call(ResponseType.bytes, _client.transformBytes);

  Future<DioServiceResponse<void, ERR>> zero() =>
      _call(ResponseType.plain, _client.transformZero);
}
