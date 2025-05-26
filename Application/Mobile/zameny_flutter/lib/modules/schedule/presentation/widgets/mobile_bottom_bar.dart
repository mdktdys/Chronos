
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/bottom_bar_items.dart';
import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/bottom_navigation_item.dart';
import 'package:zameny_flutter/new/providers/main_provider.dart';

class AnimatedBottomBar extends ConsumerWidget {
  const AnimatedBottomBar({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final bool shouldShow = ref.watch(mainProvider).bottomBarShow;
    return Align(
      alignment: Alignment.bottomCenter,
      child: IgnorePointer(
        ignoring: !shouldShow,
        child: AnimatedOpacity(
          duration: Delays.morphDuration,
          opacity: shouldShow
            ? 1
            : 0,
          child: const BottomBar(),
        ),
      ),
    );
  }
}

class BottomBar extends ConsumerWidget {
  const BottomBar({
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(mainProvider);
    return ClipRect(
      child: SizedBox(
        height: 90,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border(
                    bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
                    top: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(model.length, (final index) {
                      return Expanded(
                        child: BottomNavigationItem(
                          activeicon: model[index].activeicon,
                          enabled: model[index].enabled,
                          index: index,
                          onTap: (final int index) {
                            provider.setPage(index);
                          },
                          icon: model[index].icon,
                          text: model[index].title,
                        ),
                      );
                    }
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
