import 'package:logging/logging.dart';
import 'package:riverpod/riverpod.dart';

class RiverpodLoggerProviderObserver extends ProviderObserver {
  const RiverpodLoggerProviderObserver({required this.debugMode});

  final bool debugMode;

  Logger get _logger => Logger('Riverpod');

  String? _getName(ProviderBase<Object?> provider) {
    if (provider.name == null && !debugMode) {
      return null;
    }
    if (provider.name == '_') {
      return null;
    }
    var name = provider.name ?? '${provider.runtimeType}';
    if (provider.argument != null) {
      name += '(${provider.argument})';
    }
    return name;
  }

  String _getValue(String value) {
    final match = RegExp(r"^Instance of '(.*)'$").firstMatch(value);
    if (match == null) {
      return value;
    }
    return match.group(1)!;
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    final name = _getName(provider);
    if (name == null || value == null) {
      return;
    }
    _logger.fine('provider: $name, value: ${_getValue('$value')}');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final name = _getName(provider);
    if (name == null || newValue == null) {
      return;
    }
    _logger.fine('provider: $name, newValue: ${_getValue('$newValue')}');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    final name = _getName(provider);
    if (name == null) {
      return;
    }
    _logger.fine('disposed: $name');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    final name = _getName(provider);
    if (name == null) {
      return;
    }
    _logger.warning('fail: $name\n$error\n$stackTrace');
  }
}
