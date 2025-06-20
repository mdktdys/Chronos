import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zameny_flutter/filters/paras_filter.dart';
import 'package:zameny_flutter/new/repository/reposiory.dart';
import 'package:zameny_flutter/secrets.dart';
import 'package:zameny_flutter/models/course/course_model.dart';
import 'package:zameny_flutter/models/group_model.dart';
import 'package:zameny_flutter/models/paras_model.dart';
import 'package:zameny_flutter/models/teacher_model.dart';
import 'package:zameny_flutter/models/zamena_type_model.dart';

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
}
