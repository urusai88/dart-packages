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
  badConfig,
}

class ClientError implements Error {
  const ClientError({
    required this.type,
    this.stackTrace,
  });

  const ClientError.serviceUnavailable({this.stackTrace})
      : type = ClientErrorType.serviceUnavailable;

  const ClientError.badConfig({this.stackTrace})
      : type = ClientErrorType.badConfig;

  const ClientError.middlewareError({this.stackTrace})
      : type = ClientErrorType.middlewareError;

  final ClientErrorType type;

  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    return '$type\n$stackTrace';
  }
}
