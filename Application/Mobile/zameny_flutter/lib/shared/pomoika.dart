
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

// class ShimmerContainer extends StatelessWidget {
//   const ShimmerContainer({
//     super.key,
//   });

//   @override
//   Widget build(final BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
//       highlightColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
//       child: Container(
//         height: 60,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
//         ),
//       ),
//     );
//   }
// }

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

// class ScheduleListWidget extends StatelessWidget {
//   final int iter;
//   final List<Lesson> weekLessons;
//   final List<Zamena> zamenas;
//   final SearchType searchType;
//   final DateTime startDate;
//   final int currentDay;
//   final int todayWeek;
//   final int currentWeek;

//   const ScheduleListWidget({
//     required this.iter,
//     required this.weekLessons, 
//     required this.zamenas, 
//     required this.searchType, 
//     required this.startDate, 
//     required this.currentDay, 
//     required this.todayWeek, 
//     required this.currentWeek, 
//     super.key,
//   });

//   @override
//   Widget build(final BuildContext context) {
//     final day = iter + 1;
//     List<Lesson> lessons = [];
//     final Data data = GetIt.I.get<Data>();

//     try {
//       lessons = weekLessons.where((final lesson) => lesson.date.weekday == day).toList();
//       lessons.sort((final a, final b) => a.number > b.number ? 1 : -1);
//     } catch (e) {
//       return const SizedBox.shrink();
//     }

//     final List<Zamena> dayZamenas = zamenas.where((final element) => element.date.weekday == day).toList();
//     dayZamenas.sort((final a, final b) => a.lessonTimingsID > b.lessonTimingsID ? 1 : -1);

//     return const SizedBox();

//     //if ((dayZamenas.length + lessons.length) > 0) {
//     // if (
//     //   searchType == SearchType.group
//     //   || searchType == SearchType.cabinet
//     // ) {
//     //   return DayScheduleWidget(
//     //     key: ValueKey(day),
//     //     day: day,
//     //     dayZamenas: dayZamenas,
//     //     lessons: lessons,
//     //     startDate: startDate,
//     //     data: data,
//     //     currentDay: currentDay,
//     //     todayWeek: todayWeek,
//     //     currentWeek: currentWeek,
//     //   );
//     // } else if (
//     //   searchType == SearchType.teacher
//     // ) {
//     //   return DayScheduleWidgetTeacher(
//     //     key: ValueKey(day),
//     //     day: day,
//     //     dayZamenas: dayZamenas,
//     //     lessons: lessons,
//     //     startDate: startDate,
//     //     data: data,
//     //     currentDay: currentDay,
//     //     todayWeek: todayWeek,
//     //     currentWeek: currentWeek,
//     //   );
//     // }
//     // return const SizedBox.shrink();
//   }
// }
