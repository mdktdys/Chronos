import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';


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
  final res = searchItems.where((final element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();
  return res;
});


List<SearchItem> filterItems(final List<dynamic> data) {
  return data[0].where((final element) => element.getFiltername().toLowerCase().contains(data[1].toLowerCase())).toList();
}
