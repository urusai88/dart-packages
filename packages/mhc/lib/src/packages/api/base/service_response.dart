typedef NewResultBuilder<NewResultT, ResultT> = NewResultT Function(
  ResultT result,
);

sealed class ServiceResponse<ResultT, ErrorT, ExtraT> {
  const ServiceResponse._({required this.extra});

  const factory ServiceResponse.result({
    required ExtraT extra,
    required ResultT result,
  }) = ServiceResult;

  const factory ServiceResponse.error({
    required ExtraT extra,
    required ErrorT error,
    int? errorCode,
  }) = ServiceError;

  final ExtraT extra;

  ServiceResponse<NewResultT, ErrorT, ExtraT> copyWithResult<NewResultT>(
    NewResultBuilder<NewResultT, ResultT?> resultBuilder,
  ) =>
      switch (this) {
        final ServiceResult<ResultT, ErrorT, ExtraT> r =>
          ServiceResponse.result(extra: extra, result: resultBuilder(r.result)),
        final ServiceError<ResultT, ErrorT, ExtraT> e =>
          ServiceResponse.error(extra: extra, error: e.error),
      };
}

final class ServiceResult<ResultT, ErrorT, ExtraT>
    extends ServiceResponse<ResultT, ErrorT, ExtraT> {
  const ServiceResult({required super.extra, required this.result}) : super._();

  final ResultT result;
}

final class ServiceError<ResultT, ErrorT, ExtraT>
    extends ServiceResponse<ResultT, ErrorT, ExtraT> {
  const ServiceError({
    required super.extra,
    required this.error,
    this.errorCode,
  }) : super._();

  final ErrorT error;
  final int? errorCode;
}
