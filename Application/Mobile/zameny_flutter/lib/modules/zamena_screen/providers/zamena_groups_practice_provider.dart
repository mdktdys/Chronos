import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_provider.dart';
import 'package:zameny_flutter/repository/notapi.dart';
import 'package:zameny_flutter/providers/groups_provider.dart';

part 'zamena_groups_practice_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<Group>> fetchPracticeGroupsByDate(final Ref ref) async {
  final DateTime date = ref.watch(zamenaScreenProvider.select((final value) => value.currentDate));
  final List<int> groupIds = await Api.loadPracticeGroupsByDate(date: date);

  return groupIds.map((final int id) => ref.watch(groupProvider(id))!).toList();
}

@Riverpod()
Future<List<(Teacher, Cabinet)>> fetchTeacherCabinetSwaps(final Ref ref) async {
  final DateTime date = ref.watch(zamenaScreenProvider.select((final value) => value.currentDate));
  final List<(int, int)> swaps = await Api.loadTeacherCabinetSwaps(date: date);


  return swaps.map((final pair) {
    final Teacher teacher = ref.watch(teacherProvider(pair.$1))!;
    final Cabinet cabinet = ref.watch(cabinetProvider(pair.$2))!;
    return (teacher, cabinet);
  }).toList();
}
