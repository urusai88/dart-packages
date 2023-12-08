class BaseServiceClient<ERR, EXTRA> {
  const BaseServiceClient();
}

abstract class BaseService<C extends BaseServiceClient<ERR, EXTRA>, ERR,
    EXTRA> {
  const BaseService({required this.client});

  final C client;
}
