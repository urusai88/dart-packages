import 'dart:typed_data';

import '../../../../mhc.dart';

export 'package:dio/dio.dart';

class DioClient<ERR>
    extends BaseServiceClient<ERR, DioResponseExtra/*<dynamic>*/ > {
  const DioClient({required this.dio, required this.factoryConfig});

  final Dio dio;
  final FactoryConfig<ERR> factoryConfig;

  DioResponseExtraSuccess/*<DataT>*/ makeResponseExtraSuccess/*<DataT>*/(
    Response<dynamic /*DataT*/ > response,
  ) =>
      DioResponseExtraSuccess/*<DataT>*/(response);

  DioResponseExtraFailure/*<DataT>*/ makeResponseExtraFailure/*<DataT>*/(
    Response<dynamic> response,
  ) =>
      DioResponseExtraFailure/*<DataT>*/(response);

  DioRequestExtra getExtra(RequestOptions options) {
    if (options.extra['dio_client_extra'] is DioRequestExtra) {
      return options.extra['dio_client_extra'] as DioRequestExtra;
    }
    return const DioRequestExtra();
  }

  JsonFactory<T> _checkFactory<T>() {
    final factory = factoryConfig.get<T>();
    if (factory == null) {
      throw const ClientError.badConfig();
    }
    return factory;
  }

  Future<DioServiceResult<Uint8List, ERR /*, Uint8List*/ >> transformBytes(
    Response<Uint8List> response,
  ) {
    return Future.value(
      DioServiceResult(
        extra: makeResponseExtraSuccess(response),
        result: response.data!,
      ),
    );
  }

  Future<DioServiceResult<R, ERR /*, JSON*/ >> transformOne<R>(
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
      throw ClientError.middlewareError(stackTrace: s);
    }
  }

  Future<DioServiceResult<List<R>, ERR /*, List<dynamic>*/ >> transformMany<R>(
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
        DioServiceResult(
          extra: makeResponseExtraSuccess(response),
          result: result,
        ),
      );
    } on Error catch (e, s) {
      throw ClientError.middlewareError(stackTrace: s);
    }
  }

  Future<DioServiceResult<void, ERR /*, dynamic*/ >> transformZero(
    Response<dynamic> resp,
  ) =>
      Future.value(
        DioServiceResult(
          extra: makeResponseExtraSuccess(resp),
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
}
