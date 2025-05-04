import 'package:zameny_flutter/models/lesson_model.dart';

sealed class TileData {
  final Lesson lesson;

  TileData({required this.lesson});
}

class TileWithZamenaData extends TileData {
  TileWithZamenaData({required super.lesson});
}
class TileRemovedLessonData extends TileData {
  TileRemovedLessonData({required super.lesson});
}
class TileLessonData extends TileData {
  TileLessonData({required super.lesson});
}

class TileZamenaOnLesson extends TileData {
  final Lesson zamena;

  TileZamenaOnLesson({required super.lesson, required this.zamena});
}
