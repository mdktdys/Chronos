import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/spacing.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_date_navigation.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_file_block.dart';
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

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(() => ref.read(mainProvider).updateScrollDirection(controller.position.userScrollDirection));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return ScreenAppearBuilder(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Spacing.listHorizontalPadding),
          controller: controller,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const ZamenaScreenHeader(),
              // const DateHeader(),
              const SizedBox(height: 10),
              const ZamenaDateNavigation(),
              const SizedBox(height: 8),
              const ZamenaViewChooser(),
              const SizedBox(height: 8),
              // const WarningDevBlank(),
              // const SizedBox(height: 10),
              const ZamenaFileBlock(),
              const SizedBox(height: 10),
              const ZamenaView(),
              SizedBox(height: Constants.bottomSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
