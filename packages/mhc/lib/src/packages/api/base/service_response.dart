typedef ResultBuilder<R, ERR, EXTRA, R1> = R1 Function(
  ServiceResult<R, ERR, EXTRA> current,
);

sealed class ServiceResponse<R, ERR, EXTRA> {
  const ServiceResponse._({required this.extra});

  const factory ServiceResponse.result({
    required EXTRA extra,
    required R result,
  }) = ServiceResult;

  const factory ServiceResponse.error({
    required EXTRA extra,
    required ERR error,
  }) = ServiceError;

  final EXTRA extra;

  ServiceResponse<R1, ERR, EXTRA> withResult<R1>(
    ResultBuilder<R, ERR, EXTRA, R1> builder,
  ) {
    return switch (this) {
      final ServiceResult<R, ERR, EXTRA> response =>
        ServiceResult<R1, ERR, EXTRA>(
          extra: response.extra,
          result: builder(response),
        ),
      final ServiceError<R, ERR, EXTRA> response =>
        ServiceError<R1, ERR, EXTRA>(
          extra: response.extra,
          error: response.error,
        ),
    };
  }
}

final class ServiceResult<R, ERR, EXTRA>
    extends ServiceResponse<R, ERR, EXTRA> {
  const ServiceResult({required super.extra, required this.result}) : super._();

  final R result;

  ServiceResult<R1, ERR, EXTRA> withResult<R1>(
    ResultBuilder<R, ERR, EXTRA, R1> builder,
  ) =>
      ServiceResult(extra: extra, result: builder(this));
}

final class ServiceError<R, ERR, EXTRA> extends ServiceResponse<R, ERR, EXTRA> {
  const ServiceError({
    required super.extra,
    required this.error,
  }) : super._();

  final ERR error;
}
