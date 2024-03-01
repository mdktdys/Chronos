import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/Models/zamenaFileLink.dart';
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
          children: scheduleList(
            context,
            refresh,
            lessons,
            data,
            zamenas,
            startDate,
            currentDay,
            provider.todayWeek,
            provider.currentWeek,
          )),
    ]);
  }
}

List<Widget> scheduleList(
    BuildContext context,
    Function refresh,
    List<Lesson> weekLessons,
    Data data,
    List<Zamena> zamenas,
    DateTime startDate,
    int currentDay,
    todayWeek,
    currentWeek) {
  ScheduleProvider provider = context.watch<ScheduleProvider>();
  SearchType searchType = provider.searchType;
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

    List<Zamena> dayZamenas =
        zamenas.where((element) => element.date.weekday == day).toList();
    dayZamenas.sort((a, b) => a.lessonTimingsID > b.lessonTimingsID ? 1 : -1);

    if ((dayZamenas.length + lessons.length) > 0) {
      if (searchType == SearchType.group || searchType == SearchType.cabinet) {
        return DayScheduleWidget(
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
      } else if (searchType == SearchType.teacher) {
        return DayScheduleWidgetTeacher(
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
      return const SizedBox();
    } else {
      return const SizedBox();
    }
  });
}

class DayScheduleWidgetTeacher extends StatelessWidget {
  final DateTime startDate;
  final int currentDay;
  final int currentWeek;
  final int todayWeek;
  final Data data;
  final Function refresh;
  final int day;
  final List<Zamena> dayZamenas;
  final List<Lesson> lessons;
  const DayScheduleWidgetTeacher(
      {super.key,
      required this.startDate,
      required this.currentDay,
      required this.currentWeek,
      required this.todayWeek,
      required this.data,
      required this.refresh,
      required this.day,
      required this.dayZamenas,
      required this.lessons});

  @override
  Widget build(BuildContext context) {
    bool isToday =
        (day == currentDay && todayWeek == currentWeek ? true : false);

    ScheduleProvider provider = context.watch<ScheduleProvider>();

    int todayYear = startDate.add(Duration(days: day - 1)).year;
    int todayMonth = startDate.add(Duration(days: day - 1)).month;
    int todayDay = startDate.add(Duration(days: day - 1)).day;

    Set<ZamenaFull> fullzamenas = GetIt.I
        .get<Data>()
        .zamenasFull
        .where((element) =>
            element.date.day == todayDay &&
            element.date.month == todayMonth &&
            element.date.year == todayYear)
        .toSet();
    int teacherID = provider.teacherIDSeek;
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
          DayScheduleHeader(day: day, startDate: startDate, isToday: isToday),
          Column(
              children: data.timings.map((para) {
            //проверяю есть ли замена затрагивающих этого препода либо группы в которых он ведет по дефолту
            if (dayZamenas.any(
                (element) => element.lessonTimingsID == para.number)) {
              //если есть любая замена в этот день, неважно дети или препод
              Zamena? zamena = dayZamenas.where(
                  (element) => element.lessonTimingsID == para.number).first;
              //если это замена детей и она не меняет на моего препода
              if (zamena.teacherID != teacherID) {
                //пытаюсь поставить дефолтную пару препода
                //проверяю не состоит ли эта пара в полной замене
                if (lessons.any((element) => element.number == para.number)) {
                  Lesson lesson = lessons
                      .where((element) => element.number == para.number)
                      .first;
                  final course = getCourseById(lesson.course) ??
                      Course(id: -1, name: "err3", color: "50,0,0,1");

                  //проверяю не состоит ли группа дефолтного расписания в полной замене
                  GetIt.I.get<Talker>().critical(
                      "${para.number} $day ${getGroupById(lesson.group)!.name}");

                  bool hasFullZamena = fullzamenas
                      .where((element) =>
                          element.group == lesson.group &&
                          element.date.day == todayDay &&
                          element.date.month == todayMonth &&
                          element.date.year == todayYear)
                      .isNotEmpty;

                  bool hasOtherZamena = dayZamenas.where((element) =>
                      element.groupID == lesson.group &&
                      element.lessonTimingsID == para.number).isNotEmpty;

                  if (!hasFullZamena && !hasOtherZamena) {
                    return CourseTile(
                      type: SearchType.teacher,
                      course: course,
                      lesson: lesson,
                      swaped: null,
                      refresh: refresh,
                      saturdayTime: day == 6,
                    );
                  }
                }
              }
              //если это замена препода, ставлю ее
              else {
                //пара которая меняется
                Lesson? swapedPara = lessons
                    .where((element) => element.number == para.number)
                    .firstOrNull;
                //замена этой пары

                Zamena zamena = dayZamenas.where((element) =>
                    element.lessonTimingsID == para.number &&
                    element.teacherID == teacherID).first;
                final course = getCourseById(zamena.courseID) ??
                    Course(id: -1, name: "err2", color: "100,0,0,0");
                return CourseTile(
                  type: SearchType.teacher,
                  course: course,
                  refresh: refresh,
                  saturdayTime: day == 6,
                  lesson: Lesson(
                      id: -1,
                      course: course.id,
                      cabinet: zamena.cabinetID,
                      number: zamena.lessonTimingsID,
                      teacher: zamena.teacherID,
                      group: zamena.groupID,
                      date: zamena.date),
                  swaped: swapedPara,
                );
              }
            }

            //если замен нет, пытаюсь составить дефолтное расписание
            else {
              // GetIt.I.get<Talker>().critical(para.number);
              // lessons.forEach((element) {
              //   GetIt.I.get<Talker>().good(getGroupById(element.group)!.name);
              //   GetIt.I.get<Talker>().good(element.number);
              //   GetIt.I.get<Talker>().good(para.number);
              // });
              if (lessons.any((element) => element.number == para.number)) {
                Lesson lesson = lessons
                    .where((element) => element.number == para.number)
                    .first;

                final course = getCourseById(lesson.course) ??
                    Course(id: -1, name: "err3", color: "50,0,0,1");

                //проверяю не состоит ли группа дефолтного расписания в полной замене
                if (fullzamenas
                    .where((element) =>
                        element.group == lesson.group &&
                        element.date.day == todayDay &&
                        element.date.month == todayMonth &&
                        element.date.year == todayYear)
                    .isEmpty) {
                  return CourseTile(
                    type: SearchType.teacher,
                    course: course,
                    lesson: lesson,
                    swaped: null,
                    refresh: refresh,
                    saturdayTime: day == 6,
                  );
                }
              }
            }
            return const SizedBox();
            //return Text("data ${lessons.where((element) => element.number == para.number).length}");
          }).toList())
        ],
      ),
    );
  }
}

