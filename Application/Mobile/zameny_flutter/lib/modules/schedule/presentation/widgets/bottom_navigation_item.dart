import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/providers/main_provider.dart';

class BottomNavigationItem extends ConsumerWidget {
  final int index;
  final Function onTap;
  final String icon;
  final String text;
  final bool enabled;
  final String activeicon;

  const BottomNavigationItem({
    required this.activeicon,
    required this.index,
    required this.onTap,
    required this.icon,
    required this.text,
    required this.enabled, 
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final RiverPodMainProvider provider = ref.watch(mainProvider);
    final ThemeData theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        radius: 20,
        enableFeedback: false,
        borderRadius: BorderRadius.circular(20),
        highlightColor: theme.colorScheme.primary.withValues(alpha: 0.2),
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.3),
        onTap: () {
          if (enabled) {
            onTap.call(index);
          }
        },
        child: SizedBox(
          height: double.infinity,
          child: AnimatedSwitcher(
            duration: Delays.fastMorphDuration,
            child: SvgPicture.asset(
              key: UniqueKey(),
              provider.currentPage == index
               ? activeicon : icon,
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                enabled
                  ? provider.currentPage == index
                      ? theme.colorScheme.primary
                      : theme.colorScheme.inverseSurface.withValues(alpha: 0.4)
                  : theme.colorScheme.primary.withValues(alpha: 0.6),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
