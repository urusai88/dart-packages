enum ClientErrorType {
  configError,
  serviceError,
  middlewareError,
}

class ClientError implements Error {
  const ClientError({
    required this.type,
    this.message,
    this.stackTrace,
  });

  const ClientError.badConfig({this.message, this.stackTrace})
      : type = ClientErrorType.configError;

  const ClientError.serviceUnavailable({this.message, this.stackTrace})
      : type = ClientErrorType.serviceError;

  const ClientError.middlewareError({this.message, this.stackTrace})
      : type = ClientErrorType.middlewareError;

  final ClientErrorType type;

  final String? message;

  @override
  final StackTrace? stackTrace;

  @override
  String toString() => message ?? '$this';
}
