import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final drawerProvider = StateProvider<_DrawerService>((ref) {
  return _DrawerService(ref);
});

class _DrawerService {
  _DrawerService(StateProviderRef<_DrawerService> ref) {
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
