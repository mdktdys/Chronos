
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/new/models/day_schedule.dart';
import 'package:zameny_flutter/new/providers/day_schedules_provider.dart';

class Test extends ConsumerWidget {
  const Test({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(scheduleProvider);

    if (provider.isLoading || !provider.hasValue) {
      return const SliverToBoxAdapter(child: SizedBox());
    }
    
    if (provider.hasValue) {
      final empty = provider.value!.every((final DaySchedule element) => element.paras.isEmpty);

      if (empty) {
        return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Text('No data available')),
      ); 
      }
      else {
        const SliverToBoxAdapter(child: SizedBox(height: 90,));
      }
    }

    return const SliverToBoxAdapter(child: SizedBox());
  }
}
