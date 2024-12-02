import 'package:flutter/cupertino.dart';

import 'package:zameny_flutter/secrets.dart';

class MainProvider extends ChangeNotifier {
  PageController pageController = PageController(initialPage: 1);

  bool isDev = IS_DEV;
  bool falling = true;

  int currentPage = 1;
  // bool get pageViewScrollEnabled => currentPage != 3;
  bool get pageViewScrollEnabled => true;

  void setPage(final int index) {
    currentPage = index;
    pageController.jumpToPage(index);
    notifyListeners();
  }

  void pageChanged(final int value) {
    currentPage = value;
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
}
