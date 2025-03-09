import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';
import 'package:zameny_flutter/new/providers/favorite_search_items_provider.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';
import 'package:zameny_flutter/shared/providers/search_provider.dart';

class FavoriteStripeWidget extends ConsumerWidget {
  const FavoriteStripeWidget({
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Builder(builder: (final BuildContext context) {
        final provider = ref.watch(favoriteSearchItemsProvider);
      
        if (provider.items.isEmpty) {
          return const SizedBox.shrink();
        }
      
        return SizedBox(
          height: 34,
          child: Builder(
            builder: (final BuildContext context) {
              final List<SearchItem> items = ref.watch(favoriteSearchItemsProvider).items;

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items.map((final SearchItem item) {
                  return Material(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () {
                        ref.read(searchItemProvider.notifier).setState(item);
                        ref.read(filterSearchQueryProvider.notifier).state = '';
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)
                          )
                        ),
                        child: Text(
                          item.name,
                          style: context.styles.ubuntuInverseSurface40014,
                        )
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          ),
        );
      }),
    );
  }
}
