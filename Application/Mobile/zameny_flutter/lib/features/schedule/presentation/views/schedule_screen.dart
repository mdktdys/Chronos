import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/current_lesson_timer.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_date_header.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_header.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/search_result_header.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/new/models/day_schedule.dart';
import 'package:zameny_flutter/new/providers/day_schedules_provider.dart';
import 'package:zameny_flutter/new/widgets/skeletonized_provider.dart';
import 'package:zameny_flutter/services/Data.dart';
import 'package:zameny_flutter/shared/providers/main_provider.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart'  hide scheduleProvider;
import 'package:zameny_flutter/shared/widgets/top_banner.dart';

MyGlobals myGlobals = MyGlobals();

class MyGlobals {
  GlobalKey mainKey = GlobalKey<ScaffoldState>();
  GlobalKey get scaffoldKey => mainKey;
}

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final ScrollController scrollController;

    @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    scrollController.addListener((){
      ref.read(mainProvider).updateScrollDirection(scrollController.position.userScrollDirection);
    });
  }

  
  void refresh(final int teacher, final BuildContext context) {
    setState(() {});
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);

    if (ref.watch(searchItemProvider) == null) {
      return Align(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Constants.maxWidthDesktop),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Расписание',
                      textAlign: TextAlign.center,
                      style: context.styles.ubuntuPrimaryBold24,
                    ),
                  ),
                ),
                // Row(
                //   spacing: 20,
                //   children: [
                //     Expanded(
                //       child: BaseContainer(
                //         padding: const EdgeInsets.all(20),
                //         child: Column(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             SvgPicture.asset(Images.teacher),
                //             const Text('Группы')
                //           ],
                //         )
                //       ),
                //     ),
                //     Expanded(
                //       child: BaseContainer(
                //         padding: const EdgeInsets.all(20),
                //         child: Column(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             SvgPicture.asset(Images.teacher),
                //             const Text('Преподаватели')
                //           ],
                //         )
                //       ),
                //     ),
                //   ]
                // ),
                const Expanded(
                  child: SingleChildScrollView(
                    child: ScheduleTurboSearch(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      key: myGlobals.scaffoldKey,
      body: CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverList.list(
              children: [
                const TopBanner(),
                const SizedBox(height: 10),
                const ScheduleHeader(),
                const SizedBox(height: 10),
                const ScheduleTurboSearch(),
                const SizedBox(height: 10),
                const DateHeader(),
                const SizedBox(height: 10),
                // const CurrentLessonTimer(),
                const SizedBox(height: 10),
                // LessonView(scrollController: scrollController),
                const SearchResultHeader(),
                const SizedBox(height: 10),
                const ScheduleViewSettingsWidget(),
                const SizedBox(height: 10),
                ScheduleView(scrollController: scrollController),
              ]
            ),
          ),
          const Test()
        ]
      ),
    );
  }
}

