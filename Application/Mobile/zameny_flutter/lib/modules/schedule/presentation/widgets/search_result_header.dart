import 'package:flutter/material.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/shared/domain/models/models.dart';
import 'package:zameny_flutter/shared/domain/models/search_item_model.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/search_item_notification_button.dart';
import 'package:zameny_flutter/new/providers/export_schedule_provider.dart';
import 'package:zameny_flutter/new/providers/favorite_search_items_provider.dart';
import 'package:zameny_flutter/new/providers/search_item_provider.dart';
import 'package:zameny_flutter/widgets/blur_dialog.dart';


class SearchResultHeader extends ConsumerStatefulWidget {
  const SearchResultHeader({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchResultHeaderState();
}

class _SearchResultHeaderState extends ConsumerState<SearchResultHeader> {
  bool opened = false;

  @override
  Widget build(final BuildContext context) {
    final SearchItem? searchItem = ref.watch(searchItemProvider);
    final bool isSubscribed = ref.watch(favoriteSearchItemsProvider).items.contains(searchItem);
    final ThemeData theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Text(
              searchItem?.typeName ?? '',
              textAlign: TextAlign.center,
              style: context.styles.ubuntuInverseSurface18
            ),
            Text(
              searchItem?.name ?? '',
              textAlign: TextAlign.center,
              style: context.styles.ubuntuInverseSurfaceBold24
            )
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: BlurDialog(
            key: ValueKey(searchItem),
            popup: (final close) => Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6),
                ),
              ),
              child: AnimatedSize(
                duration: Delays.morphDuration,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Bounceable(
                      hitTestBehavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (isSubscribed) {
                          ref.read(favoriteSearchItemsProvider).remove(searchItem: searchItem!);
                        } else {
                          ref.read(favoriteSearchItemsProvider).add(searchItem: searchItem!);
                        }
                        setState(() {});
                      },
                      child: AnimatedSwitcher(
                        duration: Delays.morphDuration,
                        child: Row(
                          key: ValueKey(isSubscribed),
                          spacing: 8,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              isSubscribed ? Images.heart : Images.heartOutlined,
                              colorFilter: const ColorFilter.mode(Colors.redAccent, BlendMode.srcIn),
                              width: 24,
                            ),
                            Text(
                              isSubscribed ? 'Удалить из избранного' : 'Добавить в избранное',
                              style: context.styles.ubuntuInverseSurface14,
                            )
                          ],
                        ),
                      ),
                    ),
                    SearchItemNotificationButton(item: searchItem),
                    Bounceable(
                      hitTestBehavior: HitTestBehavior.translucent,
                      onTap: () {
                        close();
                        ref.read(scheduleExportProvider).exportSchedule(context: context);
                      },
                      child: Row(
                        spacing: 8,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            Images.export,
                            colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
                            width: 24,
                          ),
                          Text(
                            'Экспорт расписания',
                            style: context.styles.ubuntuInverseSurface14,
                          )
                        ],
                      ),
                    ),
                    if (searchItem is Teacher)
                      Bounceable(
                        hitTestBehavior: HitTestBehavior.translucent,
                        onTap: () {
                          close();
                          ref.read(scheduleExportProvider).exportTeacherStats(
                            teacher: searchItem,
                            context: context
                          );
                        },
                        child: Row(
                          spacing: 8,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Images.stats,
                              colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
                              width: 24,
                            ),
                            Text(
                              'Экспорт часов',
                              style: context.styles.ubuntuInverseSurface14,
                            )
                          ],
                        ),
                      )
                  ],
                ),
              )
            )
          )
        )
      ],
    );
  }
}
