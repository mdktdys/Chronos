import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/current_lesson_timer.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/schedule_date_header.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/search_result_header.dart';
import 'package:zameny_flutter/new/providers/main_provider.dart';
import 'package:zameny_flutter/new/providers/search_item_provider.dart';
import 'package:zameny_flutter/widgets/adaptive_layout.dart';
import 'package:zameny_flutter/widgets/current_timing_timer.dart';
import 'package:zameny_flutter/widgets/favorite_stripe_widget.dart';
import 'package:zameny_flutter/widgets/schedule_header.dart';
import 'package:zameny_flutter/widgets/schedule_turbo_search.dart';
import 'package:zameny_flutter/widgets/schedule_view.dart';
import 'package:zameny_flutter/widgets/schedule_view_settings_widget.dart';
import 'package:zameny_flutter/widgets/test_widget.dart';
import 'package:zameny_flutter/widgets/zamena_check_time.dart';

MyGlobals myGlobals = MyGlobals();

class MyGlobals {
  GlobalKey mainKey = GlobalKey<ScaffoldState>();
  GlobalKey get scaffoldKey => mainKey;
}

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> with AutomaticKeepAliveClientMixin {
  late final FocusNode focusNode;

  @override
  bool get wantKeepAlive => true;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode()..addListener(_updateFocus);
    scrollController = ScrollController();

    scrollController.addListener((){
      ref.read(mainProvider).updateScrollDirection(scrollController.position.userScrollDirection);
    });
  }

  @override
  void dispose() {
    focusNode.removeListener(_updateFocus);
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _updateFocus() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (context.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);

    Widget child;
    if (ref.watch(searchItemProvider) == null) {
      child = Align(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Constants.maxWidthDesktop),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                const Expanded(child: SizedBox()),
                AnimatedSwitcher(
                  duration: Delays.morphDuration,
                  child: Text(
                    key: ValueKey(focusNode.hasFocus),
                    focusNode.hasFocus
                      ? 'Введи имя группы, преподавателя или кабинета'
                      : 'Расписание',
                    textAlign: TextAlign.center,
                    style: context.styles.ubuntuPrimaryBold24,
                  ),
                ),
                const Row(
                  children: [
                    Expanded(child: CurrentTimingTimer()),
                    ZamenaCheckTime(),
                  ],
                ),
                const FavoriteStripeWidget(),
                Expanded(
                  child: SingleChildScrollView(
                    child: ScheduleTurboSearch(
                      withFavorite: false,
                      focusNode: focusNode,
                    ),
                  ),
                ),
                SizedBox(height: Constants.bottomSpacing)
              ],
            ),
          ),
        ),
      );
    } else {
      child = Scaffold(
        resizeToAvoidBottomInset: false,
        key: myGlobals.scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: AdaptiveLayout(
            desktop: () => () {
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.list(
                      children: [
                        const ScheduleHeader(),
                        const SizedBox(height: 10),
                        ScheduleTurboSearch(focusNode: focusNode),
                        const SizedBox(height: 10),
                        const DateHeader(),
                        const SizedBox(height: 10),
                        const CurrentLessonTimer(),
                        const SearchResultHeader(),
                        const SizedBox(height: 5),
                        // LessonView(scrollController: scrollController),
                        const ScheduleViewSettingsWidget(),
                        const SizedBox(height: 10),
                        ScheduleView(scrollController: scrollController),
                      ]
                    ),
                  ),
                  const Test()
                ]
              );
            }(),
            mobile: () => () {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Theme.of(context).colorScheme.surface,
                body: CustomScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      sliver: SliverList.list(
                        children: [
                          // const TopBanner(),
                          // const SizedBox(height: 10),
                          const ScheduleHeader(),
                          const SizedBox(height: 10),
                          ScheduleTurboSearch(
                            focusNode: focusNode,
                          ),
                          const SizedBox(height: 10),
                          const DateHeader(),
                          const SizedBox(height: 10),
                          const CurrentLessonTimer(),
                          const SizedBox(height: 10),
                          // LessonView(scrollController: scrollController),
                          const SearchResultHeader(),
                          const SizedBox(height: 10),
                          const ScheduleViewSettingsWidget(),
                          const SizedBox(height: 10),
                          ScheduleView(scrollController: scrollController),
                        ]
                      ),
                    ),
                    const Test()
                  ]
                ),
              );
            }()
          ),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: Delays.morphDuration,
      child: child,
    );
  }
}
