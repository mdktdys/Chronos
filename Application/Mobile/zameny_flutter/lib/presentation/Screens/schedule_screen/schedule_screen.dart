import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/Models/group.dart';
import 'package:zameny_flutter/Services/Tools.dart';
import 'package:zameny_flutter/presentation/Providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/presentation/Screens/schedule_screen/schedule_date_header/schedule_date_header.dart';
import 'package:zameny_flutter/presentation/Screens/schedule_screen/schedule_header/schedule_header.dart';
import 'package:zameny_flutter/presentation/Screens/schedule_screen/schedule_header/schedule_turbo_search.dart';
import 'package:zameny_flutter/presentation/Widgets/CourseTile.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  DateTime NavigationDate = DateTime.now();
  DateTime septemberFirst = DateTime(2023, 9, 1); // 1 сентября
  late final todayWeek;
  var currentWeek;
  late final ScrollController scrollController;
  late int groupIDSeek;
  late int teacherIDSeek;
  late int cabinetIDSeek;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    groupIDSeek = GetIt.I.get<Data>().seekGroup ?? -1;
    teacherIDSeek = GetIt.I.get<Data>().teacherGroup ?? -1;

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
    } else {
      context.read<ScheduleBloc>().emit(ScheduleInitial());
    }
  }

  // _loadPage() {
  //   DateTime monday =
  //       NavigationDate.subtract(Duration(days: NavigationDate.weekday - 1));
  //   DateTime sunday = monday.add(const Duration(days: 6));

  //   // Устанавливаем время для понедельника и воскресенья
  //   DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
  //   DateTime endOfWeek =
  //       DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

  //   context.read<ScheduleBloc>().add(FetchData(
  //         groupID: groupIDSeek,
  //         dateStart: startOfWeek,
  //         dateEnd: endOfWeek,
  //       ));
  // }

  void _loadWeekSchedule() async {
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
    final data = GetIt.I.get<Data>();
    GetIt.I.get<SharedPreferences>().setInt('SelectedGroup', groupID);
    groupIDSeek = groupID;
    data.seekGroup = groupID;
    data.latestSearch = CourseTileType.group;
    _loadWeekSchedule();
    setState(() {});
  }

  void _teacherSelected(int teacherID) {
    final data = GetIt.I.get<Data>();
    GetIt.I.get<SharedPreferences>().setInt('SelectedTeacher', teacherID);
    teacherIDSeek = teacherID;
    data.teacherGroup = teacherID;
    data.latestSearch = CourseTileType.teacher;
    _loadWeekTeahcerSchedule();
    setState(() {});
  }

  void _cabinetSelected(int cabinetID) {
    final data = GetIt.I.get<Data>();
    GetIt.I.get<SharedPreferences>().setInt('SelectedCabinet', cabinetID);
    cabinetIDSeek = cabinetID;
    data.seekCabinet = cabinetID;
    data.latestSearch = CourseTileType.cabinet;
    _loadCabinetWeekSchedule();
    setState(() {});
  }

  void _loadCabinetWeekSchedule() async {
    DateTime monday =
        NavigationDate.subtract(Duration(days: NavigationDate.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));

    DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(LoadCabinetWeek(
          cabinetID: cabinetIDSeek,
          dateStart: startOfWeek,
          dateEnd: endOfWeek,
        ));
  }

  void _loadWeekTeahcerSchedule() async {
    DateTime monday =
        NavigationDate.subtract(Duration(days: NavigationDate.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));

    DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(LoadTeacherWeek(
          teacherID: teacherIDSeek,
          dateStart: startOfWeek,
          dateEnd: endOfWeek,
        ));
  }

  void _dateSwitched() async {
    final Data dat = GetIt.I.get<Data>();
    if (dat.latestSearch == CourseTileType.teacher) {
      _teacherSelected(dat.teacherGroup!);
    }
    if (dat.latestSearch == CourseTileType.cabinet) {
      _cabinetSelected(dat.seekCabinet!);
    }
    if (dat.latestSearch == CourseTileType.group) {
      _groupSelected(dat.seekGroup!);
    }
  }

  String searchDiscribtion() {
    final Data dat = GetIt.I.get<Data>();
    if (dat.latestSearch == CourseTileType.teacher) {
      Teacher? teacher = getTeacherById(dat.teacherGroup!);
      return teacher == null ? "Error" : teacher.name;
    }
    if (dat.latestSearch == CourseTileType.cabinet) {
      Cabinet? cabinet = getCabinetById(dat.seekCabinet!);
      return cabinet == null ? "Error" : cabinet.name;
    }
    if (dat.latestSearch == CourseTileType.group) {
      Group? group = getGroupById(dat.seekGroup!);
      return group == null ? "Error" : group.name;
    }
    return "Not found";
  }

  String getSearchTypeNamed() {
    final Data dat = GetIt.I.get<Data>();
    if (dat.latestSearch == CourseTileType.teacher) {
      return "Teacher";
    }
    if (dat.latestSearch == CourseTileType.cabinet) {
      return "Cabinet";
    }
    if (dat.latestSearch == CourseTileType.group) {
      return "Group";
    }
    return "Not found";
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const ScheduleHeader(),
                const SizedBox(height: 10),
                ScheduleTurboSearch(
                  groupSelected: _groupSelected,
                  teacherSelected: _teacherSelected,
                  cabinetSelected: _cabinetSelected,
                ),
                //const SizedBox(height: 10),
                //GroupChooser(onGroupSelected: _groupSelected),
                const SizedBox(height: 10),
                DateHeader(
                    parentWidget: this,
                    todayWeek: todayWeek,
                    currentWeek: currentWeek,
                    dateSwitched: _dateSwitched),
                const SizedBox(height: 10),
                BlocBuilder<ScheduleBloc, ScheduleState>(
                  builder: (context, state) {
                    if (state is ScheduleLoaded) {
                      return Container(
                        child: Column(
                          children: [
                            Text(getSearchTypeNamed(),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                    fontFamily: 'Ubuntu',
                                    fontSize: 18)),
                            Text(searchDiscribtion(),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                    fontFamily: 'Ubuntu',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    } else if (state is ScheduleFailedLoading) {
                      return const SizedBox();
                    } else if (state is ScheduleLoading) {
                      return const SizedBox();
                    } else if (state is ScheduleInitial) {
                      return SizedBox();
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
          padding: EdgeInsets.symmetric(horizontal: 20),
          sliver: BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, state) {
              if (state is ScheduleLoaded) {
                return SliverToBoxAdapter(
                  child: LessonList(
                    type: state.searchType,
                    zamenas: state.zamenas,
                    lessons: state.lessons,
                    groupID: groupIDSeek,
                    weekDate: NavigationDate,
                    todayWeek: todayWeek,
                    currentWeek: currentWeek,
                  ),
                );
              } else if (state is ScheduleFailedLoading) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: true,
                  child: FailedLoadWidget(
                    error: state.error,
                    funcReload: _loadWeekSchedule,
                  ),
                );
              } else if (state is ScheduleLoading) {
                return SliverFillRemaining(
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
                ;
              } else {
                return SliverFillRemaining(child: const SizedBox());
              }
            },
          ),
        ),
        SliverToBoxAdapter(
          child: const SizedBox(
            height: 100,
          ),
        )
      ],
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 200, child: Lottie.asset('assets/lottie/loading.json')),
          const Text(
            "Гружу...",
            style: TextStyle(
                color: Colors.blue,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold,
                fontSize: 26),
          )
        ],
      ),
    );
  }
}

