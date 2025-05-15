import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/new/providers/export_schedule_provider.dart';
import 'package:zameny_flutter/new/providers/favorite_search_items_provider.dart';
import 'package:zameny_flutter/new/providers/notifications_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/widgets/barrier_widget.dart';

class SearchItemNotificationButton extends ConsumerWidget {
  final SearchItem? item;

  const SearchItemNotificationButton({
    required this.item,
    super.key
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);

    if (item == null) {
      return const SizedBox.shrink();
    }

    final AsyncValue<SubscribtionState> subscription = ref.watch(subsribtionProvider(item!));
    final provider = ref.read(subsribtionProvider(item!).notifier);

    return Bounceable(
      hitTestBehavior: HitTestBehavior.translucent,
      onTap: () async {
        if (subscription.isLoading) {
          return;
        }

        if (subscription.value is SubscribtionSubscribed) {
          await provider.onsubscribe();
        } else {
          await provider.subscribe();
        }
      },
      child: Builder(
        builder: (final context) {
          final bool isNotificationSubscribed = subscription.value is SubscribtionSubscribed;

          return AnimatedSwitcher(
            duration: Delays.morphDuration,
            child: Row(
              key: ValueKey(subscription.value),
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (subscription.isLoading)
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RefreshProgressIndicator(
                      ),
                    ),
                  ),
                if (subscription.hasValue)
                  SvgPicture.asset(
                    isNotificationSubscribed ? Images.notificationBold : Images.notification,
                    colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
                    width: 24,
                  ),
                Text(
                  subscription.isLoading ? 'Загружаю...' :
                  (isNotificationSubscribed ? 'Отписаться от уведомлений' : 'Подписаться на уведомления'),
                  textAlign: TextAlign.left,
                  style: context.styles.ubuntuInverseSurface14,
                )
              ],
            ),
          );
        }
      ),
    );
  }
}


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
                            'Экспорт расписание',
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

class BlurDialog extends StatefulWidget {
  final Widget Function(Function) popup;

  const BlurDialog({
    required this.popup,
    super.key
  });

  @override
  State<BlurDialog> createState() => _BlurDialogState();
}

class _BlurDialogState extends State<BlurDialog> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  bool opened = false;

  @override
  void initState() {
    controller = AnimationController(vsync: this, value: 0, duration: Delays.morphDuration);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _onClose() async {
    setState(() => opened = false);
    controller.reverse();
    opened = false;
  }

  @override
  Widget build(final BuildContext context) {
    return Barrier(
      onClose: _onClose,
      visible: opened,
      child: PortalTarget(
        visible: opened,
        closeDuration: const Duration(seconds: 1),
        anchor: const Aligned(
          follower: Alignment.topRight,
          target: Alignment.bottomLeft,
        ),
        portalFollower: Animate(
          controller: controller,
          value: 0.05,
          effects: const [
            FadeEffect(
              duration: Duration(milliseconds: 250)
            ),
            ScaleEffect(
              duration: Duration(milliseconds: 250),
              alignment: Alignment.topRight,
              curve: Curves.fastLinearToSlowEaseIn,
            ),
          ],
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: widget.popup(_onClose)
          ),
        ),
        child: IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
          onPressed: () {
            controller.forward().orCancel;
            setState(() => opened = true);
          },
        ),
      ),
    );
  }
}
