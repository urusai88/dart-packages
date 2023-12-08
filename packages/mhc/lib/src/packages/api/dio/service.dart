import '../../../../mhc.dart';

class DioService<E>
    extends BaseService<DioServiceClient<E>, E, DioResponseExtra> {
  const DioService({required super.client, this.path = '/'});

  final String path;
}
