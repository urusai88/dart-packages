import '../../../../mhc.dart';

class DioService<E /*, ExtraT*/ >
    extends BaseService<DioClient<E>, E, DioResponseExtra> {
  const DioService({required super.client, this.path = '/'});

  final String path;
}