class DayScheduleWidget extends StatelessWidget {
  final DateTime startDate;
  final int currentDay;
  final int currentWeek;
  final int todayWeek;
  final Data data;
  final Function refresh;
  final int day;
  final List<Zamena> dayZamenas;
  final List<Lesson> lessons;

  const DayScheduleWidget(
      {super.key,
      required this.day,
      required this.refresh,
      required this.dayZamenas,
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
                return const SizedBox();
              }
              Zamena? zamena = dayZamenas.where(
                      (element) => element.lessonTimingsID == para.number)
                  .firstOrNull;
              if (zamena != null) {
                final course = getCourseById(zamena.courseID) ??
                    Course(id: -1, name: "err2", color: "100,0,0,0");
                return CourseTile(
                  type: type,
                  course: course,
                  refresh: refresh,
                  swaped: null,
                  saturdayTime: day == 6,
                  lesson: Lesson(
                      id: -1,
                      course: course.id,
                      cabinet: zamena.cabinetID,
                      number: zamena.lessonTimingsID,
                      teacher: zamena.teacherID,
                      group: zamena.groupID,
                      date: zamena.date),
                );
              }
              return const SizedBox();
            } else {
              if (dayZamenas.any(
                  (element) => element.lessonTimingsID == para.number)) {
                Lesson? swapedPara = lessons
                    .where((element) => element.number == para.number)
                    .firstOrNull;
                Zamena zamena = dayZamenas.where(
                    (element) => element.lessonTimingsID == para.number).first;
                final course = getCourseById(zamena.courseID) ??
                    Course(id: -1, name: "err2", color: "100,0,0,0");
                return CourseTile(
                  type: type,
                  course: course,
                  refresh: refresh,
                  saturdayTime: day == 6,
                  lesson: Lesson(
                      id: -1,
                      course: course.id,
                      cabinet: zamena.cabinetID,
                      number: zamena.lessonTimingsID,
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
                    saturdayTime: day == 6,
                    type: type,
                    course: course,
                    lesson: lesson,
                    swaped: null,
                    refresh: refresh,
                  );
                }
              }
            }
            return const SizedBox();
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
    int searchDay = startDate.add(Duration(days: day - 1)).day;
    int searchMonth = startDate.add(Duration(days: day - 1)).month;
    int searchYear = startDate.add(Duration(days: day - 1)).year;
    Set<ZamenaFileLink> links = GetIt.I
        .get<Data>()
        .zamenaFileLinks
        .where(
          (element) =>
              element.date.year == searchYear &&
              element.date.month == searchMonth &&
              element.date.day == searchDay,
        )
        .toSet();
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
          links.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Container(
                            //margin: EdgeInsets.only(bottom: 60),
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: links.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => launchUrl(
                                        Uri.parse(links.toList()[index].link)),
                                    child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Ссылка:",
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inverseSurface),
                                            ),
                                            Text(links.toList()[index].link,
                                                style: TextStyle(
                                                    fontFamily: 'Ubuntu',
                                                    fontSize: 10,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inverseSurface
                                                        .withOpacity(0.6))),
                                            Text(
                                              "Время добавления в систему:",
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inverseSurface),
                                            ),
                                            Text(
                                              "${links.toList()[index].created}",
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 10,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inverseSurface
                                                      .withOpacity(0.6)),
                                            ),
                                          ],
                                        )),
                                  );
                                },
                              ),
                            ),
                          );
                        });
                  },
                  icon: SizedBox(
                    width: 30,
                    height: 30,
                    child: Stack(
                      children: [
                        Align(
                          alignment: links.length > 1
                              ? Alignment.bottomLeft
                              : Alignment.center,
                          child: SvgPicture.asset(
                            "assets/icon/link-2.svg",
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                        links.length > 1
                            ? Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      border: Border.all(
                                          width: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface
                                              .withOpacity(0.3))),
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        links.length.toString(),
                                        style: const TextStyle(
                                            fontFamily: 'Ubuntu'),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                )
              : const SizedBox(
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
              : const SizedBox()
        ],
      ),
    );
  }
}
