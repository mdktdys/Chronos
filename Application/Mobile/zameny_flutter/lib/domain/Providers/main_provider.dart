import 'package:flutter/cupertino.dart';
import 'package:zameny_flutter/secrets.dart';

class MainProvider extends ChangeNotifier {
  PageController pageController = PageController(initialPage: 1);
  int currentPage = 1;

  bool isDev = IS_DEV;
  bool falling = true;

  setPage(int index) {
    currentPage = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutQuint);
        notifyListeners();
  }

  pageChanged(int value) {
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
