import 'package:zameny_flutter/models/models.dart';

abstract class DataRepository {
  Future<List<Group>> getGroups();
}
