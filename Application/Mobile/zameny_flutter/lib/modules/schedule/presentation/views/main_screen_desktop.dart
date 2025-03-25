import 'package:flutter/material.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/desktop_side_bar.dart';
import 'package:zameny_flutter/widgets/pages_view_widget.dart';

class DesktopView extends StatelessWidget {
  const DesktopView({super.key});

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(width: Constants.sideBarWidth),
            const Expanded(child: PagesViewWidget()),
          ],
        ),
        const DesktopSideBar(),
      ],
    );
  }
}
