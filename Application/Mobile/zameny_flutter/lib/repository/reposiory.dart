import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/models/paras/paras_filter.dart';
import 'package:zameny_flutter/models/paras/paras_model.dart';
import 'package:zameny_flutter/models/zamena_full/zamena_full_filter.dart';

abstract class DataRepository {
  // Groups
  Future<List<Group>> getGroups();


  // Teachers
  Future<List<Teacher>> getTeachers();


  // Cabinets
  Future<List<Cabinet>> getCabinets();


  // Courses
  Future<List<Course>> getCourses();


  // Paras
  Future<List<Paras>> getParas(final ParasFilter filter);


  // Zamenas
  Future<List<Zamena>> getZamenas(final LessonFilter filter);


  // Checks
  Future<List<DateTime>> getChecks();


  // MessaginClients
  Future<List<MessagingClient>> getMessagingClients();

  Future<void> deleteMessagingClient(final String id);

  Future<void> createMessagingClient(final MessagingClient messagingClient);

  Future<void> updateMessagingClient(final MessagingClient messagingClient);


  // Lessons
  Future<List<Lesson>> getLessons(final LessonFilter lessonsFilter);


  // Timings
  Future<List<LessonTimings>> getTimings();


  // ZamenasFull
  Future<List<ZamenaFull>> getZamenasFull(final ZamenaFullFilter zamenafullFilter);


  // ZamenaFileLinks
  Future<List<ZamenaFileLink>> getZamenaFileLinks();


  // AlreadyFoundsLinks
  Future<List<TelegramZamenaLinks>> getAlreadyFoundLinks();
}
