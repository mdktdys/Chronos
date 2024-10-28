import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zameny_flutter/domain/Models/models.dart';
import 'package:zameny_flutter/domain/Services/Api.dart';


enum ZamenaView {
  teacher,
  group
}

final zamenaProvider = ChangeNotifierProvider<ZamenaProvider>((ref) {
  return ZamenaProvider(ref: ref);
});

class ZamenaProvider extends ChangeNotifier{
  Ref ref;

  ZamenaProvider({required this.ref});

  DateTime currentDate = DateTime.now();
  ZamenaView zamenaView = ZamenaView.group;

  void toggleWeek(int days, BuildContext context) {
    currentDate = currentDate.add(Duration(days: days));
    if(currentDate.weekday == 7){
      currentDate = currentDate.add(Duration(days: days));
    }
    notifyListeners();
  }
}

extension DateTimeExtension on DateTime{
  String formatyyyymmdd(){
    return "$year.$month.$day";
  }
}

final zamenasListProvider = FutureProvider<(List<Zamena>,List<ZamenaFull>,List<ZamenaFileLink>)>((ref) async {
  final currentDate = ref.watch(zamenaProvider).currentDate;
  try {
    final result = await Future.wait([
      Api.getZamenasByDate(date: currentDate),
      Api.getFullZamenasByDate(currentDate),
      Api.loadZamenaFileLinksByDate(date: currentDate)
    ]);
    return (result[0] as List<Zamena>,result[1] as List<ZamenaFull>,result[2] as List<ZamenaFileLink>);
  } catch (e) {
    log("Ошибка загрузки замен: $e");
    return (List<Zamena>.empty(),List<ZamenaFull>.empty(),List<ZamenaFileLink>.empty());
  }
});