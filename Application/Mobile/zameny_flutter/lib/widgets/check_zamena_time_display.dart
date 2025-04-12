import 'package:flutter/material.dart';

import 'package:zameny_flutter/config/extensions/datetime_extension.dart';

class CheckZamenaTimeDisplay extends StatelessWidget {
  final bool refreshing;
  final DateTime time;

  const CheckZamenaTimeDisplay({
    required this.refreshing, 
    required this.time,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text(
              time.hhmm(),
              style: TextStyle(
                fontFamily: 'Ubuntu',
                color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6),
                fontSize: 14
              ),
            ),
            refreshing
            ? const SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(),
              )
            : const SizedBox(),
          ],
        ),
        Text(
          refreshing
            ? 'Проверяю'
            : 'Проверено',
          style: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 14,
            color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
