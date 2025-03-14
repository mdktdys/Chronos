import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/shared/providers/navigation/navigation_stub.dart'
    if (dart.library.io) 'package:zameny_flutter/shared/providers/navigation/navigation_android.dart'
    if (dart.library.html) 'package:zameny_flutter/shared/providers/navigation/navigation_web.dart';

final navigationProvider = ChangeNotifierProvider<Navigation>((final ref) {
  return Navigation();
});
