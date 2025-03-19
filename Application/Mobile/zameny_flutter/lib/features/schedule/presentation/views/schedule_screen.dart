import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/current_lesson_timer.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_date_header.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_header.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/search_result_header.dart';
import 'package:zameny_flutter/features/timetable/widgets/current_timing_timer.dart';
import 'package:zameny_flutter/new/widgets/favorite_stripe_widget.dart';
import 'package:zameny_flutter/new/widgets/schedule_view.dart';
import 'package:zameny_flutter/new/widgets/schedule_view_settings_widget.dart';
import 'package:zameny_flutter/new/widgets/test_widget.dart';
import 'package:zameny_flutter/shared/layouts/adaptive_layout.dart';
import 'package:zameny_flutter/shared/providers/main_provider.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';
import 'package:zameny_flutter/shared/widgets/top_banner.dart';

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
  @override
  bool get wantKeepAlive => true;
  late final ScrollController scrollController;

    @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    scrollController.addListener((){
      ref.read(mainProvider).updateScrollDirection(scrollController.position.userScrollDirection);
    });
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);

    if (ref.watch(searchItemProvider) == null) {
      return Align(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Constants.maxWidthDesktop),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Расписание',
                      textAlign: TextAlign.center,
                      style: context.styles.ubuntuPrimaryBold24,
                    ),
                  ),
                ),
                const CurrentTimingTimer(),
                const FavoriteStripeWidget(),
                const Expanded(
                  child: SingleChildScrollView(
                    child: ScheduleTurboSearch(
                      withFavorite: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      key: myGlobals.scaffoldKey,
      body: AdaptiveLayout(
        desktop: () => () {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              children: [
                const ScheduleHeader(),
                const SizedBox(height: 10),
                const ScheduleTurboSearch(),
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
          );
        }(),
        mobile: () => () {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: CustomScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  sliver: SliverList.list(
                    children: [
                      const TopBanner(),
                      const SizedBox(height: 10),
                      const ScheduleHeader(),
                      const SizedBox(height: 10),
                      const ScheduleTurboSearch(),
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
    );
  }
}
