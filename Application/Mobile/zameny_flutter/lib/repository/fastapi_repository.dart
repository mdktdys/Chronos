import 'package:dio/dio.dart';

import 'package:zameny_flutter/models/course/course_model.dart';
import 'package:zameny_flutter/models/group_model.dart';
import 'package:zameny_flutter/models/lesson/lesson_model.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/models/paras/paras_filter.dart';
import 'package:zameny_flutter/models/paras/paras_model.dart';
import 'package:zameny_flutter/models/subscribtion_model.dart';
import 'package:zameny_flutter/models/teacher_model.dart';
import 'package:zameny_flutter/models/telegram_zamena_link_model.dart';
import 'package:zameny_flutter/models/zamenaFileLink_model.dart';
import 'package:zameny_flutter/models/zamena_full/zamena_full_filter.dart';
import 'package:zameny_flutter/models/zamena_full/zamena_full_model.dart';
import 'package:zameny_flutter/models/zamena_model.dart';
import 'package:zameny_flutter/models/zamena_type_model.dart';
import 'package:zameny_flutter/repository/reposiory.dart';

class FastAPIDataRepository implements DataRepository {
  final String url = 'https://api.uksivt.xyz/api/v1';
  final Dio dio = Dio();

  static String _buildQueryString(final List<MapEntry<String, String>> params) {
    return params.map((final e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}').join('&');
  }

  @override
  Future<List<Group>> getGroups() async {
    final Response response = await dio.get('$url/groups/');
    return (response.data as List).map((final item) => Group.fromMap(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Cabinet>> getCabinets() async {
    final Response response = await dio.get('$url/cabinets/');
    return (response.data as List).map((final item) => Cabinet.fromMap(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Course>> getCourses() async {
    final Response response = await dio.get('$url/courses/');
    return (response.data as List).map((final item) => Course.fromMap(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Teacher>> getTeachers() async {
    final Response response = await dio.get('$url/teachers/');
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
    final List<MapEntry<String, String>> queryParams = lessonsFilter.toQueryParams();
    final String queryString = _buildQueryString(queryParams);

    final Response response = await dio.get(
      '$url/lessons/?$queryString',
    );

    return (response.data as List).map((final item) => Lesson.fromMap(item as Map<String, dynamic>)).toList();
  }


  @override
  Future<List<MessagingClient>> getMessagingClients() {
    throw UnimplementedError();
  }

  @override
  Future<List<LessonTimings>> getTimings() async {
    final Response response = await dio.get('$url/timings/');
    return (response.data as List).map((final item) => LessonTimings.fromMap(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<ZamenaFileLink>> getZamenaFileLinks() {
    throw UnimplementedError();
  }

  @override
  Future<List<Zamena>> getZamenas(final LessonFilter lessonsFilter) async {
    final List<MapEntry<String, String>> queryParams = lessonsFilter.toQueryParams();
    final String queryString = _buildQueryString(queryParams);

    final Response response = await dio.get(
      '$url/zamenas/?$queryString',
    );

    return (response.data as List).map((final item) => Zamena.fromMap(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<ZamenaFull>> getZamenasFull(final ZamenaFullFilter filter) async {
    final List<MapEntry<String, String>> queryParams = filter.toQueryParams();
    final String queryString = _buildQueryString(queryParams);

    final Response response = await dio.get(
      '$url/zamenas_full/?$queryString',
    );

    return (response.data as List).map((final item) => ZamenaFull.fromMap(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> updateMessagingClient(final MessagingClient messagingClient) {
    throw UnimplementedError();
  }
}
