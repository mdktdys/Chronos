import 'package:flutter/material.dart';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:zameny_flutter/shared/providers/schedule_provider.dart';
import 'package:zameny_flutter/shared/providers/search_provider.dart';
import 'package:zameny_flutter/Services/Api.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/course_tile.dart';

@immutable
sealed class ScheduleEvent {}

final class FetchData extends ScheduleEvent {
  final BuildContext context;
  final int groupID;
  final DateTime dateStart;
  final DateTime dateEnd;

  FetchData({
    required this.groupID,
    required this.dateStart,
    required this.dateEnd,
    required this.context,
  });
}

final class LoadWeek extends ScheduleEvent {
  final int groupID;
  final DateTime dateStart;
  final DateTime dateEnd;

  LoadWeek({
    required this.groupID,
    required this.dateStart,
    required this.dateEnd
  });
}

final class LoadTeacherWeek extends ScheduleEvent {
  final int teacherID;
  final DateTime dateStart;
  final DateTime dateEnd;

  LoadTeacherWeek(
      {required this.teacherID,
      required this.dateStart,
      required this.dateEnd,});
}

final class LoadGroupWeek extends ScheduleEvent {
  final int groupID;
  final DateTime dateStart;
  final DateTime dateEnd;

  LoadGroupWeek({
    required this.groupID,
    required this.dateStart,
    required this.dateEnd,
  });
}

final class LoadCabinetWeek extends ScheduleEvent {
  final int cabinetID;
  final DateTime dateStart;
  final DateTime dateEnd;

  LoadCabinetWeek({
    required this.cabinetID,
    required this.dateStart,
    required this.dateEnd,
  });
}

final class LoadInitial extends ScheduleEvent {
  final BuildContext context;
  final WidgetRef ref;
  LoadInitial({required this.context, required this.ref});
}

sealed class ScheduleState extends Equatable {}

final class ScheduleLoaded extends ScheduleState {
  final List<Lesson> lessons;
  final List<Zamena> zamenas;
  ScheduleLoaded({required this.lessons, required this.zamenas});

  @override
  List<Object> get props => [lessons, zamenas];
}

final class ScheduleFailedLoading extends ScheduleState {
  final String error;
  ScheduleFailedLoading({required this.error});
  @override
  List<Object> get props => [];
}

final class ScheduleInitial extends ScheduleState {
  @override
  List<Object> get props => [];
}

