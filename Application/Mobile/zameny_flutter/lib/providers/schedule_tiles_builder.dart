import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/enums/schedule_view_mode_enum.dart';
import 'package:zameny_flutter/models/lesson/lesson_model.dart';
import 'package:zameny_flutter/models/paras/paras_model.dart';
import 'package:zameny_flutter/models/tile_data.dart';
import 'package:zameny_flutter/models/zamena_full/zamena_full_model.dart';
import 'package:zameny_flutter/models/zamena_model.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/providers/teacher_stats_provider.dart';

final scheduleTileDataBuilderProvider = Provider<ScheduleTileBuilder>((final Ref ref) {
  return ScheduleTileBuilder();
});

class ScheduleTileBuilder {
  List<TileData> buildGroupTiles({
    required final ZamenaFull? zamenaFull,
    required final ScheduleViewMode viewMode,
    required final bool isSaturday,
    required final Paras para,
    required final bool obed,
  }) {
    List<TileData> tiles = [];

    if (viewMode == ScheduleViewMode.standart) {
      return para.lesson!.map<TileLessonData>((final Lesson lesson) {
        return TileLessonData(lesson: lesson);
      }).toList();
    } else if (viewMode == ScheduleViewMode.zamenas) {
      return para.zamena!.map<TileData>((final zamena) {
        if (zamena.courseID == 10843) {
          final Lesson? lesson = para.lesson!.firstOrNull;

          if (lesson != null) {
            return TileRemovedLessonData(lesson: lesson);
          }
        }

        return TileWithZamenaData(lesson: Lesson.fromZamena(zamena));
      }).toList();
    } else if (viewMode == ScheduleViewMode.schedule) {
      if (zamenaFull != null) {
        return para.zamena!.map((final Zamena zamena) {
          return TileWithZamenaData(lesson: Lesson.fromZamena(zamena));
        }).toList();
      }

      final Zamena? zamena = para.zamena?.firstOrNull;
      final Lesson? lesson = para.lesson?.firstOrNull; 

      if (zamena == null && lesson != null) {
        tiles.add(TileLessonData(lesson: lesson));
      } else {
        if (zamena?.courseID == 10843) {
          if (lesson == null) {
            return [];
          }

          tiles.add(TileRemovedLessonData(lesson: lesson));
        } else {

          if (lesson == null) {
            tiles.add(TileWithZamenaData(lesson: Lesson.fromZamena(zamena!)));
          } else {
            tiles.add(
              TileZamenaOnLesson(
                lesson: lesson,
                zamena: Lesson.fromZamena(zamena!)
              )
            );
          }
        }
      }
    }

    return tiles;
  }

