import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/new/providers/zamena_timer_provider.dart';
import 'package:zameny_flutter/widgets/check_zamena_time_display.dart';

class ZamenaCheckTime extends ConsumerStatefulWidget {
  const ZamenaCheckTime({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZamenaCheckTimeState();
}

class _ZamenaCheckTimeState extends ConsumerState<ZamenaCheckTime> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(final DateTime time) {
    _timer?.cancel();
    Duration duration = const Duration(minutes: 5) - DateTime.now().difference(time);
    if (duration.isNegative) {
      duration = const Duration(seconds: 5);
    }

    _timer = Timer(duration, () {
      ref.invalidate(zamenaTimerProvider);
    });
  }

  @override
  Widget build(final BuildContext context) {
    final provider = ref.watch(zamenaTimerProvider);

    return provider.when(
      data: (final DateTime data) {
        _startTimer(data);
        return CheckZamenaTimeDisplay(
          refreshing: provider.isRefreshing,
          time: data.toLocal(),
        );
      },
      error: (final e, final o) {
        return const Text('Ошибка');
      },
      loading: () {
        return const SizedBox.shrink();
      },
    );
  }
}
