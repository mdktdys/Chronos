// import 'dart:developer';

// import 'package:equatable/equatable.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';
// import 'package:zameny_flutter/models/models.dart';
// import 'package:zameny_flutter/services/Api.dart';
// import 'package:zameny_flutter/shared/providers/groups_provider.dart';
// import 'package:zameny_flutter/shared/providers/schedule_provider.dart';


// class ScheduleState extends Equatable {
//   final bool isLoading;
//   final List<Lesson> lessons;
//   final List<Zamena> zamenas;
//   final String? error;

//   const ScheduleState({
//     this.isLoading = false,
//     this.lessons = const [],
//     this.zamenas = const [],
//     this.error,
//   });

//   ScheduleState copyWith({
//     final bool? isLoading,
//     final List<Lesson>? lessons,
//     final List<Zamena>? zamenas,
//     final String? error,
//   }) {
//     return ScheduleState(
//       isLoading: isLoading ?? this.isLoading,
//       lessons: lessons ?? this.lessons,
//       zamenas: zamenas ?? this.zamenas,
//       error: error,
//     );
//   }

//   @override
//   List<Object?> get props => [isLoading, lessons, zamenas, error];
// }


// class ScheduleNotifier extends StateNotifier<ScheduleState> {
//   ScheduleNotifier() : super(const ScheduleState());

//   Future<void> loadCabinetWeek({
//     required final int cabinetID,
//     required final DateTime dateStart,
//     required final DateTime dateEnd,
//   }) async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final lessons = await Api.loadWeekCabinetSchedule(
//         start: dateStart,
//         end: dateEnd,
//         cabinetID: cabinetID,
//       );
//       final zamenas = await Api.loadCabinetZamenas(
//         cabinetID: cabinetID,
//         start: dateStart,
//         end: dateEnd,
//       );

//       state = state.copyWith(
//         isLoading: false,
//         lessons: lessons,
//         zamenas: zamenas,
//       );
//     } catch (error) {
//       state = state.copyWith(
//         isLoading: false,
//         error: error.toString(),
//       );
//     }
//   }

//   Future<void> loadTeacherWeek({
//     required final int teacherID,
//     required final DateTime dateStart,
//     required final DateTime dateEnd,
//   }) async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final lessons = await Api.loadWeekTeacherSchedule(
//         start: dateStart,
//         end: dateEnd,
//         teacherID: teacherID,
//       );
//       final zamenas = await Api.loadTeacherZamenas(
//         teacherID: teacherID,
//         start: dateStart,
//         end: dateEnd,
//       );

//       state = state.copyWith(
//         isLoading: false,
//         lessons: lessons,
//         zamenas: zamenas,
//       );
//     } catch (error) {
//       state = state.copyWith(
//         isLoading: false,
//         error: error.toString(),
//       );
//     }
//   }

//   Future<void> loadGroupWeek({
//     required final int groupID,
//     required final DateTime dateStart,
//     required final DateTime dateEnd,
//   }) async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final lessons = await Api.loadWeekSchedule(
//         start: dateStart,
//         end: dateEnd,
//         groupID: groupID,
//       );
//       final zamenas = await Api.loadZamenas(
//         groupsID: [groupID],
//         start: dateStart,
//         end: dateEnd,
//       );

//       state = state.copyWith(
//         isLoading: false,
//         lessons: lessons,
//         zamenas: zamenas,
//       );
//     } catch (error) {
//       state = state.copyWith(
//         isLoading: false,
//         error: error.toString(),
//       );
//     }
//   }
// }

// final riverpodScheduleProvider =
//     StateNotifierProvider<ScheduleNotifier, ScheduleState>(
//   (final ref) => ScheduleNotifier(),
// );
