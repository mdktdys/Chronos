import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/domain/Providers/search_provider.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/theme/flex_color_scheme.dart';

List<SearchItem> filterItems(final List<dynamic> data) {
  final items = data[0] as List<SearchItem>;
  final query = data[1] as String;

  return items.where((final element) => element.getFiltername().toLowerCase().contains(query.toLowerCase())).toList();
}

class ScheduleTurboSearch extends ConsumerStatefulWidget {
  const ScheduleTurboSearch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleTurboSearchState();
}

class _ScheduleTurboSearchState extends ConsumerState<ScheduleTurboSearch> {
late final SearchController searchController;
  List<SearchItem> filteredItems = [];
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    searchController = SearchController();
  }

  void _onTextChanged(final String value) {
    final providerSearch = ref.read(searchProvider);
    if (value.isEmpty) {
      setState(() {
        filteredItems.clear();
      });
    } else {
      if (_debounceTimer?.isActive ?? false) {
        _debounceTimer!.cancel();
      }

      _debounceTimer = Timer(const Duration(milliseconds: 150), () async {
        final searchItems = providerSearch.searchItems;
        final query = value.trim();

        // Выполняем фильтрацию в изоляте
        final filtered = await compute(filterItems, [searchItems, query]);

        setState(() {
          filteredItems = filtered;
        });
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    final providerSchedule = ref.watch(scheduleProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoSearchTextField(
          controller: searchController,
          onSubmitted: (final _) => FocusScope.of(context).unfocus(),
          onChanged: (final value) => _onTextChanged(value),
          style: context.styles.ubuntuInverseSurface,
          placeholder: 'Я ищу...',
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.topCenter,
          curve: Easing.legacy,
          child: ImplicitlyAnimatedList<SearchItem>(
            spawnIsolate: true,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            items: filteredItems,
            areItemsTheSame: (final a, final b) => a.s == b.s,
            insertDuration: const Duration(milliseconds: 300),
            removeDuration: const Duration(milliseconds: 300),
            // removeItemBuilder: (context, animation, oldItem) {
            //   return FadeTransition(
            //       opacity: animation,
            //       child: ListTile(
            //         key: UniqueKey(),
            //         title: Text(
            //           oldItem.getFiltername(),
            //           style: TextStyle(
            //               fontFamily: 'Ubuntu',
            //               color: Theme.of(context).colorScheme.onSurface),
            //         ),
            //       ));
            // },
            itemBuilder: (final context, final animation, final item, final index) {
              return SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: SizedBox(
                  height: 50,
                  child: ListTile(
                    key: UniqueKey(),
                    onTap: () {
                      setState(() {
                        searchController.text = '';
                        FocusScope.of(context).unfocus();
                        filteredItems.clear();
                      });
                      if (item is Group) {
                        providerSchedule.groupSelected(item.id, context);
                      } 
                      if (item is Cabinet) {
                        providerSchedule.cabinetSelected(item.id, context);
                      }
                      if (item is Teacher) {
                        providerSchedule.teacherSelected(item.id, context);
                      }
                    },
                    title: Text(
                      item.getFiltername(),
                      style: context.styles.ubuntuOnSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
abstract class SearchItem {
  int s = 0;
  String getFiltername() {
    if (this is Group) {
      return (this as Group).name;
    }
    if (this is Cabinet) {
      return (this as Cabinet).name;
    }
    if (this is Teacher) {
      return (this as Teacher).name;
    }
    return '';
  }
}
