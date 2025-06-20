import 'package:zameny_flutter/filters/paras_filter.dart';
import 'package:zameny_flutter/models/models.dart';

abstract class DataRepository {
  Future<List<Group>> getGroups();

  Future<List<Teacher>> getTeachers();

  Future<List<Cabinet>> getCabinets();

  Future<List<Course>> getCourses();

  Future<List<Paras>> getParas(final ParasFilter filter);

  Future<List<DateTime>> getChecks();

  Future<List<MessagingClient>> getMessagingClients();
}
