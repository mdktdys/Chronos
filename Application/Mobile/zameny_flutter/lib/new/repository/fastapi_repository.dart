import 'package:dio/dio.dart';

import 'package:zameny_flutter/filters/paras_filter.dart';
import 'package:zameny_flutter/new/repository/reposiory.dart';
import 'package:zameny_flutter/models/course/course_model.dart';
import 'package:zameny_flutter/models/group_model.dart';
import 'package:zameny_flutter/models/paras_model.dart';
import 'package:zameny_flutter/models/teacher_model.dart';
import 'package:zameny_flutter/models/zamena_type_model.dart';

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
}
