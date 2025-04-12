import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/new/providers/search_provider.dart';
import 'package:zameny_flutter/shared/providers/navigation/navigation_provider.dart';
import 'package:zameny_flutter/widgets/favorite_stripe_widget.dart';
import 'package:zameny_flutter/widgets/search_item_chip.dart';

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
    bool shouldShow = isFocused || searchController.text.isNotEmpty;

    final providers = [
      ref.watch(groupsProvider),
      ref.watch(teachersProvider),
      ref.watch(cabinetsProvider),
    ];

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
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            alignment: Alignment.topCenter,
            child: shouldShow
              ? const FavoriteStripeWidget()
              : const SizedBox(),
          ),
        Builder(
          builder: (final BuildContext context) {
            final List<SearchItem> items = ref.watch(filteredSearchItemsProvider).valueOrNull ?? [];
            return AnimatedSize(
              duration: const Duration(milliseconds: 300),
              alignment: Alignment.topCenter,
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: (shouldShow && items.isNotEmpty) ? 8 : 0)),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Wrap(
                      key: Key(items.length.toString()),
                      spacing: 8,
                      runSpacing: 8,
                      children: items.map((final SearchItem searchItem) {
                        return SearchItemChip(
                          searchItem: searchItem,
                          onTap: () {
                            ref.read(searchItemProvider.notifier).setState(searchItem);
                            ref.read(filterSearchQueryProvider.notifier).state = '';
                            ref.read(navigationProvider.notifier).setParams({
                              'type': searchItem.typeId,
                              'id': searchItem.id,
                            });

                            searchController.clear();
                          }
                        );
                      }).toList()
                    ),
                  ),
                ],
              ),
            );
          }
        ),
        if (providers.any((final provider) => provider.isLoading))
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: const Text(
              'Загружаю...',
              textAlign: TextAlign.center,
            ).animate(
              autoPlay: true,
              onComplete: (final controller) {
                controller.loop(reverse: true);
              },
              effects: [
                const FadeEffect(
                  begin: 0.3,
                  end: 0.6,
                  duration: Duration(seconds: 1)
                )
              ]
            ),
          )
      ],
    );
  }
}
