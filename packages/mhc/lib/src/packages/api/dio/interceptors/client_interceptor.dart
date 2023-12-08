import '../../../../../mhc.dart';

class DioClientInterceptor<ERR> extends Interceptor {
  const DioClientInterceptor({required this.client});

  final DioServiceClient<ERR> client;
}
