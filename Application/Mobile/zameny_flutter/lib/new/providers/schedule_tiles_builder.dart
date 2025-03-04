import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/features/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/models/lesson_model.dart';
import 'package:zameny_flutter/models/zamena_full_model.dart';
import 'package:zameny_flutter/models/zamena_model.dart';
import 'package:zameny_flutter/new/models/paras_model.dart';

final scheduleTilesBuilderProvider = Provider<ScheduleTilesBuilder>((final ref) {
  return ScheduleTilesBuilder();
});

class ScheduleTilesBuilder {
  List<Widget> buildGroupTiles({
    required final ZamenaFull? zamenaFull,
    required final bool isShowZamena,
    required final Paras para,
    required final bool obed,
  }) {
    List<Widget> tiles = [];

    if (!isShowZamena) {
      return para.lesson!.map((final lesson) {
        return CourseTileRework(
          searchType: SearchType.group,
          index: lesson.number,
          lesson: lesson,
          obed: obed,
        );
      }).toList();
    }

    if (zamenaFull != null) {
      return para.zamena!.map((final zamena) {
        return CourseTileRework(
          searchType: SearchType.group,
          index: zamena.lessonTimingsID,
          obed: obed,
          lesson: Lesson(
            id: -1,
            number: zamena.lessonTimingsID,
            group: zamena.groupID,
            date: zamena.date,
            course: zamena.courseID,
            teacher: zamena.teacherID,
            cabinet: zamena.cabinetID
          ),
        );
      }).toList();
    }

    final Zamena? zamena = para.zamena?.firstOrNull;
    final Lesson? lesson = para.lesson?.firstOrNull; 

    if (zamena == null && lesson != null) {
      tiles.add(CourseTileRework(
        searchType: SearchType.group,
        obed: obed,
        index: lesson.number,
        lesson: lesson,
      ));

    } else {

      if (zamena?.courseID == 10843) {

        if (lesson == null) {
          return [];
        }
        
        tiles.add(
          EmptyCourseTileRework(
            obed: obed,
            index: zamena!.lessonTimingsID,
            lesson: Lesson(
            id: -1,
            number: lesson.number,
            group: lesson.group,
            date: lesson.date,
            course: lesson.course,
            teacher: lesson.teacher,
            cabinet: lesson.cabinet
          ),)
        );
        
      } else {
        tiles.add(CourseTileRework(
          searchType: SearchType.group,
          index: zamena!.lessonTimingsID,
          isZamena: true,
          swapedLesson: lesson,
          obed: obed,
          
          lesson: Lesson(

            id: -1,
            number: zamena.lessonTimingsID,
            group: zamena.groupID,
            date: zamena.date,
            course: zamena.courseID,

            teacher: zamena.teacherID,
            cabinet: zamena.cabinetID
          ),
        ),
      );
      }
    }

    return tiles;
  }

  List<Widget> buildTeacherTiles({
    required final bool isShowZamena,
    required final Paras para,
    required final bool obed,
  }) {

    List<Widget> tiles = [];

    if (!isShowZamena) {
      tiles = para.lesson!.map((final lesson) {
        return CourseTileRework(
          searchType: SearchType.teacher,
          index: lesson.number,
          lesson: lesson,
        );
      }).toList();

      return tiles;
    }

    // Если нет замен, то ставим стандартное расписание, без учета пар с полной заменой
    if (
      (para.zamena == null
      || (para.zamena!.isEmpty))
      && para.lesson != null
    ) {
      for (Lesson para2 in para.lesson!) {

        if (para.zamenaFull != null) { 
          final bool zamenaFull = para.zamenaFull!.any((final zamena) => zamena.group == para2.group);

          if (zamenaFull) {
            continue;
          }
        }

        tiles.add(CourseTileRework(
          searchType: SearchType.teacher,
          index: para2.number,
          lesson: para2,
        ));

      }
    }

    // Если по стандартному расписанию пары нет, то есть замена
    if (
      para.lesson == null
      && para.zamena != null
      && para.zamena!.isNotEmpty
    ) {
      for (Zamena para2 in para.zamena!) {
        tiles.add(CourseTileRework(
          searchType: SearchType.teacher,
          isZamena: true,
          obed: obed,
          index: para2.lessonTimingsID,
          lesson: Lesson(
            id: -1,
            number: para2.lessonTimingsID,
            group: para2.groupID,
            date: para2.date,
            course: para2.courseID,
            teacher: para2.teacherID,
            cabinet: para2.cabinetID
          ),
        ));
      }
    }

    // Если есть и стандартное расписание и замена
    if (
      para.lesson != null
      && para.lesson!.isNotEmpty
      && para.zamena != null
      && para.zamena!.isNotEmpty
    ) {
      for (Zamena para2 in para.zamena!) {

        // Если это замена обычной пары той же группы
        if (para.lesson!.any((final Lesson lesson) => lesson.group == para2.groupID)) {
          tiles.add(CourseTileRework(
            searchType: SearchType.teacher,
            isZamena: true,
            obed: obed,
            index: para2.lessonTimingsID,
            swapedLesson: para.lesson!.firstWhere((final Lesson lesson) => lesson.group == para2.groupID),
            lesson: Lesson(
              id: -1,
              number: para2.lessonTimingsID,
              group: para2.groupID,
              date: para2.date,
              course: para2.courseID,
              teacher: para2.teacherID,
              cabinet: para2.cabinetID
            ),
          ));
        } else {
          // Если это просто замена другой группы
          tiles.add(CourseTileRework( 
            searchType: SearchType.teacher,
            isZamena: true,
            obed: obed,
            swapedLesson: para.lesson!.firstWhere((final Lesson lesson) => lesson.number == para2.lessonTimingsID),
            index: para2.lessonTimingsID,
            lesson: Lesson(
              id: -1,
              number: para2.lessonTimingsID,
              group: para2.groupID,
              date: para2.date,
              course: para2.courseID,
              teacher: para2.teacherID,
              cabinet: para2.cabinetID
            ),
          ));
        }
      }
    }

    return tiles;
  }
}
