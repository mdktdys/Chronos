import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/platform/in_app_update/in_app_update_stub.dart'
    if (dart.library.io) 'package:zameny_flutter/shared/providers/in_app_update/in_app_update_android.dart'
    if (dart.library.html) 'package:zameny_flutter/shared/providers/in_app_update/in_app_update_web.dart';

final inAppUpdateProvider = ChangeNotifierProvider<Updater>((final ref) {
  return Updater();
});
