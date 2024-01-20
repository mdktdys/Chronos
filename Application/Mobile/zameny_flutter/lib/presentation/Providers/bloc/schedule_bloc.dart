import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/Services/Api.dart';
import 'package:zameny_flutter/Services/Data.dart';

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

final class LoadInitial extends ScheduleEvent {}

sealed class ScheduleState {}

final class ScheduleLoaded extends ScheduleState {
  List<Lesson> lessons = [];
  ScheduleLoaded({required this.lessons});
}

final class ScheduleFailedLoading extends ScheduleState {}

final class ScheduleInitial extends ScheduleState {}

final class ScheduleLoading extends ScheduleState {}

  class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial()) {
    on<LoadInitial>((event, emit) async {
      emit(ScheduleLoading());
      try {
        await Api().loadGroups();
        await Api().loadDepartments();
      } catch (error) {
        GetIt.I.get<Talker>().critical(error);
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
        List<Lesson> lessons = await Api().loadWeekSchedule(start: event.dateStart, end: event.dateEnd,groupID: event.groupID);
        await Api()
            .loadZamenaFileLinks(start: event.dateStart, end: event.dateEnd);
        await Api().loadZamenas(
            groupID: event.groupID, start: event.dateStart, end: event.dateEnd);
        emit(ScheduleLoaded(lessons:lessons));
      } catch (error) {
        GetIt.I.get<Talker>().critical(error);
        emit(ScheduleFailedLoading());
      }
    });
  }
}
