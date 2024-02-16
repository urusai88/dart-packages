// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processing_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$processingHash() => r'9a4ad77310cca2dd6a3a3857bc2a98ba6ea461ba';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Processing extends BuildlessAutoDisposeNotifier<bool> {
  late final String arg;

  bool build(
    String arg,
  );
}

/// See also [Processing].
@ProviderFor(Processing)
const processingProvider = ProcessingFamily();

/// See also [Processing].
class ProcessingFamily extends Family<bool> {
  /// See also [Processing].
  const ProcessingFamily();

  /// See also [Processing].
  ProcessingProvider call(
    String arg,
  ) {
    return ProcessingProvider(
      arg,
    );
  }

  @override
  ProcessingProvider getProviderOverride(
    covariant ProcessingProvider provider,
  ) {
    return call(
      provider.arg,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'processingProvider';
}

/// See also [Processing].
class ProcessingProvider
    extends AutoDisposeNotifierProviderImpl<Processing, bool> {
  /// See also [Processing].
  ProcessingProvider(
    String arg,
  ) : this._internal(
          () => Processing()..arg = arg,
          from: processingProvider,
          name: r'processingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$processingHash,
          dependencies: ProcessingFamily._dependencies,
          allTransitiveDependencies:
              ProcessingFamily._allTransitiveDependencies,
          arg: arg,
        );

  ProcessingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.arg,
  }) : super.internal();

  final String arg;

  @override
  bool runNotifierBuild(
    covariant Processing notifier,
  ) {
    return notifier.build(
      arg,
    );
  }

  @override
  Override overrideWith(Processing Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProcessingProvider._internal(
        () => create()..arg = arg,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        arg: arg,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Processing, bool> createElement() {
    return _ProcessingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProcessingProvider && other.arg == arg;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, arg.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProcessingRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `arg` of this provider.
  String get arg;
}

class _ProcessingProviderElement
    extends AutoDisposeNotifierProviderElement<Processing, bool>
    with ProcessingRef {
  _ProcessingProviderElement(super.provider);

  @override
  String get arg => (origin as ProcessingProvider).arg;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
