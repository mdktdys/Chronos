import 'package:zameny_flutter/modules/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/shared/domain/models/models.dart';

abstract class SearchItem {
  SearchType type;
  String name;
  int typeId;
  int s = 0;
  int id;

  SearchItem({
    required this.id,
    required this.name,
    required this.typeId,
    required this.type,
  });

  String get typeName {
    if (this is Group) {
      return 'Группа';
    }
    if (this is Cabinet) {
      return 'Кабинет';
    }
    if (this is Teacher) {
      return 'Преподаватель';
    }
    return '';
  }
}
