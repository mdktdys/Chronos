import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';

final searchItemProvider = StateNotifierProvider<SearchItemNotifier, SearchItem?>((final Ref ref) {
  return SearchItemNotifier(ref: ref);
});

class SearchItemNotifier extends StateNotifier<SearchItem?> {
  bool isLoading = false;
  final Ref ref;

  SearchItemNotifier({required this.ref}): super(null);
  
  Future<void> getSearchItem({
    required final int id,
    required final int type
  }) async {
    isLoading = true;
    final SearchItem? item = await ref.watch(futureSearchItemProvider((
      type: type,
      id: id,
    )).future);

    if (item != null) {
      state = item;
    }

    isLoading = false;
  }

  void setState(final SearchItem? value) {
    state = value;
  }
}
