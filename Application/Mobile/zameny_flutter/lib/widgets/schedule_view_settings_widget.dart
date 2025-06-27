import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/enums/schedule_view_mode_enum.dart';
import 'package:zameny_flutter/config/enums/schedule_view_modes_enum.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/widgets/adaptive_layout.dart';
import 'package:zameny_flutter/widgets/frame_less_button.dart';

class CustomSwitch<T> extends StatefulWidget {
  final double width;
  final List<T> values;
  final T initial;
  final void Function(T) onChanged;

  const CustomSwitch({
    required this.width,
    required this.values,
    required this.onChanged,
    required this.initial,
    super.key
  });
    

  @override
  State<CustomSwitch> createState() => _CustomSwitchState<T>();
}

class _CustomSwitchState<T> extends State<CustomSwitch<T>> {
  int index = 0;
  bool hovered = false;
  double get segmentWidth => widget.width / widget.values.length;

  @override
  void initState() {
    index = widget.values.indexOf(widget.initial);
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      onTap: () {
        setState(() {
          index = (index + 1) % widget.values.length;
        });
        widget.onChanged.call((widget.values[index]));
      },
      onHover: (final value) {
        hovered = value;
        setState(() {
          
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 30,
          width: widget.width,
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline, width: 2)  ,
            borderRadius: BorderRadius.circular(999)
          ),
          padding: const EdgeInsets.all(2),
          child: AnimatedAlign(
              alignment: Alignment(
                -1.0 + (2.0 * index) / (widget.values.length - 1),
                0,
              ),
            duration: Delays.fastMorphDuration,
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: Delays.morphDuration,
              width: segmentWidth,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: hovered ? theme.colorScheme.inverseSurface : theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
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

    return AdaptiveLayout(
      mobile: () {
        return Row(
          key: const ValueKey<String>('mobile'),
          spacing: 8,
          children: [
            CustomSwitch<ScheduleViewMode>(
              initial: provider.sheduleViewMode,
              onChanged: (final ScheduleViewMode mode) {
                provider.sheduleViewMode = mode;
                notifier.notify();
              },
              width: 70,
              values: ScheduleViewMode.values
            ),
            Text(
              key: ValueKey(provider.sheduleViewMode),
              provider.sheduleViewMode.name,
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
              CustomSwitch<ScheduleViewMode>(
                initial: provider.sheduleViewMode,
                onChanged: (final ScheduleViewMode mode) {
                  provider.sheduleViewMode = mode;
                  notifier.notify();
                },
                width: 70,
                values: ScheduleViewMode.values
              ),
              AnimatedSize(
                duration: Delays.morphDuration,
                alignment: Alignment.centerLeft,
                curve: Curves.easeInOut,
                child: Text(
                  key: ValueKey(provider.sheduleViewMode),
                  provider.sheduleViewMode.name,
                  style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6)),
                ),
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
