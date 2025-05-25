import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/spacing.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/schedule_date_header.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_provider.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_practice_groups_block.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_view.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_view_chooser.dart';
import 'package:zameny_flutter/new/providers/main_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
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
        // body: SlidingUpPanel(
        //   scrollController: ScrollController(),
        //   maxHeight: MediaQuery.sizeOf(context).height * 1,
        //   minHeight: MediaQuery.sizeOf(context).height * 0.6,
        //   body: Column(
        //     children: [
        //       SizedBox(
        //         height: MediaQuery.sizeOf(context).height * 0.35,
        //         width: MediaQuery.sizeOf(context).height * 0.35,
        //         child: sf.SfDateRangePicker(
        //           selectionColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
        //           backgroundColor: Colors.transparent,
        //           selectionRadius: 10,
        //           initialDisplayDate: DateTime.now(),
        //           showActionButtons: true,
        //           allowViewNavigation: false,
        //           onCancel: () => Navigator.of(context).pop(),
        //           onSubmit: (final p0) {
        //             // if (p0 == null) {
        //             //   Navigator.of(context).pop();
        //             //   return;
        //             // }
        //             // final DateTime time = (p0 as DateTime);
        //             // provider.navigationDate = time;
        //             // provider.currentWeek = provider.getWeekNumber(time);
        //             // provider.dateSwitched(ctx);
        //             // Navigator.of(context).pop();
        //           },
        //           // monthViewSettings:
        //           //     sf.DateRangePickerMonthViewSettings(
        //           //         firstDayOfWeek: DateTime.monday,
        //           //         blackoutDates: GetIt.I
        //           //             .get<Data>()
        //           //             .holidays
        //           //             .map((final e) => e.date)
        //           //             .toList(),
        //           //           ),
        //           showTodayButton: true,
        //           showNavigationArrow: true,
        //           headerStyle: const sf.DateRangePickerHeaderStyle(backgroundColor: Colors.transparent),
        //           cellBuilder: (final context, final cellDetails) {
        //             return MonthCell(details: cellDetails);
        //           },
        //         ),
        //       ),
        //     ],
        //   ),
        //   parallaxEnabled: true,
        //   isDraggable: isDraggable,
          
          
        //   panelBuilder: () {
        //     return Scaffold(
        //       body: Container(
        //         decoration: BoxDecoration(
        //           border: Border(top: BorderSide(color: Theme.of(context).colorScheme.primary)),
        //           borderRadius: const BorderRadius.only(
        //             topLeft: Radius.circular(24.0),
        //             topRight: Radius.circular(24.0),
        //           ),
        //         ),
        //         child: SingleChildScrollView(
        //           controller: controller,
        //           child: Column(
        //             // controller: controller,
        //             // mainAxisSize: MainAxisSize.min,
        //             children: [
        //               const SizedBox(height: 10),
        //               const ZamenaScreenHeader(),
        //               // const DateHeader(),
        //               const SizedBox(height: 10),
        //               const ZamenaDateNavigation(),
        //               const SizedBox(height: 8),
        //               const ZamenaViewChooser(),
        //               const SizedBox(height: 8),
        //               // const WarningDevBlank(),
        //               // const SizedBox(height: 10),
        //               const ZamenaFileBlock(),
        //               const SizedBox(height: 10),
        //               const ZamenaView(),
        //               SizedBox(height: Constants.bottomSpacing),
        //             ],
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // ),
        body: SingleChildScrollView(
          // padding: EdgeInsets.symmetric(horizontal: Spacing.listHorizontalPadding),
          controller: controller,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ZamenaScreenHeader(),
              // const SizedBox(height: 10),
              // const ZamenaScreenHeader(),
              // const DateHeader(),
              // const SizedBox(height: 10),
              // const ZamenaDateNavigation(),
              // const SizedBox(height: 8),
              // const WarningDevBlank(),
              // const SizedBox(height: 10),
              // const ZamenaFileBlock(),
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: Spacing.listHorizontalPadding),
                children: const [
                  SizedBox(height: 8),
                  ZamenaPracticeGroupsBlock(),
                  SizedBox(height: 10),
                  ZamenaViewChooser(),
                  SizedBox(height: 8),
                  ZamenaView(),
                ],
              ),
              SizedBox(height: Constants.bottomSpacing),
            ],
          ),
        ),
      ),
    );
  }
}

