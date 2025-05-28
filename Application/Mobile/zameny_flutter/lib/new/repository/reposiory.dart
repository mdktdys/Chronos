import 'package:zameny_flutter/shared/domain/models/models.dart';

abstract class DataRepository {
  Future<List<Group>> getGroups();
}
