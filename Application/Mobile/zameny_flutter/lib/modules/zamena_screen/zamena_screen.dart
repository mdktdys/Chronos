import 'package:flutter/material.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/spacing.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/schedule_date_header.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_provider.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_header.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_practice_groups_block.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_view.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_view_chooser.dart';
import 'package:zameny_flutter/new/providers/main_provider.dart';
import 'package:zameny_flutter/widgets/month_cell_widget.dart';
import 'package:zameny_flutter/widgets/screen_appear_builder.dart.dart';


class ZamenaScreen extends ConsumerStatefulWidget {
  const ZamenaScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZamenaScreenState();
}

class _ZamenaScreenState extends ConsumerState<ZamenaScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final ScrollController controller;

  bool isDraggable = true;

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(_trackScroll);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_trackScroll);
    controller.dispose();
    super.dispose();
  }

  void _trackScroll() {
    ref.read(mainProvider).updateScrollDirection(controller.position.userScrollDirection);
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return ScreenAppearBuilder(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: ListView(
          padding: EdgeInsets.zero,
          controller: controller,
          physics: const BouncingScrollPhysics(),
          children: [
            const ZamenaScreenHeader(),
            const SizedBox(height: 8),
            const ZamenaPracticeGroupsBlock(),
            const SizedBox(height: 8),
            const ZamenaTeacherCabinetSwaps(),
            const SizedBox(height: 10),
            const ZamenaViewChooser(),
            const SizedBox(height: 8),
            const ZamenaView(),
            SizedBox(height: Constants.bottomSpacing),
          ],
        ),
      ),
    );
  }
}


