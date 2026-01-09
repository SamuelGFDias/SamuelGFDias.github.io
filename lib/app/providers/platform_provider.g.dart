// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$platformHash() => r'a11a57e6f3acc883b715c0a11eb32cca678d6d71';

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

/// See also [platform].
@ProviderFor(platform)
const platformProvider = PlatformFamily();

/// See also [platform].
class PlatformFamily extends Family<PlatformType> {
  /// See also [platform].
  const PlatformFamily();

  /// See also [platform].
  PlatformProvider call(double width, double height) {
    return PlatformProvider(width, height);
  }

  @override
  PlatformProvider getProviderOverride(covariant PlatformProvider provider) {
    return call(provider.width, provider.height);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'platformProvider';
}

/// See also [platform].
class PlatformProvider extends Provider<PlatformType> {
  /// See also [platform].
  PlatformProvider(double width, double height)
    : this._internal(
        (ref) => platform(ref as PlatformRef, width, height),
        from: platformProvider,
        name: r'platformProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$platformHash,
        dependencies: PlatformFamily._dependencies,
        allTransitiveDependencies: PlatformFamily._allTransitiveDependencies,
        width: width,
        height: height,
      );

  PlatformProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.width,
    required this.height,
  }) : super.internal();

  final double width;
  final double height;

  @override
  Override overrideWith(PlatformType Function(PlatformRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: PlatformProvider._internal(
        (ref) => create(ref as PlatformRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        width: width,
        height: height,
      ),
    );
  }

  @override
  ProviderElement<PlatformType> createElement() {
    return _PlatformProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlatformProvider &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, width.hashCode);
    hash = _SystemHash.combine(hash, height.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlatformRef on ProviderRef<PlatformType> {
  /// The parameter `width` of this provider.
  double get width;

  /// The parameter `height` of this provider.
  double get height;
}

class _PlatformProviderElement extends ProviderElement<PlatformType>
    with PlatformRef {
  _PlatformProviderElement(super.provider);

  @override
  double get width => (origin as PlatformProvider).width;
  @override
  double get height => (origin as PlatformProvider).height;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
