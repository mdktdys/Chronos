import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/features/schedule/presentation/views/schedule_screen.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/new/widgets/favorite_stripe_widget.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';
import 'package:zameny_flutter/shared/providers/search_provider.dart';

class ScheduleTurboSearch extends ConsumerStatefulWidget {
  final bool withFavorite;

  const ScheduleTurboSearch({
    this.withFavorite = true,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleTurboSearchState();
}

class _ScheduleTurboSearchState extends ConsumerState<ScheduleTurboSearch> {
  late final SearchController searchController;
  late final FocusNode focusNode;
  bool isFocused = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    searchController = SearchController();
    focusNode = FocusNode()..addListener(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      isFocused = focusNode.hasFocus;

      if (context.mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CupertinoSearchTextField(
          focusNode: focusNode,
          onSubmitted: (final _) => FocusScope.of(context).unfocus(),
          style: context.styles.ubuntuInverseSurface,
          controller: searchController,
          onChanged: _onTextChanged,
          placeholder: 'Я ищу...',
        ),
        if (widget.withFavorite)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: isFocused || searchController.text.isNotEmpty
              ? const Padding(
                padding: EdgeInsets.only(top: 8),
                child: FavoriteStripeWidget()
              )
              : const SizedBox(),
          ),
        Builder(
          builder: (final BuildContext context) {
            final List<SearchItem> items = ref.watch(filteredSearchItemsProvider).valueOrNull ?? [];
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Padding(
                key: UniqueKey(),
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items.map((final SearchItem element) {
                    return Material(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: () {
                          // context.go('/schedule?type=${element.typeId}&id=${element.id}');
                          ref.read(searchItemProvider.notifier).state = element;
                          ref.read(filterSearchQueryProvider.notifier).state = '';
                          ref.read(scheduleProvider).searchItemSelected(element);
                          searchController.clear();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8
                          ),
                          child: Text(
                            element.getFiltername(),
                            style: context.styles.ubuntuInverseSurface40014,
                          )
                        ),
                      ),
                    );
                  }).toList()
                ),
              ),
            );
          }
        )
        // AnimatedSize(
        //   duration: const Duration(milliseconds: 300),
        //   alignment: Alignment.topCenter,
        //   curve: Easing.legacy,
        //   child: ImplicitlyAnimatedList<SearchItem>(
        //     spawnIsolate: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     shrinkWrap: true,
        //     items: ref.watch(filteredSearchItemsProvider).valueOrNull ?? [],
        //     areItemsTheSame: (final a, final b) => a.s == b.s,
        //     insertDuration: const Duration(milliseconds: 300),
        //     removeDuration: const Duration(milliseconds: 300),
        //     itemBuilder: (final context, final animation, final item, final index) {
        //       return SizeTransition(
        //         sizeFactor: animation,
        //         axisAlignment: -1,
        //         child: Padding(
        //           padding: const EdgeInsets.symmetric(vertical: 2.0),
        //           child: Material(
        //             clipBehavior: Clip.hardEdge,
        //             borderRadius: BorderRadius.circular(16),
        //             child: InkWell(
        //               key: UniqueKey(),
        //               onTap: () {
        //                 ref.read(filterSearchQueryProvider.notifier).state = '';
                        
        //                 setState(() {
        //                   searchController.text = '';
        //                   FocusScope.of(context).unfocus();
        //                 });
        //                 
        //               },
        //               child: Container(
        //                 width: double.infinity,
        //                 padding: const EdgeInsets.all(12),
        //                 child: Text(
        //                   item.getFiltername(),
        //                   style: context.styles.ubuntuInverseSurface18,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
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
