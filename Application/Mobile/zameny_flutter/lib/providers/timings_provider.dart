
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/repository/reposiory.dart';

final timingsProvider = AsyncNotifierProvider<TimingsNotifier, List<LessonTimings>>((){
  return TimingsNotifier();
});

class TimingsNotifier extends AsyncNotifier<List<LessonTimings>> {

  @override
  FutureOr<List<LessonTimings>> build() {
    return GetIt.I.get<DataRepository>().getTimings();
  }

  static List<LessonTimings> fake() {
    return List.generate(7, (final index) {
      return LessonTimings.fake();
    });
  }
}
