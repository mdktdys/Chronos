import 'package:flutter/cupertino.dart';

class MainProvider extends ChangeNotifier {
  PageController pageController = PageController(initialPage: 1);
  int currentPage = 1;

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
}
