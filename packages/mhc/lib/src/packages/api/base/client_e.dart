class ClientException implements Exception {
  const ClientException([
    this.message,
    this.innerException,
    this.innerStackTrace,
  ]);

  final String? message;

  final Exception? innerException;

  final StackTrace? innerStackTrace;

  @override
  String toString() =>
      message ?? innerException?.toString() ?? 'ClientException()';
}

enum ClientErrorType {
  serviceUnavailable,
  middlewareError,
  wrongConfiguration,
}

class ClientError implements Error {
  const ClientError({
    required this.type,
    this.stackTrace,
  });

  const ClientError.serviceUnavailable()
      : type = ClientErrorType.serviceUnavailable,
        stackTrace = null;

  const ClientError.wrongConfiguration()
      : type = ClientErrorType.wrongConfiguration,
        stackTrace = null;

  const ClientError.middlewareError()
      : type = ClientErrorType.middlewareError,
        stackTrace = null;

  final ClientErrorType type;

  @override
  final StackTrace? stackTrace;
}
