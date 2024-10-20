export 'splash_screen_stub.dart'
    if (dart.library.js_util) 'splash_screen_web.dart'
    if (dart.library.io) 'splash_screen_android.dart';
