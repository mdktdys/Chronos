import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavigationItem extends StatelessWidget {
  final int index;
  final Function onTap;
  final String icon;
  final String text;
  final bool enabled;

  const BottomNavigationItem(
      {super.key,
      required this.index,
      required this.onTap,
      required this.icon,
      required this.text,
      required this.enabled});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 20,
      customBorder: Border.all(width: 10, color: Colors.red),
      enableFeedback: false,
      borderRadius: BorderRadius.circular(20),
      highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      onTap: () {
        if (enabled) {
          onTap.call(index);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      icon,
                      color: enabled
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.6),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          maxLines: 1,
                          text,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: enabled
                                  ? Theme.of(context).colorScheme.inverseSurface
                                  : Theme.of(context)
                                      .colorScheme
                                      .inverseSurface
                                      .withOpacity(0.6),
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ]),
            )),
      ),
    );
  }
}
