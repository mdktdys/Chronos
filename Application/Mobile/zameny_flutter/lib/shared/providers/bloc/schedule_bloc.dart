import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/services/Api.dart';
import 'package:zameny_flutter/shared/providers/groups_provider.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';

class Paras {
  List<Lesson>? lesson;
  List<Zamena>? zamena;
  ZamenaFull? zamenaFull;

  Paras({
    this.lesson,
    this.zamena,
    this.zamenaFull
  });
}

class DaySchedule {
  final List<Paras> paras;
  final List<ZamenaFileLink>? zamenaLinks;

  DaySchedule({
    required this.paras,
    required this.zamenaLinks
  });
}

final parasProvider = FutureProvider<List<DaySchedule>>((final Ref ref) async {
  final DateTime startdate = ref.watch(navigationDateProvider);
  final DateTime endDate = startdate.add(const Duration(days: 7));
  final SearchItem? searchItem = ref.watch(searchItemProvider);
  final List<LessonTimings> timings = await ref.watch(timingsProvider.future);

  if (searchItem == null) {
    return [];
  }

  List<Lesson>? lessons;
  List<Zamena>? zamenas;
  List<ZamenaFull>? zamenasFull;
  List<ZamenaFileLink> links = await Api.getZamenaFileLinks(start: startdate, end: endDate);

  if (searchItem is Group) {
    // lessons = (await Api.loadWeekSchedule(
    //   groupID: searchItem.id,
    //   start: startdate,
    //   end: endDate,
    // ))..sort((final a, final b) => a.date.compareTo(b.date));

    // zamenas = await Api.loadZamenas(
    //   groupsID: [searchItem.id],
    //   start: startdate,
    //   end: endDate,
    // );

    // zamenasFull = await Api.getZamenasFull(
    //   [searchItem.id],
    //   startdate,
    //   endDate
    // );

    // final Map<int, Zamena> zamenaByLessonId = {
    //   for (final zamena in zamenas) zamena.courseID: zamena,
    // };

    // final Map<DateTime, List<Paras>> parasByDate = {};
    // for (final lesson in lessons) {
    //   final Zamena? relatedZamena = zamenaByLessonId[lesson.id];
    //   final para = Paras(
    //     lesson: [lesson],
    //     zamena: relatedZamena,
    //     zamenaFull: zamenasFull.where((final zamenaFull) => zamenaFull.date == lesson.date && zamenaFull.group == lesson.group).firstOrNull
    //   );

    //   parasByDate.putIfAbsent(lesson.date, () => []).add(para);
    // }

    // return parasByDate.entries.map((final entry) {
    //   final paras = entry.value;

    //   return DaySchedule(
    //     paras: paras,
    //     zamenaLinks: links.where((final link) => link.date == entry.key).toList(),
    //   );
    // }).toList();

    return [];

    } else if (searchItem is Teacher) {
      lessons = (await Api.loadWeekTeacherSchedule(
        teacherID: searchItem.id,
        start: startdate,
        end: endDate,
      ))..sort((final a, final b) => a.date.compareTo(b.date));

      zamenas = await Api.loadTeacherZamenas(
        teacherID: searchItem.id,
        start: startdate,
        end: endDate,
      );

      final List<int> groups = List<int>.from(lessons.map((final e) => e.group));
      
      final result = await Future.wait([
        Api.getZamenasFull(groups, startdate, endDate),
        Api.getLiquidation(groups, startdate, endDate),
        Api.loadZamenas(groupsID: groups, start: startdate, end: endDate)
      ]);

      final groupsLessons = result[2] as List<Zamena>;

      List<DaySchedule> schedule = [];
      for (DateTime date in List.generate(endDate.difference(startdate).inDays + 1, (final int index) => endDate.add(Duration(days: index)))) {
        List<Paras> dayParas = [];

        final List<Lesson> teacherDayLessons = lessons.where((final lesson) => lesson.date == date).toList();
        final List<Zamena> dayGroupsLessons = groupsLessons.where((final lesson) => lesson.date == date).toList();

        for (LessonTimings timing in timings) {
          final Paras paras = Paras();

          final List<Lesson> teacherLesson = teacherDayLessons.where((final Lesson lesson) => lesson.number == timing.number).toList();
          final List<Zamena> groupLessonZamena = dayGroupsLessons.where((final Zamena lesson) => lesson.lessonTimingsID == timing.number && lesson.teacherID == searchItem.id).toList();

          paras.lesson = teacherLesson;
          paras.zamena = groupLessonZamena;

          dayParas.add(paras);
        }

        final daySchedule = DaySchedule(
          zamenaLinks: links,
          paras: dayParas,
        );

        schedule.add(daySchedule);
      }

      return schedule;
    }

    return [];
});


class ScheduleState extends Equatable {
  final bool isLoading;
  final List<Lesson> lessons;
  final List<Zamena> zamenas;
  final String? error;

  const ScheduleState({
    this.isLoading = false,
    this.lessons = const [],
    this.zamenas = const [],
    this.error,
  });

  ScheduleState copyWith({
    final bool? isLoading,
    final List<Lesson>? lessons,
    final List<Zamena>? zamenas,
    final String? error,
  }) {
    return ScheduleState(
      isLoading: isLoading ?? this.isLoading,
      lessons: lessons ?? this.lessons,
      zamenas: zamenas ?? this.zamenas,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, lessons, zamenas, error];
}


class ScheduleNotifier extends StateNotifier<ScheduleState> {
  ScheduleNotifier() : super(const ScheduleState());

  Future<void> loadCabinetWeek({
    required final int cabinetID,
    required final DateTime dateStart,
    required final DateTime dateEnd,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final lessons = await Api.loadWeekCabinetSchedule(
        start: dateStart,
        end: dateEnd,
        cabinetID: cabinetID,
      );
      final zamenas = await Api.loadCabinetZamenas(
        cabinetID: cabinetID,
        start: dateStart,
        end: dateEnd,
      );

      state = state.copyWith(
        isLoading: false,
        lessons: lessons,
        zamenas: zamenas,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }

  Future<void> loadTeacherWeek({
    required final int teacherID,
    required final DateTime dateStart,
    required final DateTime dateEnd,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final lessons = await Api.loadWeekTeacherSchedule(
        start: dateStart,
        end: dateEnd,
        teacherID: teacherID,
      );
      final zamenas = await Api.loadTeacherZamenas(
        teacherID: teacherID,
        start: dateStart,
        end: dateEnd,
      );

      state = state.copyWith(
        isLoading: false,
        lessons: lessons,
        zamenas: zamenas,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }

  Future<void> loadGroupWeek({
    required final int groupID,
    required final DateTime dateStart,
    required final DateTime dateEnd,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final lessons = await Api.loadWeekSchedule(
        start: dateStart,
        end: dateEnd,
        groupID: groupID,
      );
      final zamenas = await Api.loadZamenas(
        groupsID: [groupID],
        start: dateStart,
        end: dateEnd,
      );

      state = state.copyWith(
        isLoading: false,
        lessons: lessons,
        zamenas: zamenas,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }
}

final riverpodScheduleProvider =
    StateNotifierProvider<ScheduleNotifier, ScheduleState>(
  (final ref) => ScheduleNotifier(),
);
