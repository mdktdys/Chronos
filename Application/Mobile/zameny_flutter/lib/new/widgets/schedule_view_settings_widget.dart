
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/new/enums/schedule_view_modes.dart';
import 'package:zameny_flutter/new/widgets/frame_less_button.dart';
import 'package:zameny_flutter/shared/layouts/adaptive_layout.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';

class ScheduleViewSettingsWidget extends ConsumerWidget {
  const ScheduleViewSettingsWidget({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(scheduleSettingsProvider);
    final notifier = ref.watch(scheduleSettingsProvider.notifier);

    return AdaptiveLayout(
      mobile: () {
        return Row(
          key: const ValueKey<String>('mobile'),
          spacing: 8,
          children: [
            SizedBox(
              height: 38,
              child: FittedBox(
                child: Switch(
                  value: provider.isShowZamena,
                  onChanged: (final value) {
                    provider.isShowZamena = !provider.isShowZamena;
                    notifier.notify();
                  },
              ),
            )),
            Text(
              'С заменами',
              style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6)),
            ),
          ],
        );
      },
      desktop: () {
        return Row(
          key: const ValueKey<String>('desktop'),
          spacing: 8,
            children: [
              FrameLessButton(
                isActive: (provider.viewmode == ScheduleViewModes.auto),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    Images.viewModeAuto,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6),
                      BlendMode.srcIn
                    ),
                  ),
                ),
                onClicked: () async {
                  provider.viewmode = ScheduleViewModes.auto;
                  notifier.notify();
                },
              ),
              FrameLessButton(
                isActive: (provider.viewmode == ScheduleViewModes.grid),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    Images.viewModeGrid,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6),
                      BlendMode.srcIn
                    ),
                  ),
                ),
                onClicked: () async {
                  provider.viewmode = ScheduleViewModes.grid;
                  notifier.notify();
                },
              ),
              FrameLessButton(
                isActive: (provider.viewmode == ScheduleViewModes.list),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    Images.viewModeList,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6),
                      BlendMode.srcIn
                    ),
                  ),
                ),
                onClicked: () async {
                  provider.viewmode = ScheduleViewModes.list;
                  notifier.notify();
                },
              ),
              SizedBox(
                height: 38,
                child: FittedBox(
                  child: Switch(
                    value: provider.isShowZamena,
                    onChanged: (final value) {
                      provider.isShowZamena = !provider.isShowZamena;
                      notifier.notify();
                    },
                ),
              )),
              Text(
                'С заменами',
                style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6)),
              ),
              if (notifier.viewmode != ScheduleViewModes.list)
                Row(
                  children: [
                    SizedBox(
                      height: 38,
                      child: FittedBox(
                        child: Switch(
                          value: provider.obed,
                          onChanged: (final value) {
                            provider.obed = !provider.obed;
                            notifier.notify();
                          },
                      ),
                    )),
                    Text(
                      'С обедом',
                      style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6)),
                    ),
                  ],
                )
            ],
          );
        },
      );
  }
}
