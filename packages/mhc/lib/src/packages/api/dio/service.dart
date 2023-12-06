import 'client.dart';

class DioService<ErrorT> {
  const DioService({required this.client, this.path = '/'});

  final DioClient<ErrorT> client;
  final String path;
}