  List<TileData> buildTeacherTiles({
    required final int teacherId,
    required final ScheduleViewMode viewMode,
    required final Paras para,
    required final bool obed,
    required final bool isSaturday,
  }) {

    List<TileData> tiles = [];

    if (viewMode == ScheduleViewMode.standart) {
      return para.lesson!.map<TileLessonData>((final Lesson lesson) {
        return TileLessonData(lesson: lesson);
      }).toList();
    }

    // Только замены
    if (viewMode == ScheduleViewMode.zamenas) {
      // Если есть дефолтная пара
      if (
        para.lesson != null
        && para.lesson!.isNotEmpty
      ) {
        if (
          para.zamena != null
          && para.zamena!.isNotEmpty
        ) {
          for (Zamena zamena in para.zamena!) {
            if (zamena.teacherID == teacherId) {

              tiles.add(TileZamenaOnLesson(
                lesson: para.lesson!.first,
                zamena: Lesson.fromZamena(zamena)
              ));
            } else {
              if (para.lesson!.first.group == zamena.groupID) {
                tiles.add(TileRemovedLessonData(lesson: para.lesson!.first));
              }
            }
          }
        }

        if (
          para.zamenaFull != null
          && para.zamenaFull!.isNotEmpty
          && para.zamenaFull!.any((final ZamenaFull zamenaFull) => zamenaFull.group == para.lesson!.first.group)
          && !para.zamena!.any((final Zamena zamena) => zamena.teacherID == teacherId)
        ) {
          tiles.add(TileRemovedLessonData(lesson: para.lesson!.first));
        }

      // Если нет дефолтной пары но есть замена
      } else if (
        para.zamena != null
        && para.zamena!.isNotEmpty
      ) {
        for (Zamena zamena in para.zamena!) {
          if (zamena.teacherID == teacherId) {
            tiles.add(TileWithZamenaData(lesson: Lesson.fromZamena(zamena)));
          }
        }
      }

      return tiles;
    }

    // Если нет замен, то ставим стандартное расписание, без учета пар с полной заменой
    if (
      (para.zamena == null
      || (para.zamena!.isEmpty))
      && para.lesson != null
    ) {
      for (Lesson para2 in para.lesson!) {
        if (
          para.zamenaFull != null
          && para.zamenaFull!.isNotEmpty
        ) { 
          final bool zamenaFull = para.zamenaFull!.any((final zamena) => zamena.group == para2.group);

          if (zamenaFull) {
            tiles.add(TileRemovedLessonData(lesson: para2));
            continue;
          }
        }

        tiles.add(TileLessonData(lesson: para2));
      }
    }

    // Если по стандартному расписанию пары нет, то есть замена
    if (
      para.lesson == null
      && para.zamena != null
      && para.zamena!.isNotEmpty
    ) {
      for (Zamena para2 in para.zamena!) {
        tiles.add(TileWithZamenaData(lesson: Lesson.fromZamena(para2)));
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
          tiles.add(TileWithZamenaData(lesson: Lesson.fromZamena(para2)));
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

          tiles.add(
            TileZamenaOnLesson(
              lesson: para.lesson!.firstWhere((final Lesson lesson) => lesson.group == para2.groupID),
              zamena: Lesson.fromZamena(para2)
            )
          );
        } else {
          // Если это просто замена другой группы
          if (para2.teacherID != teacherId) {
            final Lesson? lesson = para.lesson!.where((final Lesson lesson) => lesson.group == para2.groupID).firstOrNull;

            if (lesson != null) {
              tiles.add(TileRemovedLessonData(lesson: lesson));
            }
                      
            continue;
          }

          tiles.add(
            TileZamenaOnLesson(
              lesson: para.lesson!.firstWhere((final Lesson lesson) => lesson.number == para2.lessonTimingsID),
              zamena: Lesson.fromZamena(para2))
            );
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

            tiles.add(TileRemovedLessonData(lesson: lesson));
          } else {
            if (
              para.zamena?.any((final Zamena zamena) => zamena.groupID == lesson.group && teacherId != zamena.teacherID) ?? false
            ) {

              if (para.zamena?.any((final Zamena zamena) => zamena.teacherID == teacherId) ?? false) {

              } else {
                tiles.add(TileRemovedLessonData(lesson: lesson));
              }
              
            } else {
              tiles.add(TileLessonData(lesson: lesson));
            }
            
            if (para.zamena?.any((final Zamena zamena) => zamena.groupID != lesson.group && lesson.teacher == teacherId) ?? false) {
              
            }
          }

        } else {
          if (para.zamena?.any((final Zamena zamena) => zamena.groupID == lesson.group && teacherId != zamena.teacherID) ?? false) {
            tiles.add(TileRemovedLessonData(lesson: lesson));
            continue;
          }

          if (!(para.zamena?.any((final Zamena zamena) => zamena.groupID == lesson.group) ?? true)) {
            tiles.add(TileLessonData(lesson: lesson));
          }
        }
      }
    }

    return tiles;
  }
  
  List<TileData> buildCabinetTiles({
    required final int cabinetId,
    required final ScheduleViewMode viewMode,
    required final Paras para,
    required final bool obed,
    required final bool isSaturday,
  }) {

    List<TileData> tiles = [];

    if (viewMode == ScheduleViewMode.standart) {
      return para.lesson!.map<TileLessonData>((final Lesson lesson) {
        return TileLessonData(lesson: lesson);
      }).toList();
    }

    // Только замены
    if (viewMode == ScheduleViewMode.zamenas) {
      // Если есть дефолтная пара
      if (
        para.lesson != null
        && para.lesson!.isNotEmpty
      ) {
        if (
          para.zamena != null
          && para.zamena!.isNotEmpty
        ) {
          for (Zamena zamena in para.zamena!) {
            if (zamena.cabinetID == cabinetId) {

              tiles.add(TileZamenaOnLesson(
                lesson: para.lesson!.first,
                zamena: Lesson.fromZamena(zamena)
              ));
            } else {
              if (para.lesson!.first.group == zamena.groupID) {
                tiles.add(TileRemovedLessonData(lesson: para.lesson!.first));
              }
            }
          }
        }

        if (
          para.zamenaFull != null
          && para.zamenaFull!.isNotEmpty
          && para.zamenaFull!.any((final ZamenaFull zamenaFull) => zamenaFull.group == para.lesson!.first.group)
          && !para.zamena!.any((final Zamena zamena) => zamena.cabinetID == cabinetId)
        ) {
          tiles.add(TileRemovedLessonData(lesson: para.lesson!.first));
        }

      // Если нет дефолтной пары но есть замена
      } else if (
        para.zamena != null
        && para.zamena!.isNotEmpty
      ) {
        for (Zamena zamena in para.zamena!) {
          if (zamena.cabinetID == cabinetId) {
            tiles.add(TileWithZamenaData(lesson: Lesson.fromZamena(zamena)));
          }
        }
      }

      return tiles;
    }

    // Если нет замен, то ставим стандартное расписание, без учета пар с полной заменой
    if (
      (para.zamena == null
      || (para.zamena!.isEmpty))
      && para.lesson != null
    ) {
      for (Lesson para2 in para.lesson!) {
        if (
          para.zamenaFull != null
          && para.zamenaFull!.isNotEmpty
        ) { 
          final bool zamenaFull = para.zamenaFull!.any((final zamena) => zamena.group == para2.group);

          if (zamenaFull) {
            tiles.add(TileRemovedLessonData(lesson: para2));
            continue;
          }
        }

        tiles.add(TileLessonData(lesson: para2));
      }
    }

    // Если по стандартному расписанию пары нет, то есть замена
    if (
      para.lesson == null
      && para.zamena != null
      && para.zamena!.isNotEmpty
    ) {
      for (Zamena para2 in para.zamena!) {
        tiles.add(TileWithZamenaData(lesson: Lesson.fromZamena(para2)));
      }
    }

    if (
      para.lesson != null
      && para.lesson!.isEmpty
      && para.zamena != null
      && para.zamena!.isNotEmpty
    ) {
      for (Zamena para2 in para.zamena!) {
        if (para2.cabinetID == cabinetId) {
          tiles.add(TileWithZamenaData(lesson: Lesson.fromZamena(para2)));
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

          if (para2.cabinetID != cabinetId) {

            // tiles.add(EmptyCourseTileRework(
            //   lesson: para.lesson!.firstWhere((final Lesson lesson) => lesson.group == para2.groupID),
            //   index: para2.lessonTimingsID,
            //   obed: obed
            // ));

            continue;
          }

          tiles.add(
            TileZamenaOnLesson(
              lesson: para.lesson!.firstWhere((final Lesson lesson) => lesson.group == para2.groupID),
              zamena: Lesson.fromZamena(para2)
            )
          );
        } else {
          // Если это просто замена другой группы
          if (para2.cabinetID != cabinetId) {
            final Lesson? lesson = para.lesson!.where((final Lesson lesson) => lesson.group == para2.groupID).firstOrNull;

            if (lesson != null) {
              tiles.add(TileRemovedLessonData(lesson: lesson));
            }
                      
            continue;
          }

          tiles.add(
            TileZamenaOnLesson(
              lesson: para.lesson!.firstWhere((final Lesson lesson) => lesson.number == para2.lessonTimingsID),
              zamena: Lesson.fromZamena(para2))
            );
        }
      }

      for (Lesson lesson in para.lesson!) {

        if (
          para.zamenaFull != null
          && para.zamenaFull!.isNotEmpty
        ) {
          if (para.zamenaFull!.any((final ZamenaFull zamenafull) => zamenafull.group == lesson.group)) {

            if (para.zamena?.any((final Zamena zamena) => zamena.groupID == lesson.group && cabinetId == zamena.cabinetID) ?? false) {
              continue;
            }

            if (para.zamena?.any((final zamena) => zamena.cabinetID == cabinetId) ?? false) {
              continue;
            }

            tiles.add(TileRemovedLessonData(lesson: lesson));
          } else {
            if (
              para.zamena?.any((final Zamena zamena) => zamena.groupID == lesson.group && cabinetId != zamena.cabinetID) ?? false
            ) {

              if (para.zamena?.any((final Zamena zamena) => zamena.cabinetID == cabinetId) ?? false) {

              } else {
                tiles.add(TileRemovedLessonData(lesson: lesson));
              }
              
            } else {
              tiles.add(TileLessonData(lesson: lesson));
            }
            
            if (para.zamena?.any((final Zamena zamena) => zamena.groupID != lesson.group && lesson.cabinet == cabinetId) ?? false) {
              
            }
          }

        } else {
          if (para.zamena?.any((final Zamena zamena) => zamena.groupID == lesson.group && cabinetId != zamena.cabinetID) ?? false) {
            tiles.add(TileRemovedLessonData(lesson: lesson));
            continue;
          }

          if (!(para.zamena?.any((final Zamena zamena) => zamena.groupID == lesson.group) ?? true)) {
            tiles.add(TileLessonData(lesson: lesson));
          }
        }
      }
    }

    return tiles;
  }
}

