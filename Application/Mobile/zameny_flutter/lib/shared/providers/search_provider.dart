import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';
import 'package:zameny_flutter/shared/providers/groups_provider.dart';


final searchItemsProvider = FutureProvider<List<SearchItem>>((final ref) async {
  return [
    ...ref.watch(groupsProvider).valueOrNull ?? [],
    ...ref.watch(cabinetsProvider).valueOrNull ?? [],
    ...ref.watch(teachersProvider).valueOrNull ?? [],
  ];
});

final filterSearchQueryProvider = StateProvider<String>((final ref) {
  return '';
});

final filteredSearchItemsProvider = FutureProvider<List<SearchItem>>((final ref) async {
  final query = ref.watch(filterSearchQueryProvider);

  if (query.isEmpty) {
    return [];
  }

  final searchItems = ref.watch(searchItemsProvider).valueOrNull ?? [];
  final res = await compute(filterItems, [searchItems, query]);
  // final res = searchItems.where((final element) => element.getFiltername().toLowerCase().contains(query.toLowerCase())).toList();
  return res;
});


List<SearchItem> filterItems(final List<dynamic> data) {
  return data[0].where((final element) => element.getFiltername().toLowerCase().contains(data[1].toLowerCase())).toList();
}
