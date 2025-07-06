import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
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
import 'package:zameny_flutter/secrets.dart';


class SupabaseDataRepository implements DataRepository {
  final SupabaseClient client = SupabaseClient(API_URL, API_ANON_KEY);

  @override
  Future<List<Group>> getGroups() async {
    final response = await client.from('Groups').select();
    return response.map((final group) => Group.fromMap(group)).toList();
  }

  @override
  Future<List<Cabinet>> getCabinets() async {
    final response = await client.from('Cabinets').select();
    return response.map((final group) => Cabinet.fromMap(group)).toList();
  }

  @override
  Future<List<Course>> getCourses() async {
    final response = await client.from('Courses').select();
    return response.map((final group) => Course.fromMap(group)).toList();
  }

  @override
  Future<List<Paras>> getParas(final ParasFilter filter) {
    throw UnimplementedError();
  }

  @override
  Future<List<Teacher>> getTeachers() async {
    final response = await client.from('Teachers').select();
    return response.map((final group) => Teacher.fromMap(group)).toList();
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
    final query = GetIt.I.get<SupabaseClient>().from('Paras').select('id, group, number, course, teacher, cabinet, date');

    if (lessonsFilter.id != null) {
      query.eq('id', lessonsFilter.id!);
    }

    if (lessonsFilter.group != null) {
      query.eq('group', lessonsFilter.group!);
    }

    if (lessonsFilter.number != null) {
      query.eq('number', lessonsFilter.number!);
    }

    if (lessonsFilter.course != null) {
      query.eq('course', lessonsFilter.course!);
    }

    if (lessonsFilter.teacher != null) {
      query.eq('teacher', lessonsFilter.teacher!);
    }

    if (lessonsFilter.cabinet != null) {
      query.eq('cabinet', lessonsFilter.cabinet!);
    }

    if (lessonsFilter.startDate != null) {
      query.eq('start_date', lessonsFilter.startDate!.toyyyymmdd());
    }

    if (lessonsFilter.endDate != null) {
      query.eq('end_date', lessonsFilter.endDate!.toyyyymmdd());
    }

    final List<Map<String, dynamic>> data = await query;
    return data.map((final Map<String, dynamic> json) => Lesson.fromMap(json)).toList();
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
  Future<List<Zamena>> getZamenas(final LessonFilter lessonsFilter) {
    throw UnimplementedError();
  }

  @override
  Future<List<ZamenaFull>> getZamenasFull(final ZamenaFullFilter filter) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateMessagingClient(final MessagingClient messagingClient) {
    throw UnimplementedError();
  }
}