class ZamenaScreenHeader extends ConsumerStatefulWidget {
  const ZamenaScreenHeader({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZamenaScreenHeaderState();
}

class _ZamenaScreenHeaderState extends ConsumerState<ZamenaScreenHeader> {
  

  @override
  Widget build(final BuildContext context) {
    return AnimatedSize(
      duration: Delays.morphDuration,
      alignment: Alignment.topCenter,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: Delays.morphDuration,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(10),
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
                child: ref.watch(zamenaScreenProvider).isPanelExpanded
                    ? const MonthNavigationPanel()
                    : WeekNavigationStrip(initialDate: ref.watch(zamenaScreenProvider).currentDate,
                ),
              ),
            ),
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
    final bool isExpanded = ref.watch(zamenaScreenProvider).isPanelExpanded;
    final DateTimeRange visible = ref.watch(zamenaScreenProvider).visibleDateRange;
    final String title = '${visible.start.toMonth()} ${visible.start.year}';
    final bool isCurrentWeek = DateTime.now().isSameWeekAs(visible.start);

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
                isCurrentWeek: isCurrentWeek,
                onClicked: () {
                  ref.read(zamenaScreenProvider.notifier).setDate(DateTime.now());
                  ref.read(zamenaScreenProvider.notifier).setVisibleDateRange(DateTimeRange(
                    start: DateTime.now().toStartOfWeek(),
                    end: DateTime.now().toEndOfWeek(),
                  ));
                },
              ),
              GestureDetector(
                onTap: () {
                  ref.read(zamenaScreenProvider.notifier).togglePanel();
                },
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 150),
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
  const MonthNavigationPanel({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MonthState();
}

class _MonthState extends ConsumerState<MonthNavigationPanel> {

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      child: SfDateRangePicker(
        backgroundColor: Colors.transparent,
        initialDisplayDate: ref.watch(zamenaScreenProvider).currentDate,
        headerHeight: 0,
        monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
        onSelectionChanged: (final dateRangePickerSelectionChangedArgs) {
          final DateTime date = dateRangePickerSelectionChangedArgs.value;
          ref.read(zamenaScreenProvider.notifier).setDate(date);
        },
        onViewChanged: _onViewChanged,
        cellBuilder: (final context, final cellDetails) {
          return MonthCell(
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
  final DateTime initialDate;

  const WeekNavigationStrip({
    required this.initialDate,
    super.key,
  });

  @override
  ConsumerState<WeekNavigationStrip> createState() => _WeekNavigationStripState();
}

class _WeekNavigationStripState extends ConsumerState<WeekNavigationStrip> {
  late PageController _pageController;
  late DateTime _baseDate;
  static const int _initialPage = 1000;

  @override
  void initState() {
    super.initState();
    _baseDate = widget.initialDate;
    _pageController = PageController(initialPage: _initialPage);
  }

  // Получает начало недели для заданного сдвига от базовой даты
  DateTime _getStartOfWeek(final int weekOffset) {
    final current = _baseDate.add(Duration(days: weekOffset * 7));
    return current.subtract(Duration(days: current.weekday - 1)); // Monday
  }

  static const List<String> days = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ'];

  @override
  Widget build(final BuildContext context) {
    ref.watch(zamenaScreenProvider).visibleDateRange;
    return SizedBox(
      height: 80,
      child: PageView.builder(
        controller: _pageController,
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

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 6,
                children: [
                  Text(
                    days[day.weekday - 1],
                    style: context.styles.ubuntu14,
                  ),
                  Bounceable(
                    onTap: () {
                      ref.read(zamenaScreenProvider.notifier).setDate(day);
                    },
                    child: AnimatedContainer(
                      duration: Delays.morphDuration,
                      decoration: BoxDecoration(
                        border: current
                          ? Border.all(color: Theme.of(context).colorScheme.primary)
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
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
