
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/services/Api.dart';

final timingsProvider = AsyncNotifierProvider<TimingsNotifier, List<LessonTimings>>((){
  return TimingsNotifier();
});

class TimingsNotifier extends AsyncNotifier<List<LessonTimings>> {

  @override
  FutureOr<List<LessonTimings>> build() {
    return Api.getTimings();
  }

  static List<LessonTimings> fake() {
    return List.generate(7, (final index) {
      return LessonTimings.fake();
    });
  }
}
