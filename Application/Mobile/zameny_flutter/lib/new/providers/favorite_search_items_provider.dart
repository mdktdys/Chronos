import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';
import 'package:zameny_flutter/shared/providers/search_provider.dart';

final favoriteSearchItemsProvider = ChangeNotifierProvider<FavoriteSearchItemsNotifier>((final ref) {
  return FavoriteSearchItemsNotifier(ref: ref);
});

class FavoriteSearchItemsNotifier extends ChangeNotifier {
    List<SearchItem> items = [];
    Ref ref;

    FavoriteSearchItemsNotifier({
      required this.ref
    }) {
      final String? json = GetIt.I.get<SharedPreferences>().getString('favorite');

      if (json != null) {
      final List<dynamic> raw = jsonDecode(json);
      final provider = ref.read(searchItemsProvider).value;

      if (provider != null) {
        items = raw.map((final item) {
          return provider.firstWhere(
            (final searchItem) => searchItem.id == item['id'],


            // teacher
            if (item['type'] == 1) {
              return 
            }

            orElse: () => SearchItem(id: item['id'], typeId: item['type']), // Создание объекта, если не найден
          );
        }).toList();
      }
    }
    }

    Future<void> add({
      required final SearchItem searchItem,
    }) async {
      items.add(searchItem);
      final List<Map<String, dynamic>> json = items.map((final SearchItem item) {
        return {
          'id': item.id,
          'type': item.typeId,
        };
      }).toList();

      await GetIt.I.get<SharedPreferences>().setString('favorite', jsonEncode(json));
    }

    void remove({
      required final SearchItem searchItem,
    }) {

    }
}
