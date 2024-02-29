import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/tools.dart';
import 'package:zameny_flutter/presentation/Providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/presentation/Providers/schedule_provider.dart';
import 'package:zameny_flutter/presentation/Providers/search_provider.dart';
import 'package:zameny_flutter/presentation/Providers/theme_provider.dart';
import 'package:zameny_flutter/presentation/Screens/schedule_screen/schedule_date_header/schedule_date_header.dart';
import 'package:zameny_flutter/presentation/Screens/schedule_screen/schedule_header/schedule_header.dart';
import 'package:zameny_flutter/presentation/Screens/schedule_screen/schedule_header/schedule_turbo_search.dart';
import 'package:zameny_flutter/presentation/Widgets/CourseTile.dart';
import 'package:zameny_flutter/presentation/Widgets/failed_load_widget.dart';
import 'package:zameny_flutter/presentation/Widgets/loading_widget.dart';
import 'package:zameny_flutter/presentation/Widgets/search_banner_message_widget.dart';
import 'package:zameny_flutter/presentation/Widgets/search_result_header.dart';

MyGlobals myGlobals = MyGlobals();

class MyGlobals {
  GlobalKey mainKey = GlobalKey<ScaffoldState>();
  GlobalKey get scaffoldKey => mainKey;
}

class ScheduleWrapper extends StatelessWidget {
  const ScheduleWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SearchProvider(context)),
        ChangeNotifierProvider(create: (context) => ScheduleProvider(context)),
      ],
      builder: (context, child) {
        context.read<ScheduleBloc>().add(LoadInitial(context: context));
        return const ScheduleScreen();
      },
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  refresh(int teacher, BuildContext context) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeProvider themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor: themeProvider.theme.colorScheme.background,
      key: myGlobals.scaffoldKey,
      body: CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const ScheduleHeader(),
                  const SizedBox(height: 10),
                  const ScheduleTurboSearch(),
                  const SizedBox(height: 10),
                  const DateHeader(),
                  const SizedBox(height: 10),
                  BlocBuilder<ScheduleBloc, ScheduleState>(
                    builder: (context, state) {
                      GetIt.I.get<Talker>().good(state);
                      if (state is ScheduleLoaded) {
                        return const SearchResultHeader();
                      } else if (state is ScheduleFailedLoading) {
                        return const SizedBox();
                      } else if (state is ScheduleLoading) {
                        return const ShimmerContainer();
                      } else if (state is ScheduleInitial) {
                        return const SizedBox();
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: BlocBuilder<ScheduleBloc, ScheduleState>(
              builder: (context, state) {
                if (state is ScheduleLoaded) {
                  return SliverToBoxAdapter(
                    child: LessonList(
                      refresh: refresh,
                      zamenas: state.zamenas,
                      lessons: state.lessons,
                    ),
                  );
                } else if (state is ScheduleFailedLoading) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    fillOverscroll: true,
                    child: FailedLoadWidget(
                      error: state.error,
                    ),
                  );
                } else if (state is ScheduleLoading) {
                  return const SliverToBoxAdapter(
                    child: LoadingWidget(),
                  );
                } else if (state is ScheduleInitial) {
                  return SliverFillRemaining(
                      child: Center(
                    child: Text(
                        "Тыкни на поиск!\nвыбери группу, препода или кабинет",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            fontFamily: 'Ubuntu',
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ));
                } else {
                  return const SliverFillRemaining(child: SizedBox());
                }
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
            ),
          )
        ],
      ),
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        highlightColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
        ));
  }
}

class LessonList extends StatelessWidget {
  final List<Lesson> lessons;
  final List<Zamena> zamenas;
  final Function refresh;

  const LessonList({
    super.key,
    required this.refresh,
    required this.zamenas,
    required this.lessons,
  });

  @override
  Widget build(BuildContext context) {
    ScheduleProvider provider = context.watch<ScheduleProvider>();
    final currentDay = DateTime.now().weekday;
    final data = GetIt.I.get<Data>();
    final startDate = provider.navigationDate
        .subtract(Duration(days: provider.navigationDate.weekday - 1));

    return Column(children: [
      zamenas.isNotEmpty ? const SizedBox() : const SearchBannerMessageWidget(),
      ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: ScheduleList(
            refresh,
            lessons,
            data,
            provider.groupIDSeek,
            zamenas,
            startDate,
            currentDay,
            provider.todayWeek,
            provider.currentWeek,
          )),
    ]);
  }
}

List<Widget> ScheduleList(
    Function refresh,
    List<Lesson> weekLessons,
    Data data,
    int groupID,
    List<Zamena> zamenas,
    DateTime startDate,
    int currentDay,
    todayWeek,
    currentWeek) {
  return List.generate(6, (iter) {
    final day = iter + 1;
    List<Lesson> lessons = [];
    try {
      lessons =
          weekLessons.where((lesson) => lesson.date.weekday == day).toList();
      lessons.sort((a, b) => a.number > b.number ? 1 : -1);
    } catch (e) {
      return const SizedBox();
    }

    List<Zamena> DayZamenas =
        zamenas.where((element) => element.date.weekday == day).toList();
    DayZamenas.sort((a, b) => a.LessonTimingsID > b.LessonTimingsID ? 1 : -1);
    if ((DayZamenas.length + lessons.length) > 0) {
      return DayScheduleWidget(
        refresh: refresh,
        day: day,
        DayZamenas: DayZamenas,
        lessons: lessons,
        startDate: startDate,
        data: data,
        currentDay: currentDay,
        todayWeek: todayWeek,
        currentWeek: currentWeek,
      );
    } else {
      return const SizedBox();
    }
  });
}

