  // static Future<void> loadGroups() async {
  //   final client = GetIt.I.get<SupabaseClient>();
  //   final dat = GetIt.I.get<Data>();

  //   final List<dynamic> data = await client.from('Groups').select();

  //   dat.groups = [];
  //   for (final element in data) {
  //     final Group groupName = Group.fromMap(element);
  //     dat.groups.add(groupName);
  //   }
  // }

  // static Future<void> loadTeachers() async {
  //   final client = GetIt.I.get<SupabaseClient>();
  //   final dat = GetIt.I.get<Data>();
  //   List<dynamic> data = List.empty();

  //   data = await client.from('Teachers').select();

  //   dat.teachers = [];
  //   for (final element in data) {
  //     final Teacher teacher = Teacher.fromMap(element);
  //     dat.teachers.add(teacher);
  //   }
  // }

  // static Future<void> loadCabinets() async {
  //   final client = GetIt.I.get<SupabaseClient>();
  //   final dat = GetIt.I.get<Data>();
  //   final List<dynamic> data = await client.from('Cabinets').select();

  //   dat.cabinets = [];
  //   for (final element in data) {
  //     final Cabinet cab = Cabinet.fromMap(element);
  //     dat.cabinets.add(cab);
  //   }
  // }


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';

final futureSearchItemProvider = FutureProvider.family<SearchItem?, ({int id, int type})>((final Ref ref, final ({int id, int type}) params) async {
  final int type = params.type;
  final int id = params.id;

  if (params.type == 1) {
    return (await ref.watch(groupsProvider.future)).where((final Group group) => group.id == id && group.typeId == type).firstOrNull;
  }

  if (params.type == 2) {
    return (await ref.watch(teachersProvider.future)).where((final Teacher group) => group.id == id && group.typeId == type).firstOrNull;
  }

  if (params.type == 3) {
    return (await ref.watch(cabinetsProvider.future)).where((final Cabinet group) => group.id == id && group.typeId == type).firstOrNull;
  }

  return null;
});

final groupsProvider = FutureProvider<List<Group>>((final Ref ref) async {
  final response = await GetIt.I.get<SupabaseClient>().from('Groups').select();
  return response.map((final group) => Group.fromMap(group)).toList();
});

final cabinetsProvider = FutureProvider<List<Cabinet>>((final Ref ref) async {
  final response = await GetIt.I.get<SupabaseClient>().from('Cabinets').select();
  return response.map((final group) => Cabinet.fromMap(group)).toList();
});

final teachersProvider = FutureProvider<List<Teacher>>((final Ref ref) async {
  final response = await GetIt.I.get<SupabaseClient>().from('Teachers').select();
  return response.map((final group) => Teacher.fromMap(group)).toList();
});

final coursesProvider = FutureProvider<List<Course>>((final Ref ref) async {
  final List<Map<String, dynamic>> data = await GetIt.I.get<SupabaseClient>().from('Courses').select();
    return data.map((final json) => Course.fromMap(json)).toList();
});

final groupProvider = StateProvider.family<Group?, int>((final Ref ref, final int id) {
  return ref.watch(groupsProvider).value?.where((final group) => group.id == id).firstOrNull;
});

final teacherProvider = StateProvider.family<Teacher?,int>((final Ref ref, final int id) {
  return ref.watch(teachersProvider).value?.where((final teacher) => teacher.id == id).firstOrNull;
});

final cabinetProvider = StateProvider.family<Cabinet?,int>((final Ref ref, final int id) {
  return ref.watch(cabinetsProvider).value?.where((final cabinet) => cabinet.id == id).firstOrNull;
});

final courseProvider = StateProvider.family<Course?,int>((final Ref ref, final int id) {
  return ref.watch(coursesProvider).value?.where((final cabinet) => cabinet.id == id).firstOrNull;
});

final timingProvider = StateProvider.family<LessonTimings?,int>((final Ref ref, final int id) {
  return ref.watch(timingsProvider).value?.where((final cabinet) => cabinet.number == id).firstOrNull;
});
