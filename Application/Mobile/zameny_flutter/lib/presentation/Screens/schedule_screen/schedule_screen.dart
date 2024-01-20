import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/Tools.dart';
import 'package:zameny_flutter/presentation/Providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/presentation/Screens/schedule_screen/schedule_date_header/schedule_date_header.dart';
import 'package:zameny_flutter/presentation/Screens/schedule_screen/schedule_header/schedule_header.dart';
import 'package:zameny_flutter/presentation/Widgets/CourseTile.dart';
import 'package:zameny_flutter/presentation/Widgets/groupChooser.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime NavigationDate = DateTime.now();
  DateTime septemberFirst = DateTime(2023, 9, 1); // 1 сентября
  late final todayWeek;
  var currentWeek;
  late final ScrollController scrollController;
  late int groupIDSeek;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    groupIDSeek = GetIt.I.get<Data>().seekGroup ?? -1;
    currentWeek = ((NavigationDate.difference(septemberFirst).inDays +
                septemberFirst.weekday) ~/
            7) +
        1;

    todayWeek = currentWeek;
    // Находим понедельник и воскресенье текущей недели
    DateTime monday =
        NavigationDate.subtract(Duration(days: NavigationDate.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));

    // Устанавливаем время для понедельника и воскресенья
    DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    if (groupIDSeek != -1) {
      context.read<ScheduleBloc>().add(FetchData(
            groupID: groupIDSeek,
            dateStart: startOfWeek,
            dateEnd: endOfWeek,
          ));
    }
  }

  _loadPage() {
    DateTime monday =
        NavigationDate.subtract(Duration(days: NavigationDate.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));

    // Устанавливаем время для понедельника и воскресенья
    DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(FetchData(
          groupID: groupIDSeek,
          dateStart: startOfWeek,
          dateEnd: endOfWeek,
        ));
  }

  void _loadWeekSchedule() async {
    setState(() {});
    DateTime monday =
        NavigationDate.subtract(Duration(days: NavigationDate.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));

    // Устанавливаем время для понедельника и воскресенья
    DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(FetchData(
          groupID: groupIDSeek,
          dateStart: startOfWeek,
          dateEnd: endOfWeek,
        ));
  }

  DateTime getStartOfWeek(DateTime week) {
    DateTime monday = week.subtract(Duration(days: week.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  DateTime getEndOfWeek(DateTime week) {
    DateTime sunday = week
        .subtract(Duration(days: week.weekday - 1))
        .add(const Duration(days: 6));
    return DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);
  }

  void _groupSelected(int groupID) {
    GetIt.I.get<SharedPreferences>().setInt('SelectedGroup', groupID);
    setState(() {
      this.groupIDSeek = groupID;
      GetIt.I.get<Data>().seekGroup = groupID;
      _loadWeekSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<ScheduleBloc>().add(FetchData(
          groupID: groupIDSeek,
          dateStart: getStartOfWeek(NavigationDate),
          dateEnd: getEndOfWeek(NavigationDate))),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const ScheduleHeader(),
                  const SizedBox(height: 10),
                  GroupChooser(onGroupSelected: _groupSelected),
                  const SizedBox(height: 10),
                  DateHeader(
                    parentWidget: this,
                    todayWeek: todayWeek,
                    currentWeek: currentWeek,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: BlocBuilder<ScheduleBloc, ScheduleState>(
                builder: (context, state) {
                  if (state is ScheduleLoaded) {
                    return LessonList(
                      lessons: state.lessons,
                      groupID: groupIDSeek,
                      weekDate: NavigationDate,
                      todayWeek: todayWeek,
                      currentWeek: currentWeek,
                    );
                  } else if (state is ScheduleFailedLoading) {
                    return FailedLoadWidget(
                      funcReload: _loadWeekSchedule,
                    );
                  } else if (state is ScheduleLoading) {
                    return SizedBox(
                      height: 550,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 200,
                                child:
                                    Lottie.asset('assets/lottie/loading.json')),
                            const Text(
                              "Loading...",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26),
                            )
                          ],
                        ),
                      ),
                    );
                  } else if (state is ScheduleInitial) {
                    return const Text("Choose group");
                  } else {
                    return const SizedBox(); // or some default widget
                  }
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 80,
            ),
          )
        ],
      ),
    );
  }
}

