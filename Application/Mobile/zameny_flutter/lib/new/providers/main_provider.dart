import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/bottom_bar_items.dart';
import 'package:zameny_flutter/secrets.dart';
import 'package:zameny_flutter/shared/providers/navigation/navigation_provider.dart';

final mainProvider = ChangeNotifierProvider<RiverPodMainProvider>((final ref) {
  return RiverPodMainProvider(ref);
});

class RiverPodMainProvider extends ChangeNotifier {
  final Ref ref;
  RiverPodMainProvider(this.ref);

  bool bottomBarShow = true;
  ScrollDirection latestDirection = ScrollDirection.idle;

  PageController pageController = PageController(initialPage: 1);

  bool isDev = IS_DEV;
  bool falling = true;

  int currentPage = 1;
  bool get pageViewScrollEnabled => currentPage != 4;

  void setPage(final int index) {
    currentPage = index;
    pageController.jumpToPage(index);
    notifyListeners();
  }

  void pageChanged(final int value, final BuildContext context) {
    final BottomBarModel page = model.where((final page) => page.index == value).first;

    currentPage = value;
    ref.read(navigationProvider).setParams({'page': page.path});
    notifyListeners();  
  }

  void switchFalling() {
    falling = !falling;
    notifyListeners();
  }

  void switchDev() {
    isDev = !isDev;
    IS_DEV = isDev;
    notifyListeners();
  }

  void updateScrollDirection(final ScrollDirection direction) {
    if (latestDirection == direction) {
      return;
    }
  
    latestDirection = direction; 
    bottomBarShow = direction == ScrollDirection.forward;
    notifyListeners();
  }
}
