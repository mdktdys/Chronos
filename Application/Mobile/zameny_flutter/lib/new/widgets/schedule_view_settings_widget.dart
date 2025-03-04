
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/new/enums/schedule_view_modes.dart';
import 'package:zameny_flutter/new/typedefs/on_clicked_typedef.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';
import 'package:zameny_flutter/shared/widgets/bottom_sheets/notifications_bottom_sheet.dart';


class FrameLessButton extends StatelessWidget {
  final OnClicked onClicked;
  final bool isActive;
  final Widget child;

  const FrameLessButton({
    required this.onClicked,
    required this.child,
    this.isActive = false,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    final Color color = Theme.of(context).colorScheme.onSurface.withValues(alpha: 
      isActive
        ? 0.10
        : 0.01);

    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: color,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          onTap: onClicked,
          child: child,
        ),
      ),
    );
  }
}


class ScheduleViewSettingsWidget extends ConsumerWidget {
  const ScheduleViewSettingsWidget({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(scheduleSettingsProvider);
    final notifier = ref.watch(scheduleSettingsProvider.notifier);

    return Row(
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
    );
  }
}
