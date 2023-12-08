import 'dart:io';

import '../../../../../mhc.dart';

typedef TokenKey = StorageKey<String>;

class TokenRefreshResult {
  const TokenRefreshResult({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;
}

abstract class DioAuthInterceptor<R, ERR> extends DioClientInterceptor<ERR> {
  const DioAuthInterceptor({required super.client});

  Logger get _logger => Logger(loggerName);

  String get loggerName => 'DioAuthInterceptor';

  TokenKey get accessTokenKey;

  TokenKey get refreshTokenKey;

  bool tokenExpiredResolver(ERR error);

  Future<DioServiceResponse<R, ERR>> refreshJwt(
    String refreshToken,
  );

  TokenRefreshResult getRefreshTokenResult(
    DioServiceResult<R, ERR> result,
  );

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await accessTokenKey.get();
    if (accessToken?.isEmpty ?? true) {
      return handler.next(options);
    }

    final extra = client.makeRequestExtra(options);
    if (!extra.ignoreAuth) {
      options.headers = {
        ...options.headers,
        HttpHeaders.authorizationHeader: accessToken,
      };
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    if (response == null || response.statusCode != 400) {
      return handler.next(err);
    }
    _logger.info(
      '400 error, response.data.runtimeType: ${_dataToString(response.data)}',
    );
    if (response.data case final JSON data) {
      try {
        final error = client.factoryConfig.errorGroup.json(data);
        if (tokenExpiredResolver(error)) {
          _logger.info('token expired');
          final newResponse =
              await _refreshToken().then((_) => _restart(response));
          handler.resolve(newResponse);
        } else {
          handler.next(err);
        }
      } catch (e, s) {
        _logger.warning('$e\n$s');
        handler.next(err);
      }
    }
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode != 400) {
      return handler.next(response);
    }
    _logger.info(
      '400 error, response.data.runtimeType: ${_dataToString(response.data)}',
    );
    if (response.data case final JSON data) {
      try {
        final error = client.factoryConfig.errorGroup.json(data);
        if (tokenExpiredResolver(error)) {
          _logger.info('token expired');
          response = await _refreshToken().then((_) => _restart(response));
        }
      } catch (e, s) {
        _logger.warning('$e\n$s');
      }
    }

    return handler.next(response);
  }

  Future<void> _refreshToken() async {
    final refreshToken = await refreshTokenKey.get();
    _logger.info('refreshToken: $refreshToken');
    if (refreshToken == null) {
      return;
    }

    switch (await refreshJwt(refreshToken)) {
      case final DioServiceResult<R, ERR> result:
        _logger.info('refreshJwt: $result');
        final data = getRefreshTokenResult(result);
        await accessTokenKey.set(data.accessToken);
        await refreshTokenKey.set(data.refreshToken);
      case final DioServiceError<dynamic, dynamic> error:
        _logger.info('refreshJwt: $error');
        await accessTokenKey.delete();
        await refreshTokenKey.delete();
    }
  }

  static Options _optionsFromRequest(
    RequestOptions requestOptions,
  ) =>
      Options(
        method: requestOptions.method,
        sendTimeout: requestOptions.sendTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        extra: requestOptions.extra,
        headers: requestOptions.headers,
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        validateStatus: requestOptions.validateStatus,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
        followRedirects: requestOptions.followRedirects,
        maxRedirects: requestOptions.maxRedirects,
        persistentConnection: requestOptions.persistentConnection,
        requestEncoder: requestOptions.requestEncoder,
        responseDecoder: requestOptions.responseDecoder,
      );

  Future<Response<T>> _restart<T>(
    Response<T> originalResponse,
  ) {
    final originalOptions = originalResponse.requestOptions;
    return client.dio.request(
      originalOptions.path,
      options: _optionsFromRequest(originalOptions),
      data: originalOptions.data,
      queryParameters: originalOptions.queryParameters,
      onSendProgress: originalOptions.onSendProgress,
      onReceiveProgress: originalOptions.onReceiveProgress,
      cancelToken: originalOptions.cancelToken,
    );
  }

  static String _dataToString(dynamic data) =>
      data == null ? 'Null' : '${data.runtimeType}';
}
