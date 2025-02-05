import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';
import 'package:zameny_flutter/shared/providers/search_provider.dart';

class ScheduleTurboSearch extends ConsumerStatefulWidget {
  const ScheduleTurboSearch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleTurboSearchState();
}

class _ScheduleTurboSearchState extends ConsumerState<ScheduleTurboSearch> {
late final SearchController searchController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    searchController = SearchController();
  }

  void _onTextChanged(final String value) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      ref.read(filterSearchQueryProvider.notifier).state = value;
    });
  }

  @override
  Widget build(final BuildContext context) {
    final providerSchedule = ref.watch(scheduleProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoSearchTextField(
          onSubmitted: (final _) => FocusScope.of(context).unfocus(),
          style: context.styles.ubuntuInverseSurface,
          controller: searchController,
          onChanged: _onTextChanged,
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
            items: ref.watch(filteredSearchItemsProvider).valueOrNull ?? [],
            areItemsTheSame: (final a, final b) => a.s == b.s,
            insertDuration: const Duration(milliseconds: 300),
            removeDuration: const Duration(milliseconds: 300),
            itemBuilder: (final context, final animation, final item, final index) {
              return SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Material(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      key: UniqueKey(),
                      onTap: () {
                        ref.read(filterSearchQueryProvider.notifier).state = '';
                        
                        setState(() {
                          searchController.text = '';
                          FocusScope.of(context).unfocus();
                        });
                        providerSchedule.searchItemSelected(item, context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          item.getFiltername(),
                          style: context.styles.ubuntuInverseSurface18,
                        ),
                      ),
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
  int id;
  int typeId;
  int s = 0;

  SearchItem({
    required this.id,
    required this.typeId
  });
 
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

  String get typeName {
    if (this is Group) {
      return 'Группа';
    }
    if (this is Cabinet) {
      return 'Кабинет';
    }
    if (this is Teacher) {
      return 'Преподаватель';
    }
    return '';
  }
}
