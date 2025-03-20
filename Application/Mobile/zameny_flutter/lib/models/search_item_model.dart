import 'package:zameny_flutter/models/models.dart';

abstract class SearchItem {
  int id;
  int typeId;
  String name;
  int s = 0;

  SearchItem({
    required this.id,
    required this.name,
    required this.typeId,
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
