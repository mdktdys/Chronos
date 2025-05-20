import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/spacing.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_date_navigation.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_file_block.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_practice_groups_block.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_view.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_view_chooser.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_view_header.dart';
import 'package:zameny_flutter/new/providers/main_provider.dart';
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
          padding: EdgeInsets.symmetric(horizontal: Spacing.listHorizontalPadding),
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
              const SizedBox(height: 8),
              const ZamenaPracticeGroupsBlock(),
              const SizedBox(height: 10),
              const ZamenaViewChooser(),
              const SizedBox(height: 8),
              const ZamenaView(),
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
  bool isExpanded = false;

  @override
  Widget build(final BuildContext context) {
    return AnimatedContainer(
      duration: Delays.morphDuration,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Май, 2025', style: TextStyle(color: Colors.white)),
              GestureDetector(
                onTap: () {
                  isExpanded = !isExpanded;
                  setState(() {
                    
                  });
                },
                child: const Icon(Icons.more_vert, color: Colors.white),
              ),
            ],
          ),
          Animate().toggle(
            duration: 300.ms,
            builder: (final _, final value, final __) => AnimatedSwitcher(
              key: UniqueKey(),
              duration: 1.seconds,
              child: isExpanded
                ? const Text('data')
                : const Text('dasdata'),
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: days.map((final day) {
          //     return Text(day, style: const TextStyle(color: Colors.white));
          //   }).toList(),
          // ),
          SizedBox(
            child: SfDateRangePicker(
              backgroundColor: Colors.transparent,
              headerHeight: 0,
            ),
          )
        ],
      ),
    );
  }
}

List<String> days = [
  'ПН',
  'ВТ',
  'СР',
  'ЧТ',
  'ПТ',
  'СБ',
  'ВС'
];
