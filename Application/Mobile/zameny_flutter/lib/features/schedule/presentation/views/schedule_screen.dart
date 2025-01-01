import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';

import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/current_lesson_timer.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/dayschedule_teacher_widget.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_date_header.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_header.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/search_result_header.dart';
import 'package:zameny_flutter/features/timetable/timetable_screen.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/shared/providers/adaptive.dart';
import 'package:zameny_flutter/shared/providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/shared/providers/main_provider.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';
import 'package:zameny_flutter/shared/widgets/failed_load_widget.dart';
import 'package:zameny_flutter/shared/widgets/loading_widget.dart';
import 'package:zameny_flutter/shared/widgets/top_banner.dart';

MyGlobals myGlobals = MyGlobals();

class MyGlobals {
  GlobalKey mainKey = GlobalKey<ScaffoldState>();
  GlobalKey get scaffoldKey => mainKey;
}

class ScheduleWrapper extends ConsumerWidget {
  const ScheduleWrapper({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
      context.read<ScheduleBloc>().add(LoadInitial(context: context,ref: ref));
      return const ScreenAppearBuilder(child: ScheduleScreen());
  }
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
    return Scaffold(
      key: myGlobals.scaffoldKey,
      body: SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(children: [
                const TopBanner(),
                const SizedBox(height: 10),
                const ScheduleHeader(),
                const SizedBox(height: 10),
                const ScheduleTurboSearch(),
                const SizedBox(height: 10),
                const DateHeader(),
                const CurrentLessonTimer(),
                const SizedBox(height: 10),
                LessonView(
                  scrollController: scrollController,
                  refresh: (){},
                ),
                const SizedBox(height: 100),
              ],),
            ),
          ),
        ),
      );
  }
}

class LessonView extends StatelessWidget {
  final ScrollController scrollController;
  final Function refresh;

  const LessonView({
    required this.scrollController,
    required this.refresh,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (final context, final state) {
      return AnimatedSwitcher(
        reverseDuration: const Duration(milliseconds: 300),
        duration: const Duration(milliseconds: 300),
        child: Builder(
          key: ValueKey<ScheduleState>(state),
          builder: (final BuildContext context) {
            if (state is ScheduleLoaded) {
              return Column(
                children: [
                  const SearchResultHeader(),
                  LessonList(
                    scrollController: scrollController,
                    zamenas: state.zamenas,
                    lessons: state.lessons,
                    refresh: refresh,
                  ),
                ],
              );
            } else if (state is ScheduleFailedLoading) {
              return FailedLoadWidget(
                error: state.error,
              );
            } else if (state is ScheduleLoading) {
              return const LoadingWidget();
            } else if (state is ScheduleInitial) {
              return SizedBox(
                height: 500,
                child: Center(
                  child: Text(
                    'Тыкни на поиск!\nвыбери группу, преподавателя или кабинет',
                    textAlign: TextAlign.center,
                    style: context.styles.ubuntuInverseSurfaceBold24,
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),);
    },);
  }
}

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

class LessonList extends ConsumerWidget {
  final List<Lesson> lessons;
  final List<Zamena> zamenas;
  final Function refresh;
  final ScrollController scrollController;

  const LessonList({
    required this.refresh,
    required this.zamenas,
    required this.lessons,
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(scheduleProvider);
    final currentDay = DateTime.now().weekday;
    final startDate = provider.navigationDate.subtract(Duration(days: provider.navigationDate.weekday - 1));

    return ScheduleList(
      context: context,
      refresh: refresh,
      weekLessons: lessons,
      zamenas: zamenas,
      startDate: startDate,
      currentDay: currentDay,
      todayWeek: provider.todayWeek,
      currentWeek: provider.currentWeek,
    );
  }
}

class ScheduleList extends ConsumerWidget {
  final BuildContext context;
  final Function refresh;
  final List<Lesson> weekLessons;
  final List<Zamena> zamenas;
  final DateTime startDate;
  final int currentDay;
  final int todayWeek;
  final int currentWeek;
  
  const ScheduleList({
    required this.context,
    required this.refresh,
    required this.weekLessons,
    required this.zamenas,
    required this.startDate,
    required this.currentDay,
    required this.todayWeek,
    required this.currentWeek,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ScheduleProvider provider = ref.watch(scheduleProvider);
    final SearchType searchType = provider.searchType;
    final List<Widget> days = List.generate(6, (final iter) {
      return ScheduleListWidget(
        iter: iter,
        weekLessons: weekLessons,
        zamenas: zamenas,
        searchType: searchType,
        refresh: refresh,
        startDate: startDate,
        currentDay: currentDay,
        todayWeek: todayWeek,
        currentWeek: currentWeek,
      );
    });
    return Adaptive.isDesktop(context)
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: days.map((final e) => Expanded(child: e)).toList(),
        )
      : Column(children: days);
  }
}

class ScheduleListWidget extends StatelessWidget {
  final int iter;
  final List<Lesson> weekLessons;
  final List<Zamena> zamenas;
  final SearchType searchType;
  final Function refresh;
  final DateTime startDate;
  final int currentDay;
  final int todayWeek;
  final int currentWeek;

  const ScheduleListWidget({
    required this.iter,
    required this.weekLessons, 
    required this.zamenas, 
    required this.searchType, 
    required this.refresh, 
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

    //if ((dayZamenas.length + lessons.length) > 0) {
    if (
      searchType == SearchType.group
      || searchType == SearchType.cabinet
    ) {
      return DayScheduleWidget(
        key: ValueKey(day),
        refresh: refresh,
        day: day,
        dayZamenas: dayZamenas,
        lessons: lessons,
        startDate: startDate,
        data: data,
        currentDay: currentDay,
        todayWeek: todayWeek,
        currentWeek: currentWeek,
      );
    } else if (
      searchType == SearchType.teacher
    ) {
      return DayScheduleWidgetTeacher(
        key: ValueKey(day),
        refresh: refresh,
        day: day,
        dayZamenas: dayZamenas,
        lessons: lessons,
        startDate: startDate,
        data: data,
        currentDay: currentDay,
        todayWeek: todayWeek,
        currentWeek: currentWeek,
      );
    }
    return const SizedBox.shrink();
  }
}
