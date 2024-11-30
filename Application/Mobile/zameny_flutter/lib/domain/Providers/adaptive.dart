import 'package:flutter/widgets.dart';

class Adaptive {
  static bool isDesktop(final BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return 1890 <= width;
  }
}
