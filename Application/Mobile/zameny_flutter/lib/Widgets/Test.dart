import 'package:flutter/material.dart';

class CustomSliverPersistentHeader extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;

  CustomSliverPersistentHeader({
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double paddingValue = 20.0; // начальное значение отступа

    // Изменяем отступ в зависимости от shrinkOffset
    if (shrinkOffset > 0) {
      // Подстраиваем отступ по мере закрытия слейвера
      paddingValue = 20.0 - (shrinkOffset / 2); // или любое другое значение
      if (paddingValue < 5.0) {
        paddingValue = 5.0; // минимальный отступ, если нужно
      }
    }

    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 59, 64, 82),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 43, 43, 58),
                  blurStyle: BlurStyle.outer,
                  blurRadius: 12)
            ]),
        child: Center(
            child: Text(
          "втф чзх",
          style: TextStyle(
              fontSize: 30, color: Colors.red, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
    // return maxHeight != oldDelegate.maxExtent ||
    //     minHeight != oldDelegate.minExtent;
  }
}
