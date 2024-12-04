import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zameny_flutter/presentation/Screens/app/providers/main_provider.dart';

class BottomNavigationItem extends ConsumerWidget {
  final int index;
  final Function onTap;
  final String icon;
  final String text;
  final bool enabled;
  final String activeicon;

  const BottomNavigationItem({
    required this.index,
    required this.onTap,
    required this.icon,
    required this.text,
    required this.activeicon, 
    required this.enabled, 
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(mainProvider);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        radius: 20,
        enableFeedback: false,
        borderRadius: BorderRadius.circular(20),
        highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        onTap: () {
          if (enabled) {
            onTap.call(index);
          }
        },
        child: SizedBox(
          height: double.infinity,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: SvgPicture.asset(
              key: UniqueKey(),
              provider.currentPage == index
               ? activeicon : icon,
              width: 28,
              height: 28,
              color: enabled
                  ? provider.currentPage == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.inverseSurface.withOpacity(0.4)
                  : Theme.of(context).colorScheme.primary.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
