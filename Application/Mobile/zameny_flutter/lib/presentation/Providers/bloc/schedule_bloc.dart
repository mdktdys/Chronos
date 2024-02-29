import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/Services/Api.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/presentation/Providers/schedule_provider.dart';
import 'package:zameny_flutter/presentation/Widgets/CourseTile.dart';

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

sealed class ScheduleState {}

final class ScheduleLoaded extends ScheduleState {
  List<Lesson> lessons = [];
  List<Zamena> zamenas = [];
  ScheduleLoaded({required this.lessons, required this.zamenas});
}

final class ScheduleFailedLoading extends ScheduleState {
  final String error;
  ScheduleFailedLoading({required this.error});
}

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
        emit(ScheduleLoaded(
          lessons: lessons,
          zamenas: zamenas,
        ));
      } catch (err) {
        GetIt.I.get<Talker>().critical(err);
        emit(ScheduleFailedLoading(error: err.toString()));
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
        Set<int> groupsID = Set<int>.from(lessons.map((e) => e.group));
        for (int group in groupsID) {
          Api().loadZamenasFull(group, event.dateStart, event.dateEnd);
          zamenas.addAll(await Api().loadZamenas(
              groupID: group, start: event.dateStart, end: event.dateEnd));
        }
        emit(ScheduleLoaded(
          lessons: lessons,
          zamenas: zamenas,
        ));
      } catch (err) {
        GetIt.I.get<Talker>().critical(err);
        emit(ScheduleFailedLoading(error: err.toString()));
      }
    });
    on<LoadInitial>((event, emit) async {
      ScheduleProvider searchProvider =
          Provider.of<ScheduleProvider>(event.context, listen: false);
      GetIt.I.get<Talker>().debug("init");
      emit(ScheduleLoading());
      try {
        await Api().loadGroups(event.context);
        await Api().loadDepartments();

        if (searchProvider.searchType == SearchType.group) {
          searchProvider.groupSelected(
              searchProvider.groupIDSeek, event.context);
        } else if (searchProvider.searchType == SearchType.cabinet) {
          searchProvider.cabinetSelected(
              searchProvider.cabinetIDSeek, event.context);
        } else if (searchProvider.searchType == SearchType.teacher) {
          searchProvider.teacherSelected(
              searchProvider.teacherIDSeek, event.context);
        } else {
          if (searchProvider.groupIDSeek != -1) {
            DateTime monday = searchProvider.navigationDate.subtract(
                Duration(days: searchProvider.navigationDate.weekday - 1));
            DateTime sunday = monday.add(const Duration(days: 6));
            DateTime startOfWeek =
                DateTime(monday.year, monday.month, monday.day);
            DateTime endOfWeek =
                DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);
            add(FetchData(
                groupID: searchProvider.groupIDSeek,
                dateStart: startOfWeek,
                dateEnd: endOfWeek,
                context: event.context));
          } else {
            emit(ScheduleInitial());
          }
        }
      } catch (err) {
        emit(ScheduleFailedLoading(error: err.toString()));
      }
    });
    on<FetchData>((event, emit) async {
      emit(ScheduleLoading());
      try {
        await Api().loadTeachers(event.context);
        await Api().loadCourses();
        await Api().loadCabinets(event.context);
        await Api()
            .loadZamenasFull(event.groupID, event.dateStart, event.dateEnd);
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
        ));
      } catch (err) {
        emit(ScheduleFailedLoading(error: err.toString()));
      }
    });
  }
}