final scheduleTilesBuilderProvider = Provider<ScheduleTilesBuilder>((final ref) {
  return ScheduleTilesBuilder(ref: ref);
});

class ScheduleTilesBuilder {
  final Ref ref;

  ScheduleTilesBuilder({required this.ref});

  List<Widget> buildGroupTiles({
    required final ZamenaFull? zamenaFull,
    required final ScheduleViewMode viewMode,
    required final bool isSaturday,
    required final Paras para,
    required final bool obed,
  }) {
    final List<TileData> tiles = ref.watch(scheduleTileDataBuilderProvider).buildGroupTiles(
      zamenaFull: zamenaFull,
      viewMode: viewMode,
      isSaturday: isSaturday,
      para: para,
      obed: obed
    );

    return tiles.map((final TileData tile) {
      switch (tile) {
        case TileLessonData a:
          return CourseTileRework(
            placeReason: 'para default',
            searchType: SearchType.group,
            isSaturday: isSaturday,
            index: a.lesson.number,
            lesson: a.lesson,
            obed: obed,
          );
        case TileRemovedLessonData a:
          return EmptyCourseTileRework(
            placeReason: "placeReason",
            searchType: SearchType.group,
            lesson: a.lesson,
            index: a.lesson.number,
            obed: obed
          );
        case TileWithZamenaData a:
          return CourseTileRework(
            placeReason: 'para default',
            searchType: SearchType.group,
            isZamena: true,
            isSaturday: isSaturday,
            index: a.lesson.number,
            lesson: a.lesson,
            obed: obed,
          );
        case TileZamenaOnLesson a:
          return CourseTileRework(
            placeReason: 'para default',
            searchType: SearchType.group,
            isZamena: true,
            isSaturday: isSaturday,
            index: a.zamena.number,
            lesson: a.zamena,
            swapedLesson: a.lesson,
            obed: obed,
          );
      }
    }).toList();
  }

