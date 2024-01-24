import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/Services/Api.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/presentation/Widgets/CourseTile.dart';

@immutable
sealed class ScheduleEvent {}

final class FetchData extends ScheduleEvent {
  final int groupID;
  final DateTime dateStart;
  final DateTime dateEnd;

  FetchData(
      {required this.groupID, required this.dateStart, required this.dateEnd});
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

final class LoadCabinetWeek extends ScheduleEvent {
  final int cabinetID;
  final DateTime dateStart;
  final DateTime dateEnd;

  LoadCabinetWeek(
      {required this.cabinetID,
      required this.dateStart,
      required this.dateEnd});
}

final class LoadInitial extends ScheduleEvent {}

sealed class ScheduleState {}

final class ScheduleLoaded extends ScheduleState {
  List<Lesson> lessons = [];
  List<Zamena> zamenas = [];
  final CourseTileType searchType;
  ScheduleLoaded(
      {required this.lessons, required this.zamenas, required this.searchType});
}

final class ScheduleFailedLoading extends ScheduleState {}

final class ScheduleInitial extends ScheduleState {}

final class ScheduleLoading extends ScheduleState {}

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial()) {
    on<LoadCabinetWeek>((event, emit) async {
      emit(ScheduleLoading());
      try {
        List<Lesson> lessons = await Api().loadWeekCabinetSchedule(
            start: event.dateStart,
            end: event.dateEnd,
            cabinetID: event.cabinetID);
        List<Zamena> zamenas = await Api().loadCabinetZamenas(
            cabinetID: event.cabinetID,
            start: event.dateStart,
            end: event.dateEnd);
        GetIt.I.get<Talker>().critical(zamenas);
        emit(ScheduleLoaded(
            lessons: lessons,
            zamenas: zamenas,
            searchType: CourseTileType.cabinet));
      } catch (err) {
        GetIt.I.get<Talker>().critical(err);
        emit(ScheduleFailedLoading());
      }
    });
    on<LoadTeacherWeek>((event, emit) async {
      emit(ScheduleLoading());
      try {
        List<Lesson> lessons = await Api().loadWeekTeacherSchedule(
            start: event.dateStart,
            end: event.dateEnd,
            teacherID: event.teacherID);
        List<Zamena> zamenas = await Api().loadTeacherZamenas(
            teacherID: event.teacherID,
            start: event.dateStart,
            end: event.dateEnd);
        GetIt.I.get<Talker>().critical(zamenas);
        emit(ScheduleLoaded(
            lessons: lessons,
            zamenas: zamenas,
            searchType: CourseTileType.teacher));
      } catch (err) {
        GetIt.I.get<Talker>().critical(err);
        emit(ScheduleFailedLoading());
      }
    });
    on<LoadInitial>((event, emit) async {
      emit(ScheduleLoading());
      try {
        await Api().loadGroups();
        await Api().loadDepartments();
      } catch (error) {
        emit(ScheduleFailedLoading());
      }
    });
    on<FetchData>((event, emit) async {
      emit(ScheduleLoading());
      try {
        await Api().loadTeachers();
        await Api().loadCourses();
        await Api().loadCabinets();
        await Api().loadTimings();
        List<Lesson> lessons = await Api().loadWeekSchedule(
            start: event.dateStart, end: event.dateEnd, groupID: event.groupID);
        await Api()
            .loadZamenaFileLinks(start: event.dateStart, end: event.dateEnd);
        List<Zamena> zamenas = await Api().loadZamenas(
            groupID: event.groupID, start: event.dateStart, end: event.dateEnd);
        emit(ScheduleLoaded(
            lessons: lessons,
            zamenas: zamenas,
            searchType: CourseTileType.group));
      } catch (error) {
        emit(ScheduleFailedLoading());
      }
    });
  }
}
