import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';

final searchProvider = ChangeNotifierProvider<SearchProvider>((final ref) {
  return SearchProvider();
});

class SearchProvider extends ChangeNotifier {
  List<SearchItem> searchItems = [];

  SearchProvider() {
    updateSearchItems();
  }

  void updateSearchItems() {
    searchItems.clear();
    searchItems.addAll(GetIt.I.get<Data>().groups);
    searchItems.addAll(GetIt.I.get<Data>().cabinets);
    searchItems.addAll(GetIt.I.get<Data>().teachers);
    int index = 0;
    for (SearchItem item in searchItems) {
      item.s = index;
    }
    notifyListeners();
  }
}
