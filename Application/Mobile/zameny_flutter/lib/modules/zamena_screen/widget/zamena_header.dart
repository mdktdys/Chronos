
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_provider.dart';
import 'package:zameny_flutter/modules/zamena_screen/zamena_screen.dart';

class ZamenaScreenHeader extends ConsumerStatefulWidget {
  const ZamenaScreenHeader({super.key});

  @override
  ConsumerState<ZamenaScreenHeader> createState() => _ZamenaScreenHeaderState();
}

class _ZamenaScreenHeaderState extends ConsumerState<ZamenaScreenHeader> {
  late final MonthNavigationPanel _monthPanel;
  late final WeekNavigationStrip _weekStrip;

  @override
  void initState() {
    final notifier = ref.read(zamenaScreenProvider.notifier);

    _monthPanel = MonthNavigationPanel(controller: notifier.monthController);
    _weekStrip = WeekNavigationStrip(
      pageController: notifier.pageController,
      initialDate: ref.read(zamenaScreenProvider.select((final state) => state.currentDate)),
    );
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    // final DateTime date = ref.watch(zamenaScreenProvider.select((final state) => state.currentDate));
    // final notifier = ref.watch(zamenaScreenProvider.notifier);

    return AnimatedSize(
      duration: Delays.morphDuration,
      alignment: Alignment.topCenter,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: Delays.morphDuration,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Замены',
                style: context.styles.ubuntuPrimaryBold24,
              ),
              const NavigationDatePanel(),
              AnimatedSize(
                alignment: Alignment.topCenter,
                duration: Delays.morphDuration,
                curve: Curves.easeOut,
                child: AnimatedSwitcher(
                  duration: Delays.morphDuration,
                  child: ref.watch(panelExpandedProvider)
                    ? _monthPanel
                    : _weekStrip
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
