
import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/new/notapi.dart';

part 'zamena_provider.freezed.dart';
part 'zamena_provider.g.dart';

@freezed
sealed class ZamenaScreenState with _$ZamenaScreenState {
  factory ZamenaScreenState({
    required final DateTime currentDate,
    required final ZamenaViewType view,
  }) = _ZamenaScreenState;
}

@riverpod
class ZamenaScreen extends _$ZamenaScreen {
  @override
  ZamenaScreenState build() {
    return ZamenaScreenState(
      currentDate: DateTime.now(),
      view: ZamenaViewType.teacher
    );
  }

  void toggleWeek(final int days) {
    DateTime newDate = state.currentDate.add(Duration(days: days));
    if (newDate.weekday == 7) {
      newDate = newDate.add(Duration(days: days));
    }
    state = state.copyWith(currentDate: newDate);
  }

  void changeView(final ZamenaViewType view) {
    state = state.copyWith(view: view);
  }
}

enum ZamenaViewType {
  teacher,
  group
}

final zamenasListProvider = AsyncNotifierProvider<ZamenasNotifier, (List<Zamena>,List<ZamenaFull>)>((){
  return ZamenasNotifier();
});

class ZamenasNotifier extends AsyncNotifier<(List<Zamena>,List<ZamenaFull>)> {

  @override
  FutureOr<(List<Zamena>,List<ZamenaFull>)> build() async {
    final DateTime date = ref.watch(zamenaScreenProvider).currentDate;
    try {
      final result = await Future.wait([
        Api.getZamenasByDate(date: date),
        Api.getFullZamenasByDate(date),
        Api.loadZamenaFileLinksByDate(date: date),
      ].toList());
      return (result[0] as List<Zamena>,result[1] as List<ZamenaFull>);
    } catch (e) {
      return (List<Zamena>.empty(),List<ZamenaFull>.empty());
    }
  }

  static (List<Zamena>,List<ZamenaFull>) fake() {
    return (List<Zamena>.empty(),List<ZamenaFull>.empty());
  }
}