class FailedLoadWidget extends StatelessWidget {
  final Function funcReload;
  const FailedLoadWidget({super.key, required this.funcReload});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 120,
          ),
          const Icon(
            Icons.warning_amber,
            color: Colors.red,
            size: 100,
            shadows: [Shadow(color: Colors.red, blurRadius: 12)],
          ),
          const Text(
            "Failed to load",
            style: TextStyle(
                color: Colors.red,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold,
                fontSize: 26),
          ),
          GestureDetector(
            onTap: () {
              funcReload.call();
            },
            child: Container(
              width: 150,
              height: 40,
              decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.red, blurRadius: 6)],
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const Center(
                child: Text(
                  "Reload",
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Ubuntu', fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LessonList extends StatelessWidget {
  final List<Lesson> lessons;
  final DateTime weekDate;
  final int groupID;
  final todayWeek;
  final currentWeek;

  const LessonList(
      {super.key,
      required this.lessons,
      required this.weekDate,
      required this.groupID,
      required this.todayWeek,
      required this.currentWeek});

  @override
  Widget build(BuildContext context) {
    final currentDay = DateTime.now().weekday;
    final data = GetIt.I.get<Data>();
    final startDate = weekDate.subtract(Duration(days: weekDate.weekday - 1));
    List<Zamena> zamenas = data.zamenas
        .where((zamena) =>
            zamena.groupID == groupID &&
            zamena.date.isAfter(startDate) &&
            zamena.date.isBefore(startDate.add(const Duration(days: 6))))
        .toList();

    return Column(children: [
      zamenas.isNotEmpty ? Container() : const SearchBannerMessageWidget(),
      Column(
          children: ScheduleList(lessons,data, groupID, zamenas, startDate, currentDay,
              todayWeek, currentWeek)),
    ]);
  }
}

class SearchBannerMessageWidget extends StatelessWidget {
  const SearchBannerMessageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromARGB(255, 59, 64, 82),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 43, 43, 58),
                blurStyle: BlurStyle.outer,
                blurRadius: 12)
          ]),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 42,
              color: Colors.blue,
              shadows: [
                Shadow(
                  color: Color.fromARGB(255, 28, 95, 182),
                  blurRadius: 6,
                )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Loaded default",
              style: TextStyle(
                  fontFamily: 'Ubuntu', fontSize: 20, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

List<Widget> ScheduleList(List<Lesson> weekLessons,Data data, int groupID, List<Zamena> zamenas, 
    DateTime startDate, int currentDay, todayWeek, currentWeek) {
  return List.generate(6, (iter) {
    final day = iter + 1;
    List <Lesson> lessons = [];
    try {
      weekLessons.forEach((element) { GetIt.I.get<Talker>().critical(element.date.weekday);});
      lessons = weekLessons.where((lesson) => lesson.date.weekday == day).toList();
      lessons.sort((a, b) => a.number > b.number ? 1 : -1);
    } catch (e) {
      return const SizedBox();
    }

    List<Zamena> DayZamenas =
        zamenas.where((element) => element.date.weekday == day).toList();
    DayZamenas.sort((a, b) => a.LessonTimingsID > b.LessonTimingsID ? 1 : -1);
    if ((DayZamenas.length + lessons.length) > 0) {
      return DayScheduleWidget(
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

  const DayScheduleWidget({
    super.key,
    required this.day,
    required this.DayZamenas,
    required this.lessons,
    required this.startDate,
    required this.currentDay,
    required this.currentWeek,
    required this.todayWeek,
    required this.data,
  });

  final int day;
  final List<Zamena> DayZamenas;
  final List<Lesson> lessons;

  @override
  Widget build(BuildContext context) {
    GetIt.I.get<Talker>().debug("${day}");

    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getDayName(day),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Ubuntu'),
                    ),
                    Text(
                      "${getMonthName(startDate.add(Duration(days: day - 1)).month)} ${startDate.add(Duration(days: day - 1)).day}",
                      //"${getMonthName(currentDayDateTime.add(Duration(days: iter)).month)} ${currentDayDateTime.add(Duration(days: iter)).day}",
                      style: const TextStyle(
                          color: Color.fromARGB(100, 255, 255, 255),
                          fontSize: 18,
                          fontFamily: 'Ubuntu'),
                    ),
                  ],
                ),
                day == currentDay && todayWeek == currentWeek
                    ? Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 30, 118, 233),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 28, 95, 182),
                                blurStyle: BlurStyle.outer,
                                blurRadius: 6,
                              )
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Today",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          Column(
              children: data.timings.map((para) {
            // if (DayZamenas.any((zamena) => zamena.LessonTimingsID == para)) {
            //   final Zamena zamena =
            //       DayZamenas.where((zamena) => zamena.LessonTimingsID == para)
            //           .first;
            //   final course = getCourseById(zamena.courseID) ??
            //       Course(id: -1, name: "err", color: "50,0,0,1");
            // return CourseTile(
            //   course: course,
            //   lesson: Lesson(
            //       id: -1,
            //       course: course.id,
            //       cabinet: zamena.cabinetID,
            //       number: zamena.LessonTimingsID,
            //       teacher: zamena.teacherID,
            //       group: zamena.groupID,
            //       day: day),
            //   swaped: true,
            //this working
            if (DayZamenas.any(
                (element) => element.LessonTimingsID == para.number)) {
              Zamena zamena = DayZamenas.where(
                  (element) => element.LessonTimingsID == para.number).first;
              final course = getCourseById(zamena.courseID) ??
                  Course(id: -1, name: "err2", color: "100,0,0,0");
              return CourseTile(
                course: course,
                lesson: Lesson(
                    id: -1,
                    course: course.id,
                    cabinet: zamena.cabinetID,
                    number: zamena.LessonTimingsID,
                    teacher: zamena.teacherID,
                    group: zamena.groupID,
                    date: zamena.date),
                swaped: true,
              );
            } else {
              if (lessons.any((element) => element.number == para.number)) {
                Lesson lesson = lessons
                    .where((element) => element.number == para.number)
                    .first;
                final course = getCourseById(lesson.course) ??
                    Course(id: -1, name: "err3", color: "50,0,0,1");
                return CourseTile(
                  course: course,
                  lesson: lesson,
                  swaped: false,
                );
              }
            }
            return Container();
          }).toList())
        ],
      ),
    );
  }
}
