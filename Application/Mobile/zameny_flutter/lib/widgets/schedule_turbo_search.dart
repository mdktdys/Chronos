import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';
import 'package:zameny_flutter/new/providers/search_item_provider.dart';
import 'package:zameny_flutter/new/providers/search_provider.dart';
import 'package:zameny_flutter/shared/domain/models/search_item_model.dart';
import 'package:zameny_flutter/shared/providers/navigation/navigation_provider.dart';
import 'package:zameny_flutter/widgets/favorite_stripe_widget.dart';
import 'package:zameny_flutter/widgets/search_item_chip.dart';

class ScheduleTurboSearch extends ConsumerStatefulWidget {
  final SearchController searchController;
  final FocusNode focusNode;
  final bool withFavorite;

  const ScheduleTurboSearch({
    required this.searchController,
    required this.focusNode,
    this.withFavorite = true,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleTurboSearchState();
}

class _ScheduleTurboSearchState extends ConsumerState<ScheduleTurboSearch> {
  late final SearchController searchController;

  bool isFocused = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    searchController = widget.searchController;
    widget.focusNode.addListener(_trackFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_trackFocus);
    super.dispose();
  }

  Future<void> _trackFocus() async {
    await Future.delayed(const Duration(milliseconds: 100));
    isFocused = widget.focusNode.hasFocus;

    if (context.mounted) {
      setState(() {});
    }
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
          focusNode: widget.focusNode,
          onSubmitted: (final _) => FocusScope.of(context).unfocus(),
          style: context.styles.ubuntuInverseSurface,
          controller: searchController,
          onChanged: _onTextChanged,
          placeholder: 'Я ищу...',
        ),
        if (widget.withFavorite)
          AnimatedSize(
            curve: Curves.easeInOut,
            duration: Delays.morphDuration,
            alignment: Alignment.topCenter,
            child: shouldShow
              ? FavoriteStripeWidget(
                  searchController: searchController,
                  focusNode: widget.focusNode,
                )
              : const SizedBox(),
          ),
        Builder(
          builder: (final BuildContext context) {
            final List<SearchItem> items = ref.watch(filteredSearchItemsProvider).valueOrNull ?? [];
            return AnimatedSize(
              duration: Delays.morphDuration,
              alignment: Alignment.topCenter,
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: (shouldShow && items.isNotEmpty) ? 8 : 0)),
                  AnimatedSwitcher(
                    duration: Delays.morphDuration,
                    child: Wrap(
                      key: Key(items.length.toString()),
                      spacing: 8,
                      runSpacing: 8,
                      children: items.map((final SearchItem searchItem) {
                        return SearchItemChip(
                          title: searchItem.name,
                          onTap: () {
                            widget.focusNode.unfocus();
                            searchController.clear();
                            ref.read(filterSearchQueryProvider.notifier).state = '';
                            ref.read(searchItemProvider.notifier).setState(searchItem);
                            ref.read(navigationProvider.notifier).setParams({
                              'type': searchItem.typeId,
                              'id': searchItem.id,
                            });

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
            child: Text(
              'Загружаю...',
              textAlign: TextAlign.center,
              style: context.styles.ubuntu14,
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
