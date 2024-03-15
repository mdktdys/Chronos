import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/Services/Data.dart';
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

import '../../Widgets/dayschedule_default_widget.dart';
import '../../Widgets/dayschedule_teacher_widget.dart';

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

  Widget _buildContentForState(ScheduleState state) {
    if (state is ScheduleLoaded) {
      return LessonList(
        key: UniqueKey(),
        scrollController: scrollController,
        refresh: refresh,
        zamenas: state.zamenas,
        lessons: state.lessons,
      );
    } else if (state is ScheduleFailedLoading) {
      return FailedLoadWidget(
        key: UniqueKey(),
        error: state.error,
      );
    } else if (state is ScheduleLoading) {
      return LoadingWidget(
        key: UniqueKey(),
      );
    } else if (state is ScheduleInitial) {
      return Center(
        key: UniqueKey(),
        child: Text(
          "Тыкни на поиск!\nвыбери группу, препода или кабинет",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inverseSurface,
            fontFamily: 'Ubuntu',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
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
                      if (state is ScheduleLoaded) {
                        return const SearchResultHeader();
                      } else if (state is ScheduleFailedLoading) {
                        return const SizedBox();
                      } else if (state is ScheduleLoading) {
                        return const SizedBox();
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
                return SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    reverseDuration: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 300),
                    child: _buildContentForState(state),
                  ),
                );
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
    final data = GetIt.I.get<Data>();
    final startDate = provider.navigationDate
        .subtract(Duration(days: provider.navigationDate.weekday - 1));

    List<Widget> list = scheduleList(
      context,
      refresh,
      lessons,
      data,
      zamenas,
      startDate,
      currentDay,
      provider.todayWeek,
      provider.currentWeek,
    );


    return Column(children: [
      //zamenas.isNotEmpty ? const SizedBox() : const SearchBannerMessageWidget(),
      ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: list),
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
