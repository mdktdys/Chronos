import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainProvider = ChangeNotifierProvider<RiverPodMainProvider>((final ref) {
  return RiverPodMainProvider(ref);
});

class RiverPodMainProvider extends ChangeNotifier {
  final Ref ref;
  RiverPodMainProvider(this.ref);

  bool bottomBarShow = true;
  ScrollDirection latestDirection = ScrollDirection.idle;

  void updateScrollDirection(final ScrollDirection direction) {
    if (latestDirection == direction) {
      return;
    }
  
    latestDirection = direction; 
    bottomBarShow = direction == ScrollDirection.forward;
    notifyListeners();
  }
}
