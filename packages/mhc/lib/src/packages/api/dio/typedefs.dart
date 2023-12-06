import '../../api.dart';
import '../../core.dart';

typedef EmptyFactory<T> = T Function(Response<dynamic>? response);
typedef StringFactory<T> = T Function(String body);
typedef JsonFactory<T> = T Function(JSON json);
typedef ListFactory<T, LT> = T Function(List<LT> list);

typedef DioServiceResponse<ResultT, ErrorT, ResponseT>
    = ServiceResponse<ResultT, ErrorT, DioResponseExtra<ResponseT>>;
typedef DioServiceResult<ResultT, ErrorT, ResponseT>
    = ServiceResult<ResultT, ErrorT, DioResponseExtraSuccess<ResponseT>>;
typedef DioServiceError<ResultT, ErrorT, ResponseT>
    = ServiceError<ResultT, ErrorT, DioResponseExtraFailure<ResponseT>>;

typedef DioResponseTransformer<ResultT, ErrorT, ResponseT>
    = Future<DioServiceResponse<ResultT, ErrorT, ResponseT>> Function(
  Response<ResponseT> resp,
);

sealed class DioResponseExtra<DataT> {
  const DioResponseExtra();

  const factory DioResponseExtra.success(Response<DataT>? response) =
      DioResponseExtraSuccess;

  const factory DioResponseExtra.failure(Response<DataT>? response) =
      DioResponseExtraFailure;
}

class DioResponseExtraSuccess<DataT> extends DioResponseExtra<DataT> {
  const DioResponseExtraSuccess(this.response);

  final Response<DataT>? response;
}

class DioResponseExtraFailure<DataT> extends DioResponseExtra<DataT> {
  const DioResponseExtraFailure(this.response);

  final Response<dynamic>? response;
}
