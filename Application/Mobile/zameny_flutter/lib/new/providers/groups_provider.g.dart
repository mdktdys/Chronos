// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$courseHash() => r'09b115c1cfa7045ddad27d87bd881fea98acf82a';

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

/// See also [course].
@ProviderFor(course)
const courseProvider = CourseFamily();

/// See also [course].
class CourseFamily extends Family<Course?> {
  /// See also [course].
  const CourseFamily();

  /// See also [course].
  CourseProvider call(
    int id,
  ) {
    return CourseProvider(
      id,
    );
  }

  @override
  CourseProvider getProviderOverride(
    covariant CourseProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'courseProvider';
}

/// See also [course].
class CourseProvider extends AutoDisposeProvider<Course?> {
  /// See also [course].
  CourseProvider(
    int id,
  ) : this._internal(
          (ref) => course(
            ref as CourseRef,
            id,
          ),
          from: courseProvider,
          name: r'courseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$courseHash,
          dependencies: CourseFamily._dependencies,
          allTransitiveDependencies: CourseFamily._allTransitiveDependencies,
          id: id,
        );

  CourseProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    Course? Function(CourseRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CourseProvider._internal(
        (ref) => create(ref as CourseRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Course?> createElement() {
    return _CourseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CourseRef on AutoDisposeProviderRef<Course?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _CourseProviderElement extends AutoDisposeProviderElement<Course?>
    with CourseRef {
  _CourseProviderElement(super.provider);

  @override
  int get id => (origin as CourseProvider).id;
}

String _$coursesHash() => r'28fcf22cb65c3262c3a2e07d29244faec86fd80c';

/// See also [courses].
@ProviderFor(courses)
final coursesProvider = FutureProvider<List<Course>>.internal(
  courses,
  name: r'coursesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$coursesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CoursesRef = FutureProviderRef<List<Course>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
