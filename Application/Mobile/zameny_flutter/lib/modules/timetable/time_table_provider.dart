import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/new/repository/reposiory.dart';

part 'time_table_provider.freezed.dart';
part 'time_table_provider.g.dart';

@freezed
sealed class TimeTableState with _$TimeTableState {
  factory TimeTableState({
    required final bool saturday,
    required final bool obed,
  }) = _TimeTableState;
}

@riverpod
class TimeTableNotifier extends _$TimeTableNotifier {
  @override
  TimeTableState build() {
    return TimeTableState(
      obed: false,
      saturday: false
    );
  }

  void toggleObed() {
    state = state.copyWith(obed: !state.obed);
  }

  void toggleSaturday() {
    state = state.copyWith(saturday: !state.saturday);
  }
}


final timingProvider = FutureProvider<List<LessonTimings>>((final ref) async {
  final DataRepository repository = GetIt.I.get<DataRepository>();
  return await repository.getTimings();
});
