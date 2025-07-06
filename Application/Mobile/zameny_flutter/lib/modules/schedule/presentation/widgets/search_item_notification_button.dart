import 'package:flutter/material.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/providers/notifications_provider.dart';

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

          String text = '';
          if (subscription.isLoading) {
            text = 'Загружаю...';
          } else if (subscription.value is SubscribtionSubscribed) {
            text = 'Отписаться от уведомлений';
          } else if (subscription.value is SubscribtionNonSubscribed) {
            text = 'Подписаться на уведомления';
          } else if (subscription.value is SubscribtionRestricted) {
            text = 'Разрешить уведомления';
          }

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
                  text,
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
