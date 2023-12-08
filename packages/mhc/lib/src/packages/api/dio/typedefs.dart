import '../../../../mhc.dart';

typedef EmptyFactory<T> = T Function(Response<dynamic>? response);
typedef StringFactory<T> = T Function(String body);
typedef JsonFactory<T> = T Function(JSON json);
typedef ListFactory<T, LT> = T Function(List<LT> list);

typedef DioServiceResponse<R, ERR> = ServiceResponse<R, ERR, DioResponseExtra>;
typedef DioServiceResult<R, ERR>
    = ServiceResult<R, ERR, DioResponseExtraSuccess>;
typedef DioServiceError<R, ERR> = ServiceError<R, ERR, DioResponseExtra>;

typedef DioResponseTransformer<R, ERR, D> = Future<DioServiceResponse<R, ERR>>
    Function(Response<D> resp);

class DioRequestExtra {
  const DioRequestExtra({this.ignoreAuth = false});

  final bool ignoreAuth;
}

sealed class DioResponseExtra {
  const DioResponseExtra(this.response);

  const factory DioResponseExtra.success(Response<dynamic>? response) =
      DioResponseExtraSuccess;

  const factory DioResponseExtra.failure(Response<dynamic>? response) =
      DioResponseExtraFailure;

  final Response<dynamic>? response;
}

class DioResponseExtraSuccess extends DioResponseExtra {
  const DioResponseExtraSuccess(super.response);
}

class DioResponseExtraFailure extends DioResponseExtra {
  const DioResponseExtraFailure(super.response);
}