class NavigationDatePanel extends ConsumerWidget {
  const NavigationDatePanel({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final bool isExpanded = ref.watch(panelExpandedProvider);
    final DateTimeRange visible = ref.watch(zamenaScreenProvider.select((final state) => state.visibleDateRange));
    final String title = '${visible.start.toMonth()} ${visible.start.year}';
    final bool isCurrentWeek = DateTime.now().sameDate(ref.watch(zamenaScreenProvider.select((final state) => state.currentDate)));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.listHorizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.styles.ubuntu14,
          ),
          Row(
            spacing: Spacing.list,
            children: [
              CurrentNavigationWeekBadge(
                title: 'Сегодня',
                isCurrentWeek: isCurrentWeek,
                onClicked: () {
                  ref.read(zamenaScreenProvider.notifier).setDate(DateTime.now());
                  ref.read(zamenaScreenProvider.notifier).setVisibleDateRange(DateTimeRange(
                    start: DateTime.now().toStartOfWeek(),
                    end: DateTime.now().toEndOfWeek(),
                  ));
                  final pageController = ref.read(zamenaScreenProvider.notifier).pageController;

                  if (true) {
                    pageController.animateToPage(1000, duration: Delays.fastMorphDuration, curve: Curves.easeInOut);
                  }

                  ref.read(zamenaScreenProvider.notifier).monthController.displayDate = DateTime.now();
                },
              ),
              GestureDetector(
                onTap: () {
                  ref.read(panelExpandedProvider.notifier).state = !isExpanded;
                },
                child: AnimatedRotation(
                  duration: Delays.fastMorphDuration,
                  turns: isExpanded
                    ? 0.5
                    : 0,
                  child: SvgPicture.asset(
                    Images.chevron,
                    colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.4), BlendMode.srcIn),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MonthNavigationPanel extends ConsumerStatefulWidget {
  final DateRangePickerController controller;

  const MonthNavigationPanel({
    required this.controller,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MonthState();
}

class _MonthState extends ConsumerState<MonthNavigationPanel> {

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      child: SfDateRangePicker(
        controller: widget.controller,
        headerHeight: 0,
        backgroundColor: Colors.transparent,
        initialDisplayDate: ref.watch(zamenaScreenProvider).currentDate,
        initialSelectedDate: ref.watch(zamenaScreenProvider).currentDate,
        selectionColor: Colors.transparent,
        monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
        onSelectionChanged: (final dateRangePickerSelectionChangedArgs) {
          final DateTime selected = dateRangePickerSelectionChangedArgs.value;

          if (selected.sameDate(ref.watch(zamenaScreenProvider).currentDate)) {
            return;
          }

          ref.read(zamenaScreenProvider.notifier).setDate(selected);
        },
        onViewChanged: _onViewChanged,
        cellBuilder: (final BuildContext context, final DateRangePickerCellDetails cellDetails) {
          return MonthCell(
            key: UniqueKey(),
            hasZamena: ref.watch(zamenaDataLoaderProvider).any((final link) => link.date.sameDate(cellDetails.date)),
            selectedDate: ref.watch(zamenaScreenProvider).currentDate,
            details: cellDetails,
          );
        },
      ),
    );
  }

  void _onViewChanged(final DateRangePickerViewChangedArgs dateRangePickerViewChangedArgs) {
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      final PickerDateRange visibleDateRange = dateRangePickerViewChangedArgs.visibleDateRange;

      if (
        visibleDateRange.endDate == null
        || visibleDateRange.startDate == null
      ) {
        return;
      }

      final DateTimeRange range = DateTimeRange(
        start: visibleDateRange.startDate!,
        end: visibleDateRange.endDate!,
      );

      ref.read(zamenaScreenProvider.notifier).setVisibleDateRange(range);
    });
  }
}

class WeekNavigationStrip extends ConsumerStatefulWidget {
  final PageController pageController;
  final DateTime initialDate;

  const WeekNavigationStrip({
    required this.pageController,
    required this.initialDate,
    super.key,
  });

  @override
  ConsumerState<WeekNavigationStrip> createState() => _WeekNavigationStripState();
}

class _WeekNavigationStripState extends ConsumerState<WeekNavigationStrip> {
  late DateTime _baseDate;
  static const int _initialPage = 1000;

  @override
  void initState() {
    super.initState();
    _baseDate = widget.initialDate;
  }

  // Получает начало недели для заданного сдвига от базовой даты
  DateTime _getStartOfWeek(final int weekOffset) {
    final current = _baseDate.add(Duration(days: weekOffset * 7));
    return current.subtract(Duration(days: current.weekday - 1)); // Monday
  }

  static const List<String> days = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ'];

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: 80,
      child: PageView.builder(
        controller: widget.pageController,
        onPageChanged: (final int value) {
          final DateTime newStartOfWeek = _getStartOfWeek(value - _initialPage);
          ref.read(zamenaScreenProvider.notifier).setVisibleDateRange(
            DateTimeRange(
              start: newStartOfWeek,
              end: newStartOfWeek.add(const Duration(days: 6)),
            ),
          );
        },
        itemBuilder: (final context, final index) {
          final int weekOffset = index - _initialPage;
          final DateTime startOfWeek = _getStartOfWeek(weekOffset);
          final List<DateTime> dates = List.generate(6, (final index) => startOfWeek.add(Duration(days: index)));

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dates.map((final DateTime day) {
              final bool current = day.sameDate(DateTime.now());
              final bool selected = day.sameDate(ref.watch(zamenaScreenProvider).currentDate);
              final bool hasZamena = ref.watch(zamenaDataLoaderProvider).any((final link) => link.date.sameDate(day));

              Color? borderColor;
              if (current) {
                borderColor = Theme.of(context).colorScheme.primary;
              } else if (hasZamena) {
                borderColor = Colors.green.withValues(alpha: 0.6);
              }

              return Bounceable(
                onTap: () {
                  ref.read(zamenaScreenProvider.notifier).setDate(day);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 6,
                  children: [
                    Text(
                      days[day.weekday - 1],
                      style: context.styles.ubuntu14,
                    ),
                    AnimatedContainer(
                      duration: Delays.morphDuration,
                      decoration: BoxDecoration(
                        border: borderColor != null
                          ? Border.all(color: borderColor)
                          : null,
                        color: selected
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                          : null,
                        shape: BoxShape.circle
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        day.day.toString(),
                        style: context.styles.ubuntu14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
