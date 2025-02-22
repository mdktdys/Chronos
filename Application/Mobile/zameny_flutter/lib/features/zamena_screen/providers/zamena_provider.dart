import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/services/Api.dart';

enum ZamenaViewType {
  teacher,
  group
}

final zamenaProvider = ChangeNotifierProvider<ZamenaProvider>((final ref) {
  return ZamenaProvider(ref: ref);
});

class ZamenaProvider extends ChangeNotifier{
  Ref ref;

  ZamenaProvider({required this.ref});

  DateTime currentDate = DateTime.now();
  ZamenaViewType zamenaView = ZamenaViewType.teacher;

  void toggleWeek(final int days) {
    currentDate = currentDate.add(Duration(days: days));
    if(currentDate.weekday == 7){
      currentDate = currentDate.add(Duration(days: days));
    }
    notifyListeners();
  }

  void changeView(final ZamenaViewType view){
    zamenaView = view;
    notifyListeners();
  }
}

final zamenasListProvider = AsyncNotifierProvider<ZamenasNotifier, (List<Zamena>,List<ZamenaFull>,List<ZamenaFileLink>)>((){
  return ZamenasNotifier();
});

class ZamenasNotifier extends AsyncNotifier<(List<Zamena>,List<ZamenaFull>,List<ZamenaFileLink>)> {

  @override
  FutureOr<(List<Zamena>,List<ZamenaFull>,List<ZamenaFileLink>)> build() async {
    final currentDate = ref.watch(zamenaProvider).currentDate;
    try {
      final result = await Future.wait([
        Api.getZamenasByDate(date: currentDate),
        Api.getFullZamenasByDate(currentDate),
        Api.loadZamenaFileLinksByDate(date: currentDate),
      ]);
      return (result[0] as List<Zamena>,result[1] as List<ZamenaFull>,result[2] as List<ZamenaFileLink>);
    } catch (e) {
      log('Ошибка загрузки замен: $e');
      return (List<Zamena>.empty(),List<ZamenaFull>.empty(),List<ZamenaFileLink>.empty());
    }
  }

  static (List<Zamena>,List<ZamenaFull>,List<ZamenaFileLink>) fake() {
    return (List<Zamena>.empty(),List<ZamenaFull>.empty(),List<ZamenaFileLink>.empty());
  }
}
