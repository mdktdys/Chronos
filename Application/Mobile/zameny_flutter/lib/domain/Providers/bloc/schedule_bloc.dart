import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/domain/Services/Api.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/domain/Providers/search_provider.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';
import 'package:zameny_flutter/domain/Models/models.dart';

@immutable
sealed class ScheduleEvent {}

final class FetchData extends ScheduleEvent {
  final BuildContext context;
  final int groupID;
  final DateTime dateStart;
  final DateTime dateEnd;

  FetchData(
      {required this.groupID,
      required this.dateStart,
      required this.dateEnd,
      required this.context});
}

final class LoadWeek extends ScheduleEvent {
  final int groupID;
  final DateTime dateStart;
  final DateTime dateEnd;

  LoadWeek(
      {required this.groupID, required this.dateStart, required this.dateEnd});
}

final class LoadTeacherWeek extends ScheduleEvent {
  final int teacherID;
  final DateTime dateStart;
  final DateTime dateEnd;

  LoadTeacherWeek(
      {required this.teacherID,
      required this.dateStart,
      required this.dateEnd});
}

final class LoadGroupWeek extends ScheduleEvent {
  final int groupID;
  final DateTime dateStart;
  final DateTime dateEnd;

  LoadGroupWeek(
      {required this.groupID, required this.dateStart, required this.dateEnd});
}

final class LoadCabinetWeek extends ScheduleEvent {
  final int cabinetID;
  final DateTime dateStart;
  final DateTime dateEnd;

  LoadCabinetWeek(
      {required this.cabinetID,
      required this.dateStart,
      required this.dateEnd});
}

final class LoadInitial extends ScheduleEvent {
  final BuildContext context;
  LoadInitial({required this.context});
}

sealed class ScheduleState extends Equatable {}

class ScheduleLoaded extends ScheduleState {
  List<Lesson> lessons = [];
  List<Zamena> zamenas = [];
  ScheduleLoaded({required this.lessons, required this.zamenas});

  @override
  List<Object> get props => [this.lessons, this.zamenas];
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
      (event, emit) async {
        emit(ScheduleLoading());
        try {
          late List<Lesson> lessons;
          late List<Zamena> zamenas;
          await Future.wait([
            Api
                .loadWeekCabinetSchedule(
                    start: event.dateStart,
                    end: event.dateEnd,
                    cabinetID: event.cabinetID)
                .then((value) => lessons = value),
            Api
                .loadCabinetZamenas(
                    cabinetID: event.cabinetID,
                    start: event.dateStart,
                    end: event.dateEnd)
                .then((value) => zamenas = value),
            Api
                .loadZamenaFileLinks(start: event.dateStart, end: event.dateEnd)
          ]);
          emit(ScheduleLoaded(
            lessons: lessons,
            zamenas: zamenas,
          ));
        } catch (err) {
          emit(ScheduleFailedLoading(error: err.toString()));
        }
      },
      transformer: restartable(),
    );
    on<LoadTeacherWeek>(
      (event, emit) async {
        emit(ScheduleLoading());
        try {
          late List<Lesson> lessons;
          late List<Zamena> zamenas;
          late List<int> groupsID;
          await Future.wait([
            Api
                .loadWeekTeacherSchedule(
                    start: event.dateStart,
                    end: event.dateEnd,
                    teacherID: event.teacherID)
                .then((value) {
              lessons = value;
              groupsID = List<int>.from(lessons.map((e) => e.group));
            }),
            Api
                .loadTeacherZamenas(
                    teacherID: event.teacherID,
                    start: event.dateStart,
                    end: event.dateEnd)
                .then((value) => zamenas = value),
            Api.loadZamenaFileLinks(
                start: event.dateStart, end: event.dateEnd),
            Api.loadHolidays(event.dateStart, event.dateEnd)
          ]);

          await Future.wait([
            Api.loadZamenasFull(groupsID, event.dateStart, event.dateEnd),
            Api.loadLiquidation(groupsID, event.dateStart, event.dateEnd),
            Api
                .loadZamenas(
                    groupsID: groupsID,
                    start: event.dateStart,
                    end: event.dateEnd)
                .then((value) => zamenas.addAll(value))
          ]);

          emit(ScheduleLoaded(
            lessons: lessons,
            zamenas: zamenas,
          ));
        } catch (err) {
          emit(ScheduleFailedLoading(error: err.toString()));
        }
      },
      transformer: restartable(),
    );
    on<LoadInitial>((event, emit) async {
      ScheduleProvider searchProvider =
          Provider.of<ScheduleProvider>(event.context, listen: false);
      emit(ScheduleLoading());
      try {
        GetIt.I.get<Talker>().debug("fetch data");
        await Future.wait([
          Api.loadTimings(),
          Api.loadDepartments(),
          Api.loadCourses(),
          Api.loadGroups(),
          Api.loadTeachers(),
          Api.loadCabinets(),
        ]);
        if (event.context.mounted) {
          Provider.of<SearchProvider>(event.context, listen: false)
              .updateSearchItems();
        }

        if (searchProvider.groupIDSeek == -1 && searchProvider.searchType == SearchType.group) {
          emit(ScheduleInitial());
          return;
        }

        if (searchProvider.searchType == SearchType.group) {
          if (event.context.mounted) {
            searchProvider.groupSelected(
                searchProvider.groupIDSeek, event.context);
          }
        } else if (searchProvider.searchType == SearchType.cabinet) {
          if (event.context.mounted) {
            searchProvider.cabinetSelected(
                searchProvider.cabinetIDSeek, event.context);
          }
        } else if (searchProvider.searchType == SearchType.teacher) {
          if (event.context.mounted) {
            searchProvider.teacherSelected(
                searchProvider.teacherIDSeek, event.context);
          }
        } else {
          if (searchProvider.groupIDSeek != -1) {
            DateTime monday = searchProvider.navigationDate.subtract(
                Duration(days: searchProvider.navigationDate.weekday - 1));
            DateTime sunday = monday.add(const Duration(days: 6));
            DateTime startOfWeek =
                DateTime(monday.year, monday.month, monday.day);
            DateTime endOfWeek =
                DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);
            if (event.context.mounted) {
              add(LoadGroupWeek(
                  groupID: searchProvider.groupIDSeek,
                  dateStart: startOfWeek,
                  dateEnd: endOfWeek));
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
      (event, emit) async {
        emit(ScheduleLoading());
        late List<Lesson> lessons;
        late List<Zamena> zamenas;
        await Future.wait([
          Api.loadZamenaFileLinks(start: event.dateStart, end: event.dateEnd),
          Api
              .loadZamenasFull([event.groupID], event.dateStart, event.dateEnd),
          Api
              .loadWeekSchedule(
                  start: event.dateStart,
                  end: event.dateEnd,
                  groupID: event.groupID)
              .then((value) => lessons = value),
          Api.loadZamenas(
              groupsID: [event.groupID],
              start: event.dateStart,
              end: event.dateEnd).then((value) => zamenas = value),
          Api.loadLiquidation([event.groupID], event.dateStart, event.dateEnd)
        ]);
        emit(ScheduleLoaded(
          lessons: lessons,
          zamenas: zamenas,
        ));
      },
      transformer: restartable(),
    );
  }
}
