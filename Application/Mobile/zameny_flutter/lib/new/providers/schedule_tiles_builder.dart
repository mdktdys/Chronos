import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/models/lesson_model.dart';
import 'package:zameny_flutter/models/paras_model.dart';
import 'package:zameny_flutter/models/zamena_full_model.dart';
import 'package:zameny_flutter/models/zamena_model.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_default_widget.dart';

final scheduleTilesBuilderProvider = Provider<ScheduleTilesBuilder>((final ref) {
  return ScheduleTilesBuilder();
});

class ScheduleTilesBuilder {
  List<Widget> buildGroupTiles({
    required final ZamenaFull? zamenaFull,
    required final bool isShowZamena,
    required final bool isSaturday,
    required final Paras para,
    required final bool obed,
  }) {
    List<Widget> tiles = [];

    if (!isShowZamena) {
      return para.lesson!.map((final lesson) {
        return CourseTileRework(
          placeReason: '1',
          searchType: SearchType.group,
          isSaturday: isSaturday,
          index: lesson.number,
          lesson: lesson,
          obed: obed,
        );
      }).toList();
    }

    if (zamenaFull != null) {
      return para.zamena!.map((final zamena) {
        return CourseTileRework(
          placeReason: '2',
          searchType: SearchType.group,
          index: zamena.lessonTimingsID,
          obed: obed,
          isSaturday: isSaturday,
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
        placeReason: '3',
        isSaturday: isSaturday,
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
            searchType: SearchType.group,
            obed: obed,
            index: zamena!.lessonTimingsID,
            placeReason: '4',
            lesson: Lesson(
            id: -1,
            number: lesson.number,
            group: lesson.group,
            date: lesson.date,
            course: lesson.course,
            teacher: lesson.teacher,
            cabinet: lesson.cabinet,
          ),)
        );
        
      } else {
        tiles.add(CourseTileRework(
          placeReason: '5',
          searchType: SearchType.group,
          index: zamena!.lessonTimingsID,
          isSaturday: isSaturday,
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
    required final int teacherId,
    required final bool isShowZamena,
    required final Paras para,
    required final bool obed,
    required final bool isSaturday,
  }) {

    List<Widget> tiles = [];

    if (!isShowZamena) {
      tiles = para.lesson!.map((final lesson) {
        return CourseTileRework(
          placeReason: 'para default',
          searchType: SearchType.teacher,
          isSaturday: isSaturday,
          index: lesson.number,
          lesson: lesson,
          obed: obed,
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
            tiles.add(EmptyCourseTileRework(
              placeReason: '1',
              searchType: SearchType.teacher,
              lesson: para2,
              index: para2.number,
              obed: obed
            ));
            continue;
          }
        }

        tiles.add(CourseTileRework(
          placeReason: 'para',
          searchType: SearchType.teacher,
          index: para2.number,
          isSaturday: isSaturday,
          lesson: para2,
          obed: obed,
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
          placeReason: 'zamena without para',
          searchType: SearchType.teacher,
          isZamena: true,
          isSaturday: isSaturday,
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

    if (
      para.lesson != null
      && para.lesson!.isEmpty
      && para.zamena != null
      && para.zamena!.isNotEmpty
    ) {
      for (Zamena para2 in para.zamena!) {

        if (para2.teacherID == teacherId) {
          tiles.add(CourseTileRework(
          placeReason: 'zamena without para',
          searchType: SearchType.teacher,
          isZamena: true,
          isSaturday: isSaturday,
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

          if (para2.teacherID != teacherId) {

            // tiles.add(EmptyCourseTileRework(
            //   lesson: para.lesson!.firstWhere((final Lesson lesson) => lesson.group == para2.groupID),
            //   index: para2.lessonTimingsID,
            //   obed: obed
            // ));

            continue;
          }
          
          tiles.add(CourseTileRework(
            placeReason: 'group zamena default para',
            searchType: SearchType.teacher,
            isZamena: true,
            isSaturday: isSaturday,
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
          if (para2.teacherID != teacherId) {
            final Lesson? lesson = para.lesson!.where((final Lesson lesson) => lesson.group == para2.groupID).firstOrNull;

            if (lesson != null) {
              tiles.add(EmptyCourseTileRework(
                placeReason: '2',
                searchType: SearchType.teacher,
                lesson: lesson,
                index: para2.lessonTimingsID,
                obed: obed
              ));
            }
                      
            continue;
          }

          tiles.add(CourseTileRework(
            placeReason: 'another group zamena',
            searchType: SearchType.teacher,
            isZamena: true,
            obed: obed,
            isSaturday: isSaturday,
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

      for (Lesson lesson in para.lesson!) {

        if (
          para.zamenaFull != null
          && para.zamenaFull!.isNotEmpty
        ) {
          if (para.zamenaFull!.any((final ZamenaFull zamenafull) => zamenafull.group == lesson.group)) {

            if (para.zamena?.any((final Zamena zamena) => zamena.groupID == lesson.group && teacherId == zamena.teacherID) ?? false) {
              continue;
            }

            if (para.zamena?.any((final zamena) => zamena.teacherID == teacherId) ?? false) {
              continue;
            }

            tiles.add(EmptyCourseTileRework(
              placeReason: '2',
              searchType: SearchType.teacher,
              lesson: lesson,
              index: lesson.number,
              obed: obed
            ));
          } else {
            if (
              para.zamena?.any((final Zamena zamena) => zamena.groupID == lesson.group && teacherId != zamena.teacherID) ?? false
            ) {

              if (para.zamena?.any((final Zamena zamena) => zamena.teacherID == teacherId) ?? false) {

              } else {
                tiles.add(EmptyCourseTileRework(
                  placeReason: '3',
                  searchType: SearchType.teacher,
                  lesson: lesson,
                  index: lesson.number,
                  obed: obed
                ));
              }
              
            } else {
              tiles.add(CourseTileRework(
                placeReason: 'para on another zamenas',
                searchType: SearchType.teacher,
                index: lesson.number,
                isSaturday: isSaturday,
                lesson: lesson,
                obed: obed,
              ));
            }
            
            if (para.zamena?.any((final Zamena zamena) => zamena.groupID != lesson.group && lesson.teacher == teacherId) ?? false) {
              
            }
          }

        } else {
          if (para.zamena?.any((final Zamena zamena) => zamena.groupID == lesson.group && teacherId != zamena.teacherID) ?? false) {
            tiles.add(EmptyCourseTileRework(
              placeReason: '4',
              searchType: SearchType.teacher,
              lesson: lesson,
              index: lesson.number,
              obed: obed
            ));
          }
        }
      }
    }

    return tiles;
  }
}
