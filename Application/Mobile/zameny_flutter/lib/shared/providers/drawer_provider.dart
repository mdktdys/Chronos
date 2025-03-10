import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final drawerProvider = StateProvider<_DrawerService>((final ref) {
  return _DrawerService(ref);
});

class _DrawerService {
  final Ref ref;
  
  _DrawerService(this.ref) {
    open = true;
  }

  bool open = true;

  void openDrawer() {
    
    open = !open;
    log("message");

    //drawerAnimationControllerProvider.animateTo( open ? 1.0 : 0.0);
  }

  void closeDrawer() {
    open = !open;
  }
}
