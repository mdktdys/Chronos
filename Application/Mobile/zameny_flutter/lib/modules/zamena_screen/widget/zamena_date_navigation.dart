import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_provider.dart';
import 'package:zameny_flutter/widgets/toggle_week_button.dart';


class ZamenaDateNavigation extends ConsumerStatefulWidget {
  const ZamenaDateNavigation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ZamenaDateNavigationState();
}

class _ZamenaDateNavigationState extends ConsumerState<ZamenaDateNavigation> {
  @override
  Widget build(final BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ToggleWeekButton(
              next: false,
              onTap: () {
                ref.read(zamenaScreenProvider.notifier).toggleWeek(-1);
              },
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ref.watch(zamenaScreenProvider).currentDate.weekdayName(),
                        style: context.styles.ubuntuInverseSurfaceBold16,
                      ),
                      Text(
                        ref.watch(zamenaScreenProvider).currentDate.formatyyyymmdd(),
                        style: context.styles.ubuntu40012.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.5))
                      ),
                    ],
                  ),
                  AnimatedSize(
                    curve: Curves.easeOutCubic,
                    duration: Delays.fastMorphDuration,
                    child: ref.watch(zamenaScreenProvider).currentDate.formatyyyymmdd() == DateTime.now().formatyyyymmdd()
                      ? Container(
                          margin: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              'Сегодня',
                              style: context.styles.ubuntuCanvasColorBold14,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            ToggleWeekButton(
              next: true,
              onTap: () {
                ref.read(zamenaScreenProvider.notifier).toggleWeek(1);
              },
            ),
          ],
        ),
      );
  }
}
