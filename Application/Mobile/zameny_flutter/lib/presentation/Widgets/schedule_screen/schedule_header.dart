import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

final zamenaTimerProvider = FutureProvider.autoDispose<DateTime>((ref) async {
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

  void _startTimer(DateTime time) {
    _timer?.cancel(); // Отменяем текущий таймер, если он существует
    Duration duration = const Duration(seconds: 10) - DateTime.now().difference(time);
    if (duration.isNegative) {
      duration = const Duration(seconds: 10);
    }
    log('Timer set for ${duration.inSeconds} seconds');

    _timer = Timer(duration, () {
      ref.invalidate(zamenaTimerProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(zamenaTimerProvider);
    log(provider.toString());

    return provider.when(
      data: (data) {
        _startTimer(data);
        return CheckZamenaTimeDisplay(time: data,refreshing: provider.isRefreshing);
      },
      error: (e, o) {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('${time.hour}:${time.minute}',
                style: const TextStyle(fontFamily: 'Ubuntu'),),
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
            fontSize: 10,
            color: Theme.of(context)
                .colorScheme
                .inverseSurface
                .withOpacity(0.6),
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Расписание',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu',),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            // const ZamenaCheckTime(),
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      barrierColor: Colors.black.withOpacity(0.3),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      context: context,
                      builder: (context) => SizedBox(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: const Text(
                                      'Показать логи Talker',
                                      style: TextStyle(fontFamily: 'Ubuntu'),
                                    ),
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => TalkerScreen(
                                                talker:
                                                    GetIt.I.get<Talker>(),),),),
                                  ),
                                  // ListTile(
                                  //     title: Text(
                                  //       "Тест",
                                  //       style: TextStyle(
                                  //           color: Theme.of(context)
                                  //               .colorScheme
                                  //               .inversePrimary,
                                  //           fontFamily: 'Ubuntu'),
                                  //     ),
                                  //     onTap: () async {
                                  //       SupabaseClient supa = GetIt.I.get<SupabaseClient>();
                                  //       GetIt.I.get<Talker>().debug(await supa.rpc('test4',params: {'groupid' : 2464,'datestart': DateTime(2024,3,11).toIso8601String(), 'dateend':DateTime(2024,3,17).toIso8601String() }));
                                  //     }),
                                ],
                              ),
                            ),
                          ),);
                },
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  size: 36,
                  // color: Theme.of(context).primaryColorLight,
                ),),
          ],
        ),
      ],
    );
  }
}

            // GestureDetector(
            //   onTap: () {
            //     ref.read(drawerProvider).openDrawer();
            //   },
            //   child: SizedBox(
            //       width: 52,
            //       height: 52,
            //       child: Center(
            //           child: SvgPicture.asset(
            //         "assets/icon/vuesax_linear_note.svg",
            //         colorFilter: ColorFilter.mode(
            //             Theme.of(context).colorScheme.inverseSurface,
            //             BlendMode.srcIn),
            //         width: 32,
            //         height: 32,
            //       ))),
            // ),
            // GestureDetector(
            //   onTap: () {
            //     // ref.watch(norificationProvider).enableNotifications();
            //   },
            //   child: SizedBox(
            //       width: 52,
            //       height: 52,
            //       child: Center(
            //           child: SvgPicture.asset(
            //         "assets/icon/notification.svg",
            //         colorFilter: ColorFilter.mode(
            //             ref.watch(norificationProvider).fcmToken == null
            //                 ? Colors.transparent
            //                 : Colors.transparent,
            //             BlendMode.srcIn),
            //         width: 32,
            //         height: 32,
            //       ))),
            // ),