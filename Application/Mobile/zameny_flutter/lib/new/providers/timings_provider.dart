
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/shared/domain/models/lesson_timings_model.dart';
import 'package:zameny_flutter/new/notapi.dart';

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
