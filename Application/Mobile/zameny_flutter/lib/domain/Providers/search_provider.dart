import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/schedule_turbo_search.dart';

class SearchProvider extends ChangeNotifier {
  List<SearchItem> searchItems = [];

  SearchProvider(BuildContext context) {
    updateSearchItems();
  }

  updateSearchItems() {
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
