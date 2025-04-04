import 'package:flutter/material.dart';

import 'package:zameny_flutter/modules/schedule/presentation/widgets/mobile_bottom_bar.dart';
import 'package:zameny_flutter/widgets/pages_view_widget.dart';

class MobileView extends StatelessWidget {
  const MobileView({super.key});

  @override
  Widget build(final BuildContext context) {
    return const Stack(
      children: [
        PagesViewWidget(),
        AnimatedBottomBar(),
      ],
    );
  }
}