  List<Widget> buildTeacherTiles({
    required final int teacherId,
    required final ScheduleViewMode viewMode,
    required final Paras para,
    required final bool obed,
    required final bool isSaturday,
  }) {

    final List<TileData> tiles = ref.watch(scheduleTileDataBuilderProvider).buildTeacherTiles(
      teacherId: teacherId,
      viewMode: viewMode,
      isSaturday: isSaturday,
      para: para,
      obed: obed
    );

    return tiles.map((final TileData tile) {
      switch (tile) {
        case TileLessonData a:
          return CourseTileRework(
            placeReason: 'para default',
            searchType: SearchType.teacher,
            isSaturday: isSaturday,
            index: a.lesson.number,
            lesson: a.lesson,
            obed: obed,
          );
        case TileRemovedLessonData a:
          return EmptyCourseTileRework(
            placeReason: "placeReason",
            searchType: SearchType.teacher,
            lesson: a.lesson,
            index: a.lesson.number,
            obed: obed
          );
        case TileWithZamenaData a:
          return CourseTileRework(
            placeReason: 'para default',
            searchType: SearchType.teacher,
            isZamena: true,
            isSaturday: isSaturday,
            index: a.lesson.number,
            lesson: a.lesson,
            obed: obed,
          );
        case TileZamenaOnLesson a:
          return CourseTileRework(
            placeReason: 'para default',
            searchType: SearchType.teacher,
            isZamena: true,
            isSaturday: isSaturday,
            index: a.zamena.number,
            lesson: a.zamena,
            swapedLesson: a.lesson,
            obed: obed,
          );
      }
    }).toList();
  }