class ScheduleViewSettingsWidget extends ConsumerWidget {
  const ScheduleViewSettingsWidget({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(scheduleSettingsProvider);
    final notifier = ref.watch(scheduleSettingsProvider.notifier);

    return Row(
    spacing: 8,
      children: [
        SizedBox(
          height: 38,
          child: FittedBox(
            child: Switch(
              value: provider.isShowZamena,
              onChanged: (final value) {
                provider.isShowZamena = !provider.isShowZamena;
                notifier.notify();
              },
          ),
        )),
        Text(
          'С заменами',
          style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}

class Test extends ConsumerWidget {
  const Test({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(scheduleProvider);

    if (provider.isLoading || !provider.hasValue) {
      return const SliverToBoxAdapter(child: SizedBox());
    }
    
    if (provider.hasValue) {
      final empty = provider.value!.every((final element) => element.paras.isEmpty);

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

class ScheduleView extends ConsumerWidget {
  final ScrollController scrollController;

  const ScheduleView({required this.scrollController, super.key,});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return SkeletonizedProvider(
      provider: scheduleProvider,
      fakeData: ScheduleNotifier.fake,
      error: (final o, final s) {
        return const Text('data');
      },
      data: (final data) {
        final empty = data.every((final element) => element.paras.isEmpty);

       if (empty) {
          return const SizedBox();
        }

        return ScheduleDaysWidget(days: data);
      },
    );
  }
}

class ScheduleDaysWidget extends StatelessWidget {
  final List<DaySchedule> days;

  const ScheduleDaysWidget({
    required this.days,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      spacing: 10,
      children: days.map((final day) {
        return DayScheduleWidget(daySchedule: day);
      }).toList()
    );
  }
}

// class LessonView extends ConsumerWidget {
//   final ScrollController scrollController;

//   const LessonView({
//     required this.scrollController,
//     super.key,
//   });

//   @override
//   Widget build(final BuildContext context, final WidgetRef ref) {
//     final scheduleState = ref.watch(riverpodScheduleProvider);

//     if (scheduleState.isLoading) {
//       return const LoadingWidget();
//     }

//     if (scheduleState.error != null) {
//       return FailedLoadWidget(error: scheduleState.error!);
//     }

//     return Column(
//       children: [
//         LessonList(
//           scrollController: scrollController,
//           zamenas: scheduleState.zamenas,
//           lessons: scheduleState.lessons,
//         ),
//       ],
//     );
//   }
// }

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
      highlightColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

// class LessonList extends ConsumerWidget {
//   final List<Lesson> lessons;
//   final List<Zamena> zamenas;
//   final ScrollController scrollController;

//   const LessonList({
//     required this.zamenas,
//     required this.lessons,
//     required this.scrollController,
//     super.key,
//   });

//   @override
//   Widget build(final BuildContext context, final WidgetRef ref) {
//     final provider = ref.watch(scheduleProvider);
//     final currentDay = DateTime.now().weekday;
//     final startDate = provider.navigationDate.subtract(Duration(days: provider.navigationDate.weekday - 1));

//     return ScheduleList(
//       context: context,
//       weekLessons: lessons,
//       zamenas: zamenas,
//       startDate: startDate,
//       currentDay: currentDay,
//       todayWeek: provider.todayWeek,
//       currentWeek: provider.currentWeek,
//     );
//   }
// }

// class ScheduleList extends ConsumerWidget {
//   final BuildContext context;
//   final List<Lesson> weekLessons;
//   final List<Zamena> zamenas;
//   final DateTime startDate;
//   final int currentDay;
//   final int todayWeek;
//   final int currentWeek;
  
//   const ScheduleList({
//     required this.context,
//     required this.weekLessons,
//     required this.zamenas,
//     required this.startDate,
//     required this.currentDay,
//     required this.todayWeek,
//     required this.currentWeek,
//     super.key,
//   });

//   @override
//   Widget build(final BuildContext context, final WidgetRef ref) {
//     final ScheduleProvider provider = ref.watch(scheduleProvider);
//     final SearchType searchType = provider.searchType;
//     final List<Widget> days = List.generate(6, (final iter) {
//       return ScheduleListWidget(
//         iter: iter,
//         weekLessons: weekLessons,
//         zamenas: zamenas,
//         searchType: searchType,
//         startDate: startDate,
//         currentDay: currentDay,
//         todayWeek: todayWeek,
//         currentWeek: currentWeek,
//       );
//     });
//     return Adaptive.isDesktop(context)
//       ? Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: days.map((final e) => Expanded(child: e)).toList(),
//         )
//       : Column(children: days);
//   }
// }

class ScheduleListWidget extends StatelessWidget {
  final int iter;
  final List<Lesson> weekLessons;
  final List<Zamena> zamenas;
  final SearchType searchType;
  final DateTime startDate;
  final int currentDay;
  final int todayWeek;
  final int currentWeek;

  const ScheduleListWidget({
    required this.iter,
    required this.weekLessons, 
    required this.zamenas, 
    required this.searchType, 
    required this.startDate, 
    required this.currentDay, 
    required this.todayWeek, 
    required this.currentWeek, 
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final day = iter + 1;
    List<Lesson> lessons = [];
    final Data data = GetIt.I.get<Data>();

    try {
      lessons = weekLessons.where((final lesson) => lesson.date.weekday == day).toList();
      lessons.sort((final a, final b) => a.number > b.number ? 1 : -1);
    } catch (e) {
      return const SizedBox.shrink();
    }

    final List<Zamena> dayZamenas = zamenas.where((final element) => element.date.weekday == day).toList();
    dayZamenas.sort((final a, final b) => a.lessonTimingsID > b.lessonTimingsID ? 1 : -1);

    return const SizedBox();

    //if ((dayZamenas.length + lessons.length) > 0) {
    // if (
    //   searchType == SearchType.group
    //   || searchType == SearchType.cabinet
    // ) {
    //   return DayScheduleWidget(
    //     key: ValueKey(day),
    //     day: day,
    //     dayZamenas: dayZamenas,
    //     lessons: lessons,
    //     startDate: startDate,
    //     data: data,
    //     currentDay: currentDay,
    //     todayWeek: todayWeek,
    //     currentWeek: currentWeek,
    //   );
    // } else if (
    //   searchType == SearchType.teacher
    // ) {
    //   return DayScheduleWidgetTeacher(
    //     key: ValueKey(day),
    //     day: day,
    //     dayZamenas: dayZamenas,
    //     lessons: lessons,
    //     startDate: startDate,
    //     data: data,
    //     currentDay: currentDay,
    //     todayWeek: todayWeek,
    //     currentWeek: currentWeek,
    //   );
    // }
    // return const SizedBox.shrink();
  }
}
