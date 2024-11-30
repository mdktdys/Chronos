import 'dart:developer';

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
  ScrollDirection latestDiraction = ScrollDirection.idle;

  void updateScrollDirection(final ScrollDirection direction) {
    log(direction.toString());
    if (latestDiraction != direction) {
      latestDiraction = direction; 
      bottomBarShow = direction == ScrollDirection.forward;
      log('update send');
      notifyListeners();
    }
  }
}
