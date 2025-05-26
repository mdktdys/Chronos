// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zamena_groups_practice_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchPracticeGroupsByDateHash() =>
    r'3401062891af130f6239ee7cc6b8c0a7026dab80';

/// See also [fetchPracticeGroupsByDate].
@ProviderFor(fetchPracticeGroupsByDate)
final fetchPracticeGroupsByDateProvider = FutureProvider<List<Group>>.internal(
  fetchPracticeGroupsByDate,
  name: r'fetchPracticeGroupsByDateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchPracticeGroupsByDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchPracticeGroupsByDateRef = FutureProviderRef<List<Group>>;
String _$fetchTeacherCabinetSwapsHash() =>
    r'365cd518b7612c86f92ce5ceee3c402d8418b915';

/// See also [fetchTeacherCabinetSwaps].
@ProviderFor(fetchTeacherCabinetSwaps)
final fetchTeacherCabinetSwapsProvider =
    AutoDisposeFutureProvider<List<(Teacher, Cabinet)>>.internal(
      fetchTeacherCabinetSwaps,
      name: r'fetchTeacherCabinetSwapsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fetchTeacherCabinetSwapsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchTeacherCabinetSwapsRef =
    AutoDisposeFutureProviderRef<List<(Teacher, Cabinet)>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
