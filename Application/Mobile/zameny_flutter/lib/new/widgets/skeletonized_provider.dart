
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizedProvider<T> extends ConsumerWidget {
  final Widget Function(Object, StackTrace) error;
  final AsyncNotifierProvider provider;
  final Widget Function(T) data;
  final T Function() fakeData;

  const SkeletonizedProvider({
    required this.provider,
    required this.fakeData,
    required this.error,
    required this.data,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AsyncValue value = ref.watch(provider);

    return Skeletonizer(
      enableSwitchAnimation: true,
      enabled: value.isLoading,
      child: value.when(
        data: (final data_) => data(data_),
        error: error, loading: () => data(fakeData())
      )
    );
  }
}

class SkeletonizedSliver<T> extends ConsumerWidget {
  final Widget Function(Object, StackTrace) error;
  final AsyncNotifierProvider provider;
  final Widget Function(T) data;
  final T Function() fakeData;

  const SkeletonizedSliver({
    required this.provider,
    required this.fakeData,
    required this.error,
    required this.data,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AsyncValue value = ref.watch(provider);

    return Skeletonizer.sliver(
      enabled: value.isLoading,
      child: value.when(
        data: (final data_) => data(data_),
        error: error, loading: () => data(fakeData())
      )
    );
  }
}