  List<Widget> buildCabinetTiles({
    required final int cabinetId,
    required final ScheduleViewMode viewMode,
    required final Paras para,
    required final bool obed,
    required final bool isSaturday,
  }) {

    final List<TileData> tiles = ref.watch(scheduleTileDataBuilderProvider).buildCabinetTiles(
      cabinetId: cabinetId,
      viewMode: viewMode,
      isSaturday: isSaturday,
      para: para,
      obed: obed
    );

    return tiles.map((final TileData tile) {
      switch (tile) {
        case TileLessonData a:
          return CourseTileRework(
            placeReason: 'para default',
            searchType: SearchType.cabinet,
            isSaturday: isSaturday,
            index: a.lesson.number,
            lesson: a.lesson,
            obed: obed,
          );
        case TileRemovedLessonData a:
          return EmptyCourseTileRework(
            placeReason: "placeReason",
            searchType: SearchType.cabinet,
            lesson: a.lesson,
            index: a.lesson.number,
            obed: obed
          );
        case TileWithZamenaData a:
          return CourseTileRework(
            placeReason: 'para default',
            searchType: SearchType.cabinet,
            isZamena: true,
            isSaturday: isSaturday,
            index: a.lesson.number,
            lesson: a.lesson,
            obed: obed,
          );
        case TileZamenaOnLesson a:
          return CourseTileRework(
            placeReason: 'para default',
            searchType: SearchType.cabinet,
            isZamena: true,
            isSaturday: isSaturday,
            index: a.zamena.number,
            lesson: a.zamena,
            swapedLesson: a.lesson,
            obed: obed,
          );
      }
    }).toList();
  }

