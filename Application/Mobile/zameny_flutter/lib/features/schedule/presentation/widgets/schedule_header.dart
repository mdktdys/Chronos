import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/new/widgets/frame_less_button.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';

final zamenaTimerProvider = FutureProvider.autoDispose<DateTime>((final ref) async {
  final res = await GetIt.I.get<SupabaseClient>().from('checks').select().order('id').limit(1);
  return DateTime.parse(res[0]['updated_at']);
});

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
    _timer?.cancel(); // Отменяем текущий таймер, если он существует
    Duration duration = const Duration(minutes: 5) - DateTime.now().difference(time);
    if (duration.isNegative) {
      duration = const Duration(seconds: 5);
    }
    log('Timer set for ${duration.inSeconds} seconds');

    _timer = Timer(duration, () {
      ref.invalidate(zamenaTimerProvider);
    });
  }

  @override
  Widget build(final BuildContext context) {
    final provider = ref.watch(zamenaTimerProvider);
    log(provider.toString());

    return provider.when(
      data: (final data) {
        _startTimer(data);
        return CheckZamenaTimeDisplay(time: data,refreshing: provider.isRefreshing);
      },
      error: (final e, final o) {
        return const Text('Ошибка');
      },
      loading: () {
        return const Text('Загрузка...');
      },
    );
  }
}

class CheckZamenaTimeDisplay extends StatelessWidget {
  final DateTime time;
  final bool refreshing;

  const CheckZamenaTimeDisplay({required this.time, required this.refreshing, super.key});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text(
              '${time.hour}:${time.minute}',
              style: TextStyle(fontFamily: 'Ubuntu',color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6), fontSize: 14),
            ),
            refreshing? 
            const SizedBox(
              height: 10,
              width: 10,
              child: CircularProgressIndicator(),) : const SizedBox(),
          ],
        ),
        Text(
          refreshing? 'Проверяю' : 'Проверено',
          style: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 14,
            color: Theme.of(context)
                .colorScheme
                .inverseSurface
                .withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class ScheduleHeader extends ConsumerStatefulWidget {
  const ScheduleHeader({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleHeaderState();
}

class _ScheduleHeaderState extends ConsumerState<ScheduleHeader> {
  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FrameLessButton(
            child: Image.asset('assets/icon/whale.png'),
            onClicked: () async {
              ref.read(searchItemProvider.notifier).setState(null);
            },
          ),
          Expanded(
            child: Text(
              'Расписание',
              textAlign: TextAlign.center,
              style: context.styles.ubuntuPrimaryBold24,
            ),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                barrierColor: Colors.black.withValues(alpha: 0.3),
                backgroundColor: Theme.of(context).colorScheme.surface,
                context: context,
                builder: (final context) => SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            'Показать логи Talker',
                            style: context.styles.ubuntu,
                          ),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (final context) => TalkerScreen(talker:GetIt.I.get<Talker>()))),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.more_horiz_rounded,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}
