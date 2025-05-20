import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zameny_flutter/models/group_model.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_provider.dart';
import 'package:zameny_flutter/new/notapi.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';

part 'zamena_groups_practice_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<Group>> fetchPracticeGroupsByDate(final Ref ref) async {
  final DateTime date = ref.watch(zamenaScreenProvider.select((final value) => value.currentDate));
  final List<int> groupIds = await Api.loadPracticeGroupsByDate(date: date);

  return groupIds.map((final int id) => ref.watch(groupProvider(id))!).toList();
}
