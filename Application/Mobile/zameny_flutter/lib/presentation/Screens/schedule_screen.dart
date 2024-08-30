import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zameny_flutter/domain/Providers/adaptive.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/domain/Providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/domain/Providers/search_provider.dart';
import 'package:zameny_flutter/domain/Providers/theme_provider.dart';
import 'package:zameny_flutter/presentation/Screens/timetable_screen.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/schedule_date_header.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/schedule_header.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/schedule_turbo_search.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';
import 'package:zameny_flutter/presentation/Widgets/shared/failed_load_widget.dart';
import 'package:zameny_flutter/presentation/Widgets/shared/loading_widget.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/search_result_header.dart';
import 'package:zameny_flutter/domain/Models/models.dart';
import '../Widgets/schedule_screen/dayschedule_default_widget.dart';
import '../Widgets/schedule_screen/dayschedule_teacher_widget.dart';

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
        backgroundColor: themeProvider.theme.colorScheme.surface,
        key: myGlobals.scaffoldKey,
        body: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(children: [
                    Container(
                        color: Colors.transparent,
                        height: 30,
                        child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  try {
                                    launchUrl(Uri.parse(
                                        'tg://resolve?domain=bot_uksivt'));
                                  } catch (e) {
                                    launchUrl(
                                        Uri.parse('https://t.me/bot_uksivt'));
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Новое расписание тут ",
                                      style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "❤️",
                                      style: GoogleFonts.notoEmoji(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Text(
                                      " *тык*",
                                      style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )))),
                    const SizedBox(height: 10),
                    const ScheduleHeader(),
                    const SizedBox(height: 10),
                    const ScheduleTurboSearch(),
                    const SizedBox(height: 10),
                    const DateHeader(),
                    const CurrentLessonTimer(),
                    const SizedBox(height: 10),
                    BlocBuilder<ScheduleBloc, ScheduleState>(
                        builder: (context, state) {
                      return AnimatedSwitcher(
                          reverseDuration: const Duration(milliseconds: 300),
                          duration: const Duration(milliseconds: 300),
                          child: Builder(
                            key: ValueKey<ScheduleState>(state),
                            builder: (context) {
                              if (state is ScheduleLoaded) {
                                return Column(children: [
                                  const SearchResultHeader(),
                                  LessonList(
                                    scrollController: scrollController,
                                    refresh: refresh,
                                    zamenas: state.zamenas,
                                    lessons: state.lessons,
                                  )
                                ]);
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
                                      "Тыкни на поиск!\nвыбери группу, преподавателя или кабинет",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface,
                                        fontFamily: 'Ubuntu',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ));
                    }),
                    const SizedBox(
                      height: 100,
                    ),
                  ]),
                ),
              ),
            )));
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
  final ScrollController scrollController;

  const LessonList(
      {super.key,
      required this.refresh,
      required this.zamenas,
      required this.lessons,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    ScheduleProvider provider = context.watch<ScheduleProvider>();
    final currentDay = DateTime.now().weekday;
    final startDate = provider.navigationDate
        .subtract(Duration(days: provider.navigationDate.weekday - 1));

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

class ScheduleList extends StatelessWidget {
  final BuildContext context;
  final Function refresh;
  final List<Lesson> weekLessons;
  final List<Zamena> zamenas;
  final DateTime startDate;
  final int currentDay;
  final int todayWeek;
  final int currentWeek;
  const ScheduleList(
      {super.key,
      required this.context,
      required this.refresh,
      required this.weekLessons,
      required this.zamenas,
      required this.startDate,
      required this.currentDay,
      required this.todayWeek,
      required this.currentWeek});

  @override
  Widget build(BuildContext context) {
    ScheduleProvider provider = context.watch<ScheduleProvider>();
    SearchType searchType = provider.searchType;
    final isDesktop = Adaptive.isDesktop(context);
    List<Widget> days = List.generate(6, (iter) {
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
    return isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: days
                .map((e) => Expanded(
                      child: e,
                    ))
                .toList(),
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
    super.key,
    required this.iter,
    required this.weekLessons,
    required this.zamenas,
    required this.searchType,
    required this.refresh,
    required this.startDate,
    required this.currentDay,
    required this.todayWeek,
    required this.currentWeek,
  });

  @override
  Widget build(BuildContext context) {
    final day = iter + 1;
    List<Lesson> lessons = [];
    final Data data = GetIt.I.get<Data>();
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

    //if ((dayZamenas.length + lessons.length) > 0) {
    if (searchType == SearchType.group || searchType == SearchType.cabinet) {
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
    } else if (searchType == SearchType.teacher) {
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
    return const SizedBox();
    // } else {
    //   return const SizedBox();
    // }
  }
}
