import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/new/models/day_schedule.dart';
import 'package:zameny_flutter/new/models/paras_model.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';
import 'package:zameny_flutter/services/Api.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';
import 'package:zameny_flutter/shared/widgets/snowfall.dart';


final scheduleProvider = AsyncNotifierProvider<ScheduleNotifier, List<DaySchedule>>(() {
  return ScheduleNotifier();
});


class ScheduleNotifier extends AsyncNotifier<List<DaySchedule>> {

  static List<DaySchedule> fake() {
    final DateTime date = DateTime.now();
    return [
      DaySchedule.fake(date),
      DaySchedule.fake(date.add(const Duration(days: 1)))
    ];
  }

  @override
  FutureOr<List<DaySchedule>> build() async {
    DateTime startdate = ref.watch(navigationDateProvider);
    startdate = startdate.subtract(Duration(days: startdate.weekday - 1));
    
    final DateTime endDate = startdate.add(const Duration(days: 6));
    final SearchItem? searchItem = ref.watch(searchItemProvider);
    final List<LessonTimings> timings = await ref.watch(timingsProvider.future);

    if (searchItem == null) {
      return [];
    }

    List<Lesson> lessons;
    List<Zamena> zamenas;
    List<ZamenaFull> zamenasFull;
    List<ZamenaFileLink> links = [];

    if (searchItem is Group) {
      final result = await Future.wait([
        Api.getGroupLessons(
          groupID: searchItem.id,
          start: startdate,
          end: endDate,
        ),
        Api.loadZamenas(
          groupsID: [searchItem.id],
          start: startdate,
          end: endDate,
        ),
        Api.getZamenaFileLinks(
          start: startdate,
          end: endDate
        ),
        Api.getZamenasFull(
          [searchItem.id],
          startdate,
          endDate
        )
      ]);

      lessons = result[0] as List<Lesson>;
      zamenas = result[1] as List<Zamena>;
      links = result[2] as List<ZamenaFileLink>;
      zamenasFull = result[3] as List<ZamenaFull>;

      List<DaySchedule> schedule = [];
      final List<DateTime> dates = List.generate(endDate.difference(startdate).inDays, (final int index) => startdate.add(Duration(days: index)));
      for (DateTime date in dates) {
        List<Paras> dayParas = [];

        final List<Lesson> dayLessons = lessons.where((final lesson) => lesson.date.sameDate(date)).toList();
        final List<Zamena> dayZamenas = zamenas.where((final lesson) => lesson.date.sameDate(date)).toList();


        for (LessonTimings timing in timings) {
          final Paras paras = Paras();

          paras.lesson = dayLessons.where((final Lesson lesson) => lesson.number == timing.number).toList();
          paras.zamena = dayZamenas.where((final Zamena lesson) => lesson.lessonTimingsID == timing.number && lesson.groupID == searchItem.id).toList();

          if (paras.lesson!.isEmpty && paras.zamena!.isEmpty) {
            continue;
          }

          paras.number = timing.number;
          dayParas.add(paras);
        }

        final daySchedule = DaySchedule(
            zamenaFull: zamenasFull.where((final zamena) => zamena.date.sameDate(date)).firstOrNull,
            zamenaLinks: links.where((final link) => link.date.sameDate(date)).toList(),
            paras: dayParas,
            date: date,
          );

        schedule.add(daySchedule);
      }
      
      return schedule;

      // for (final lesson in lessons) {
      //   final Zamena? relatedZamena = zamenaByLessonId[lesson.id];



      //   final para = Paras(
      //     lesson: [lesson],
      //     zamena: relatedZamena,
      //     zamenaFull: zamenasFull.where((final zamenaFull) => zamenaFull.date == lesson.date && zamenaFull.group == lesson.group).firstOrNull
      //   );
      // }
      //   parasByDate.putIfAbsent(lesson.date, () => []).add(para);
      // }

      // return parasByDate.entries.map((final entry) {
      //   final paras = entry.value;

      //   return DaySchedule(
      //     paras: paras,
      //     zamenaLinks: links.where((final link) => link.date == entry.key).toList(),
      //   );
      // }).toList();

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

        final List<int> groups = List<int>.from(lessons.map((final Lesson e) => e.group));
        
        final result = await Future.wait([
          Api.getZamenasFull(groups, startdate, endDate),
          Api.getLiquidation(groups, startdate, endDate),
          Api.loadZamenas(groupsID: groups, start: startdate, end: endDate)
        ]);

        final groupsLessons = result[2] as List<Zamena>;

        List<DaySchedule> schedule = [];
        for (DateTime date in List.generate(endDate.difference(startdate).inDays, (final int index) => startdate.add(Duration(days: index)))) {
          List<Paras> dayParas = [];

          final List<Lesson> teacherDayLessons = lessons.where((final lesson) => lesson.date.sameDate(date)).toList();
          final List<Zamena> dayGroupsLessons = groupsLessons.where((final lesson) => lesson.date.sameDate(date)).toList();

          for (LessonTimings timing in timings) {
            final Paras paras = Paras();

            final List<Lesson> teacherLesson = teacherDayLessons.where((final Lesson lesson) => lesson.number == timing.number).toList();
            final List<Zamena> groupLessonZamena = dayGroupsLessons.where((final Zamena lesson) => lesson.lessonTimingsID == timing.number && lesson.teacherID == searchItem.id).toList();

            paras.lesson = teacherLesson;
            paras.zamena = groupLessonZamena;

            // if (paras.lesson!.isEmpty && paras.zamena!.isEmpty) {
            //   continue;
            // }

            paras.number = timing.number;
            dayParas.add(paras);
          }

          for (var element in dayParas) {
            log((element.lesson?.firstOrNull?.course).toString());
          }

          final daySchedule = DaySchedule(
            zamenaFull: null,
            zamenaLinks: links.where((final link) => link.date.sameDate(date)).toList(),
            paras: dayParas,
            date: date,
          );

          schedule.add(daySchedule);
        }

        return schedule;
      }

      return [];
    }
}