final class ScheduleLoading extends ScheduleState {
  @override
  List<Object> get props => [];
}

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleLoading()) {
    on<LoadCabinetWeek>(
      (final event, final emit) async {
        emit(ScheduleLoading());
        try {
          late List<Lesson> lessons;
          late List<Zamena> zamenas;
          await Future.wait(
            [
              Api.loadWeekCabinetSchedule(
                start: event.dateStart,
                end: event.dateEnd,
                cabinetID: event.cabinetID,
              ).then((final value) => lessons = value),
              Api.loadCabinetZamenas(
                cabinetID: event.cabinetID,
                start: event.dateStart,
                end: event.dateEnd,
              ).then((final value) => zamenas = value),
              Api.loadZamenaFileLinks(start: event.dateStart, end: event.dateEnd),
          ]);
          emit(ScheduleLoaded(
            lessons: lessons,
            zamenas: zamenas,
          ),);
        } catch (err) {
          emit(ScheduleFailedLoading(error: err.toString()));
        }
      },
      transformer: restartable(),
    );
    on<LoadTeacherWeek>(
      (final event, final emit) async {
        emit(ScheduleLoading());
        try {
          late List<Lesson> lessons;
          late List<Zamena> zamenas;
          late List<int> groupsID;
          await Future.wait([
            Api.loadWeekTeacherSchedule(
                    start: event.dateStart,
                    end: event.dateEnd,
                    teacherID: event.teacherID,)
                .then((final value) {
              final Teacher teacher = GetIt.I
                  .get<Data>()
                  .teachers
                  .where((final element) => element.id == event.teacherID)
                  .first;
              teacher.lessons = value;
              lessons = value;
              groupsID = List<int>.from(lessons.map((final e) => e.group));
            }),
            Api.loadTeacherZamenas(
                    teacherID: event.teacherID,
                    start: event.dateStart,
                    end: event.dateEnd,)
                .then((final value) => zamenas = value),
            Api.loadZamenaFileLinks(start: event.dateStart, end: event.dateEnd),
            Api.loadHolidays(event.dateStart, event.dateEnd),
          ]);

          await Future.wait([
            Api.loadZamenasFull(groupsID, event.dateStart, event.dateEnd),
            Api.loadLiquidation(groupsID, event.dateStart, event.dateEnd),
            Api.loadZamenas(
                    groupsID: groupsID,
                    start: event.dateStart,
                    end: event.dateEnd,)
                .then((final value) => zamenas.addAll(value)),
          ]);

          emit(ScheduleLoaded(
            lessons: lessons,
            zamenas: zamenas,
          ),);
        } catch (err) {
          emit(ScheduleFailedLoading(error: err.toString()));
        }
      },
      transformer: restartable(),
    );
    on<LoadInitial>((final event, final emit) async {
      final scheduleProvider_ = event.ref.read(scheduleProvider);
      emit(ScheduleLoading());
      try {
        GetIt.I.get<Talker>().debug('fetch data');
        await Future.wait([
          Api.loadTimings(),
          Api.loadDepartments(),
          Api.loadCourses(),
          Api.loadGroups(),
          Api.loadTeachers(),
          Api.loadCabinets(),
        ]);
        if (event.context.mounted) {
          event.ref.read(searchProvider).updateSearchItems();
        }

        if (scheduleProvider_.groupIDSeek == -1 &&
            scheduleProvider_.searchType == SearchType.group) {
          emit(ScheduleInitial());
          return;
        }

        if (scheduleProvider_.searchType == SearchType.group) {
          if (event.context.mounted) {
            scheduleProvider_.groupSelected(
                scheduleProvider_.groupIDSeek, event.context,);
          }
        } else if (scheduleProvider_.searchType == SearchType.cabinet) {
          if (event.context.mounted) {
            scheduleProvider_.cabinetSelected(
                scheduleProvider_.cabinetIDSeek, event.context,);
          }
        } else if (scheduleProvider_.searchType == SearchType.teacher) {
          if (event.context.mounted) {
            scheduleProvider_.teacherSelected(
                scheduleProvider_.teacherIDSeek, event.context,);
          }
        } else {
          if (scheduleProvider_.groupIDSeek != -1) {
            final DateTime monday = scheduleProvider_.navigationDate.subtract(
                Duration(days: scheduleProvider_.navigationDate.weekday - 1),);
            final DateTime sunday = monday.add(const Duration(days: 6));
            final DateTime startOfWeek =
                DateTime(monday.year, monday.month, monday.day);
            final DateTime endOfWeek =
                DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);
            if (event.context.mounted) {
              add(LoadGroupWeek(
                  groupID: scheduleProvider_.groupIDSeek,
                  dateStart: startOfWeek,
                  dateEnd: endOfWeek,),);
            }
          } else {
            emit(ScheduleInitial());
          }
        }
      } catch (err) {
        emit(ScheduleFailedLoading(error: err.toString()));
      }
    });
    on<LoadGroupWeek>(
      (final event, final emit) async {
        emit(ScheduleLoading());

        try {
          final results = await Future.wait([
            Api.loadZamenaFileLinks(start: event.dateStart, end: event.dateEnd),
            Api.loadZamenasFull(
                [event.groupID], event.dateStart, event.dateEnd,),
            Api.loadWeekSchedule(
                start: event.dateStart,
                end: event.dateEnd,
                groupID: event.groupID,),
            Api.loadZamenas(
                groupsID: [event.groupID],
                start: event.dateStart,
                end: event.dateEnd,),
            Api.loadLiquidation([event.groupID], event.dateStart, event.dateEnd),
          ]);

          emit(ScheduleLoaded(
            lessons: results[2] as List<Lesson>,
            zamenas: results[3] as List<Zamena>,
          ),);
        } catch (e) {
          // Обработка ошибок
          emit(ScheduleFailedLoading(error: e.toString()));
        }
      },
      transformer: restartable(),
    );
  }
}