class DayScheduleWidget extends StatelessWidget {
  final DateTime startDate;
  final int currentDay;
  final int currentWeek;
  final int todayWeek;
  final Data data;
  final Function refresh;
  final int day;
  final List<Zamena> DayZamenas;
  final List<Lesson> lessons;

  const DayScheduleWidget(
      {super.key,
      required this.day,
      required this.refresh,
      required this.DayZamenas,
      required this.lessons,
      required this.startDate,
      required this.currentDay,
      required this.currentWeek,
      required this.todayWeek,
      required this.data});

  @override
  Widget build(BuildContext context) {
    bool isToday =
        (day == currentDay && todayWeek == currentWeek ? true : false);
    //ScheduleProvider provider = context.watch<ScheduleProvider>();
    SearchType type = context.watch<ScheduleProvider>().searchType;
    bool fullSwap = false;
    if (type == SearchType.group) {
      int searchDay = startDate.add(Duration(days: day - 1)).day;
      int searchMonth = startDate.add(Duration(days: day - 1)).month;
      int searchYear = startDate.add(Duration(days: day - 1)).year;
      fullSwap = GetIt.I
          .get<Data>()
          .zamenasFull
          .where((element) =>
              (element.group == lessons[0].group) &&
              (element.date.day == searchDay) &&
              (element.date.month == searchMonth) &&
              (element.date.year == searchYear))
          .toSet()
          .isNotEmpty;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: isToday
          ? BoxDecoration(
              border: Border.all(
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(20)))
          : null,
      child: Column(
        children: [
          DayScheduleHeader(
              day: day,
              startDate: startDate,
              isToday: isToday,
              fullSwap: fullSwap),
          Column(
              children: data.timings.map((para) {
            if (fullSwap) {
              Lesson? removedPara = lessons
                  .where((element) => element.number == para.number)
                  .firstOrNull;
              if (removedPara != null) {
                return SizedBox();
              }
              Zamena? zamena = DayZamenas.where(
                      (element) => element.LessonTimingsID == para.number)
                  .firstOrNull;
              if (zamena != null) {
                final course = getCourseById(zamena.courseID) ??
                    Course(id: -1, name: "err2", color: "100,0,0,0");
                return CourseTile(
                  type: type,
                  course: course,
                  refresh: refresh,
                  swaped: null,
                  lesson: Lesson(
                      id: -1,
                      course: course.id,
                      cabinet: zamena.cabinetID,
                      number: zamena.LessonTimingsID,
                      teacher: zamena.teacherID,
                      group: zamena.groupID,
                      date: zamena.date),
                );
              }
              return SizedBox();
            } else {
              if (DayZamenas.any(
                  (element) => element.LessonTimingsID == para.number)) {
                Lesson? swapedPara = lessons
                    .where((element) => element.number == para.number)
                    .firstOrNull;
                Zamena zamena = DayZamenas.where(
                    (element) => element.LessonTimingsID == para.number).first;
                final course = getCourseById(zamena.courseID) ??
                    Course(id: -1, name: "err2", color: "100,0,0,0");
                return CourseTile(
                  type: type,
                  course: course,
                  refresh: refresh,
                  lesson: Lesson(
                      id: -1,
                      course: course.id,
                      cabinet: zamena.cabinetID,
                      number: zamena.LessonTimingsID,
                      teacher: zamena.teacherID,
                      group: zamena.groupID,
                      date: zamena.date),
                  swaped: swapedPara,
                );
              } else {
                if (lessons.any((element) => element.number == para.number)) {
                  Lesson lesson = lessons
                      .where((element) => element.number == para.number)
                      .first;
                  final course = getCourseById(lesson.course) ??
                      Course(id: -1, name: "err3", color: "50,0,0,1");
                  return CourseTile(
                    type: type,
                    course: course,
                    lesson: lesson,
                    swaped: null,
                    refresh: refresh,
                  );
                }
              }
            }
            return SizedBox();
          }).toList())
        ],
      ),
    );
  }
}

class DayScheduleHeader extends StatelessWidget {
  final bool? fullSwap;
  const DayScheduleHeader(
      {super.key,
      required this.day,
      required this.startDate,
      required this.isToday,
      this.fullSwap});

  final int day;
  final DateTime startDate;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getDayName(day),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontSize: 24,
                      fontFamily: 'Ubuntu'),
                ),
                Text(
                  "${getMonthName(startDate.add(Duration(days: day - 1)).month)} ${startDate.add(Duration(days: day - 1)).day}",
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.7),
                      fontSize: 18,
                      fontFamily: 'Ubuntu'),
                ),
              ],
            ),
          ),
          fullSwap == true
              ? Text(
                  "Полная замена",
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.7),
                      fontSize: 18,
                      fontFamily: 'Ubuntu'),
                )
              : const SizedBox(),
          const SizedBox(
            width: 5,
          ),
          isToday
              ? Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 30, 118, 233),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Сегодня",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
