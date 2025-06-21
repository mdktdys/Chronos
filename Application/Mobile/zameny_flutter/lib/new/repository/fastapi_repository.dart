import 'package:dio/dio.dart';

import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/filters/paras_filter.dart';
import 'package:zameny_flutter/models/course/course_model.dart';
import 'package:zameny_flutter/models/group_model.dart';
import 'package:zameny_flutter/models/lesson_model.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/models/paras_model.dart';
import 'package:zameny_flutter/models/subscribtion_model.dart';
import 'package:zameny_flutter/models/teacher_model.dart';
import 'package:zameny_flutter/models/telegram_zamena_link_model.dart';
import 'package:zameny_flutter/models/zamenaFileLink_model.dart';
import 'package:zameny_flutter/models/zamena_full_model.dart';
import 'package:zameny_flutter/models/zamena_model.dart';
import 'package:zameny_flutter/models/zamena_type_model.dart';
import 'package:zameny_flutter/new/repository/reposiory.dart';

class FastAPIDataRepository implements DataRepository {
  final String url = 'https://api.uksivt.xyz/api/v1';
  final Dio dio = Dio();

  @override
  Future<List<Group>> getGroups() async {
    final Response response = await dio.get('$url/groups');
    return (response.data as List).map((final item) => Group.fromMap(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Cabinet>> getCabinets() async {
    final Response response = await dio.get('$url/cabinets');
    return (response.data as List).map((final item) => Cabinet.fromMap(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Course>> getCourses() async {
    final Response response = await dio.get('$url/courses');
    return (response.data as List).map((final item) => Course.fromMap(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Teacher>> getTeachers() async {
    final Response response = await dio.get('$url/teachers');
    return (response.data as List).map((final item) => Teacher.fromMap(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Paras>> getParas(final ParasFilter filter) {
    throw UnimplementedError();
  }

  @override
  Future<void> createMessagingClient(final MessagingClient messagingClient) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMessagingClient(final String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<TelegramZamenaLinks>> getAlreadyFoundLinks() {
    throw UnimplementedError();
  }

  @override
  Future<List<DateTime>> getChecks() {
    throw UnimplementedError();
  }

  @override
  Future<List<Lesson>> getLessons(final LessonFilter lessonsFilter) async {
    final Map<String, dynamic> queryParams = {};

    if (lessonsFilter.id != null) {
      queryParams['id'] = lessonsFilter.id;
    }
    if (lessonsFilter.number != null) {
      queryParams['number'] = lessonsFilter.number;
    }
    if (lessonsFilter.group != null) {
      queryParams['group'] = lessonsFilter.group;
    }
    if (lessonsFilter.startDate != null) {
      queryParams['start_date'] = lessonsFilter.startDate!.toyyyymmdd();
    }
    if (lessonsFilter.endDate != null) {
      queryParams['end_date'] = lessonsFilter.endDate!.toyyyymmdd();
    }
    if (lessonsFilter.course != null) {
      queryParams['course'] = lessonsFilter.course;
    }
    if (lessonsFilter.teacher != null) {
      queryParams['teacher'] = lessonsFilter.teacher;
    }
    if (lessonsFilter.cabinet != null) {
      queryParams['cabinet'] = lessonsFilter.cabinet;
    }

    final Response response = await dio.get(
      '$url/lessons',
      queryParameters: queryParams,
    );

    return (response.data as List).map((final item) => Lesson.fromMap(item as Map<String, dynamic>)).toList();
  }


  @override
  Future<List<MessagingClient>> getMessagingClients() {
    throw UnimplementedError();
  }

  @override
  Future<List<LessonTimings>> getTimings() {
    throw UnimplementedError();
  }

  @override
  Future<List<ZamenaFileLink>> getZamenaFileLinks() {
    throw UnimplementedError();
  }

  @override
  Future<List<Zamena>> getZamenas() {
    throw UnimplementedError();
  }

  @override
  Future<List<ZamenaFull>> getZamenasFull() {
    throw UnimplementedError();
  }

  @override
  Future<void> updateMessagingClient(final MessagingClient messagingClient) {
    throw UnimplementedError();
  }
}