class FailedLoadWidget extends StatelessWidget {
  final Function funcReload;
  final String error;
  const FailedLoadWidget(
      {super.key, required this.funcReload, required this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.warning_amber_outlined,
          color: Colors.red,
          size: 100,
          shadows: [Shadow(color: Colors.red, blurRadius: 4)],
        ),
        const Text(
          "Ошибка :(",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.red,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
              fontSize: 26),
        ),
        Text(
          error,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.red,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w400,
              fontSize: 14),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            funcReload.call();
          },
          child: Container(
            width: 150,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 2, color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: const Center(
              child: Text(
                "Перезагрузить",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Ubuntu', fontSize: 18),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
        ),
      ],
    );
  }
}

class LessonList extends StatelessWidget {
  final List<Lesson> lessons;
  final List<Zamena> zamenas;
  final DateTime weekDate;
  final int groupID;
  final CourseTileType type;
  final todayWeek;
  final currentWeek;

  const LessonList(
      {super.key,
      required this.type,
      required this.zamenas,
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

    return Column(children: [
      zamenas.isNotEmpty ? Container() : const SearchBannerMessageWidget(),
      Column(
          children: ScheduleList(lessons, data, groupID, zamenas, startDate,
              currentDay, todayWeek, currentWeek,
              type: type)),
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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        // boxShadow: [
        //   const BoxShadow(
        //       color: Color.fromARGB(255, 43, 43, 58),
        //       blurStyle: BlurStyle.outer,
        //       blurRadius: 12)
        // ]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 30,
              color: Colors.blue,
              // shadows: [
              //   Shadow(
              //     color: Color.fromARGB(255, 28, 95, 182),
              //     blurRadius: 6,
              //   )
              // ],
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Нет замен",
              style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.inverseSurface),
            )
          ],
        ),
      ),
    );
  }
}

List<Widget> ScheduleList(
    List<Lesson> weekLessons,
    Data data,
    int groupID,
    List<Zamena> zamenas,
    DateTime startDate,
    int currentDay,
    todayWeek,
    currentWeek,
    {required CourseTileType type}) {
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
        type: type,
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
  final CourseTileType type;

  const DayScheduleWidget(
      {super.key,
      required this.day,
      required this.DayZamenas,
      required this.lessons,
      required this.startDate,
      required this.currentDay,
      required this.currentWeek,
      required this.todayWeek,
      required this.data,
      required this.type});

  final int day;
  final List<Zamena> DayZamenas;
  final List<Lesson> lessons;

  @override
  Widget build(BuildContext context) {
    bool isToday =
        (day == currentDay && todayWeek == currentWeek ? true : false);

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
                isToday
                    ? Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 30, 118, 233),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Color.fromARGB(255, 28, 95, 182),
                            //     blurStyle: BlurStyle.outer,
                            //     blurRadius: 6,
                            //   )
                            // ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
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
                    : Container()
              ],
            ),
          ),
          Column(
              children: data.timings.map((para) {
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
