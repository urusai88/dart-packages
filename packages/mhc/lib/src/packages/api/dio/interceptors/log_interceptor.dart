import 'dart:typed_data';

import 'package:dio/dio.dart';

class DioLogInterceptor extends Interceptor {
  const DioLogInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = true,
    this.responseBody = false,
    this.maxBodyLength,
    this.logBodyInRelease = false,
    this.error = true,
    this.logPrint = _debugPrint,
    required this.debugMode,
  });

  final bool request;
  final bool requestHeader;
  final bool requestBody;
  final bool responseBody;
  final bool responseHeader;
  final int? maxBodyLength;
  final bool logBodyInRelease;
  final bool debugMode;

  final bool error;
  final void Function(Object object) logPrint;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    logPrint('*** Request ***');
    _printKV('uri', '${options.method} ${options.uri}');

    if (request) {
      _printKV('responseType', options.responseType.toString());
      _printKV('followRedirects', options.followRedirects);
      _printKV('persistentConnection', options.persistentConnection);
      _printKV('connectTimeout', options.connectTimeout);
      _printKV('sendTimeout', options.sendTimeout);
      _printKV('receiveTimeout', options.receiveTimeout);
      _printKV(
        'receiveDataWhenStatusError',
        options.receiveDataWhenStatusError,
      );
      _printKV('extra', options.extra);
    }
    if (requestHeader) {
      logPrint('headers:');
      const only = <String>[
        'content-type',
        'authorization',
      ];
      final headers = Map.fromEntries(
        options.headers.entries
            .where((e) => only.contains(e.key.toLowerCase()))
            .map(
              (e) => MapEntry(
                e.key.toLowerCase(),
                e.value is List ? (e.value as List).first : e.value,
              ),
            ),
      );
      final authorization = headers['authorization'];
      if (authorization != null) {
        if (authorization is String && authorization.length > 20) {
          headers['authorization'] =
              authorization.substring(authorization.length - 5);
        } else {
          headers.remove('authorization');
        }
      }
      for (final e in headers.entries) {
        _printKV(' ${e.key}', e.value);
      }
    }
    if (requestBody) {
      if (debugMode || logBodyInRelease) {
        if (options.data == null) {
          logPrint('data: null');
        } else {
          logPrint('data:');
          _printAll(options.data);
        }
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    logPrint('*** Response ***');
    _printResponse(response);
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (error) {
      logPrint('*** DioException ***:');
      logPrint('uri: ${err.requestOptions.uri}');
      logPrint('$err');
      if (err.response != null) {
        _printResponse(err.response!);
      }
      logPrint('');
    }

    handler.next(err);
  }

  void _printResponse(Response<dynamic> response) {
    final method = response.requestOptions.method;
    final uri = response.requestOptions.uri;
    final statusCode = response.statusCode;
    _printKV('uri', '$method $uri');
    _printKV('statusCode', statusCode);

    final data = response.data;

    if (responseHeader) {
      if (response.isRedirect == true) {
        _printKV('redirect', response.realUri);
      }

      logPrint('headers:');
      const only = <String>[
        'content-type',
      ];
      final headers = Map.fromEntries(
        response.headers.map.entries
            .where((e) => only.contains(e.key))
            .map((e) => MapEntry(e.key, e.value.first)),
      );
      for (final e in headers.entries) {
        _printKV(' ${e.key}', e.value);
      }
    }
    if (responseBody) {
      // ignore: avoid_dynamic_calls
      logPrint('Response Type: ${response.data.runtimeType}');
      if (maxBodyLength != null) {
        switch (response.data) {
          case final String string:
            if (string.length > maxBodyLength!) {
              return;
            }
          case Uint8List() || List<int>():
            return;
        }
      }
      if (debugMode || logBodyInRelease) {
        final processed = _processValue(data);
        logPrint('Response Text: ${processed == null ? 'null' : ''}');
        if (processed != null) {
          _printAll(processed);
        }
      }
    }
  }

  void _printKV(String key, Object? v) {
    logPrint('$key: $v');
  }

  void _printAll(dynamic msg) {
    msg.toString().split('\n').forEach(logPrint);
  }

  T _processValue<T>(
    T value,
  ) =>
      switch (value) {
        final String s => s.length > 1024 ? '<TRIMMED>' : s,
        final Map<dynamic, dynamic> m =>
          m.map((k, v) => MapEntry(k, _processValue(v))),
        final List<dynamic> l => l.map(_processValue).toList(),
        final v => v
      } as T;
}

void _debugPrint(Object? object) {
  assert(
    () {
      // ignore: avoid_print
      print(object);
      return true;
    }(),
  );
}