  List<ParaData> buildParaData({
    required final Paras para,
    required final DateTime date,
    required final int teacherId,
  }) {
    List<ParaData> tiles = [];

    // Если нет замен, то ставим стандартное расписание, без учета пар с полной заменой
    if (
      (para.zamena == null
      || (para.zamena!.isEmpty))
      && para.lesson != null
    ) {
      for (Lesson para2 in para.lesson!) {
        if (
          para.zamenaFull != null
          && para.zamenaFull!.isNotEmpty
        ) { 
          final bool zamenaFull = para.zamenaFull!.any((final zamena) => zamena.group == para2.group);

          if (zamenaFull) {
            // tiles.add(EmptyCourseTileRework(
            //   placeReason: '1',
            //   searchType: SearchType.teacher,
            //   lesson: para2,
            //   index: para2.number,
            //   obed: obed
            // ));
            continue;
          }
        }
        tiles.add(ParaData(
          cost: 2,
          lesson: para2,
          isZamena: false,
        ));
        // tiles.add(
        //   CourseTileRework(
        //     placeReason: 'para',
        //     searchType: SearchType.teacher,
        //     index: para2.number,
        //     isSaturday: isSaturday,
        //     lesson: para2,
        //     obed: obed,
        //   )
        // );
      }
    }

    // Если по стандартному расписанию пары нет, то есть замена
    if (
      para.lesson == null
      && para.zamena != null
      && para.zamena!.isNotEmpty
    ) {
      for (Zamena para2 in para.zamena!) {
        tiles.add(ParaData(
          cost: 2,
          lesson: Lesson(
            id: -1,
            number: para2.lessonTimingsID,
            group: para2.groupID,
            date: date,
            course: para2.courseID,
            teacher: para2.teacherID,
            cabinet: para2.cabinetID
          ),
          isZamena: true,
        ));
        // tiles.add(CourseTileRework(
        //   placeReason: 'zamena without para',
        //   searchType: SearchType.teacher,
        //   isZamena: true,
        //   isSaturday: isSaturday,
        //   obed: obed,
        //   index: para2.lessonTimingsID,
        //   lesson: Lesson(
        //     id: -1,
        //     number: para2.lessonTimingsID,
        //     group: para2.groupID,
        //     date: para2.date,
        //     course: para2.courseID,
        //     teacher: para2.teacherID,
        //     cabinet: para2.cabinetID
        //   ),
        // ));
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
          tiles.add(ParaData(
            cost: 2,
            isZamena: true,
            lesson: Lesson(
              id: -1,
              number: para2.lessonTimingsID,
              group: para2.groupID,
              date: date,
              course: para2.courseID,
              teacher: para2.teacherID,
              cabinet: para2.cabinetID,
            ),
          ));
        //   tiles.add(CourseTileRework(
        //   placeReason: 'zamena without para',
        //   searchType: SearchType.teacher,
        //   isZamena: true,
        //   isSaturday: isSaturday,
        //   obed: obed,
        //   index: para2.lessonTimingsID,
        //   lesson: Lesson(
        //     id: -1,
        //     number: para2.lessonTimingsID,
        //     group: para2.groupID,
        //     date: para2.date,
        //     course: para2.courseID,
        //     teacher: para2.teacherID,
        //     cabinet: para2.cabinetID
        //   ),
        // ));
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

          tiles.add(ParaData(
            cost: 2,
            isZamena: true,
            lesson: Lesson(
              id: -1,
              number: para2.lessonTimingsID,
              group: para2.groupID,
              date: date,
              course: para2.courseID,
              teacher: para2.teacherID,
              cabinet: para2.cabinetID,
            ),
          ));
          
          // tiles.add(CourseTileRework(
          //   placeReason: 'group zamena default para',
          //   searchType: SearchType.teacher,
          //   isZamena: true,
          //   isSaturday: isSaturday,
          //   obed: obed,
          //   index: para2.lessonTimingsID,
          //   swapedLesson: para.lesson!.firstWhere((final Lesson lesson) => lesson.group == para2.groupID),
          //   lesson: Lesson(
          //     id: -1,
          //     number: para2.lessonTimingsID,
          //     group: para2.groupID,
          //     date: para2.date,
          //     course: para2.courseID,
          //     teacher: para2.teacherID,
          //     cabinet: para2.cabinetID
          //   ),
          // ));

        } else {
          // Если это просто замена другой группы
          if (para2.teacherID != teacherId) {
            final Lesson? lesson = para.lesson!.where((final Lesson lesson) => lesson.group == para2.groupID).firstOrNull;

            if (lesson != null) {
              // tiles.add(EmptyCourseTileRework(
              //   placeReason: '2',
              //   searchType: SearchType.teacher,
              //   lesson: lesson,
              //   index: para2.lessonTimingsID,
              //   obed: obed
              // ));
            }
                      
            continue;
          }

          // tiles.add(CourseTileRework(
          //   placeReason: 'another group zamena',
          //   searchType: SearchType.teacher,
          //   isZamena: true,
          //   obed: obed,
          //   isSaturday: isSaturday,
          //   swapedLesson: para.lesson!.firstWhere((final Lesson lesson) => lesson.number == para2.lessonTimingsID),
          //   index: para2.lessonTimingsID,
          //   lesson: Lesson(
          //     id: -1,
          //     number: para2.lessonTimingsID,
          //     group: para2.groupID,
          //     date: para2.date,
          //     course: para2.courseID,
          //     teacher: para2.teacherID,
          //     cabinet: para2.cabinetID
          //   ),
          // ));

          tiles.add(ParaData(
            cost: 2,
            isZamena: true,
            lesson: Lesson(
              id: -1,
              number: para2.lessonTimingsID,
              group: para2.groupID,
              date: date,
              course: para2.courseID,
              teacher: para2.teacherID,
              cabinet: para2.cabinetID,
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

            // tiles.add(EmptyCourseTileRework(
            //   placeReason: '2',
            //   searchType: SearchType.teacher,
            //   lesson: lesson,
            //   index: lesson.number,
            //   obed: obed
            // ));
          } else {
            if (
              para.zamena?.any((final Zamena zamena) => zamena.groupID == lesson.group && teacherId != zamena.teacherID) ?? false
            ) {

              if (para.zamena?.any((final Zamena zamena) => zamena.teacherID == teacherId) ?? false) {

              } else {
                // tiles.add(EmptyCourseTileRework(
                //   placeReason: '3',
                //   searchType: SearchType.teacher,
                //   lesson: lesson,
                //   index: lesson.number,
                //   obed: obed
                // ));
              }
              
            } else {
              // tiles.add(CourseTileRework(
              //   placeReason: 'para on another zamenas',
              //   searchType: SearchType.teacher,
              //   index: lesson.number,
              //   isSaturday: isSaturday,
              //   lesson: lesson,
              //   obed: obed,
              // ));

              tiles.add(ParaData(
                cost: 2,
                isZamena: false,
                lesson: lesson,
              ));
            }
            
            if (para.zamena?.any((final Zamena zamena) => zamena.groupID != lesson.group && lesson.teacher == teacherId) ?? false) {
              
            }
          }

        } else {
          if (para.zamena?.any((final Zamena zamena) => zamena.groupID == lesson.group && teacherId != zamena.teacherID) ?? false) {
            // tiles.add(EmptyCourseTileRework(
            //   placeReason: '4',
            //   searchType: SearchType.teacher,
            //   lesson: lesson,
            //   index: lesson.number,
            //   obed: obed
            // ));

            continue;
          }

          if (!(para.zamena?.any((final Zamena zamena) => zamena.groupID == lesson.group) ?? true)) {
            tiles.add(ParaData(
              cost: 2,
              isZamena: true,
              lesson: lesson
            ));
            // tiles.add(CourseTileRework(
            //   placeReason: 'para with another zamena',
            //   searchType: SearchType.teacher,
            //   index: lesson.number,
            //   isSaturday: isSaturday,
            //   lesson: lesson,
            //   obed: obed,
            // ));
          }
        }
      }
    }

    return tiles;
  }
}
