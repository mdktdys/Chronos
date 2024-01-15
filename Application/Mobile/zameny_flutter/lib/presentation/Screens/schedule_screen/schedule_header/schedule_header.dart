import 'package:flutter/material.dart';

class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.school_rounded,
          color: Colors.white,
          size: 36,
        ),
        const Text(
          "Schedule",
          style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Ubuntu'),
        ),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz_rounded,
              size: 36,
              color: Colors.white,
            ))
      ],
    );
  }
}
