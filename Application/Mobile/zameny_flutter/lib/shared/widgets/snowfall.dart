import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfall/flutterfall.dart';

import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/shared/providers/main_provider.dart';

class SnowFall extends ConsumerWidget {
  const SnowFall({
    super.key,
  });

  List<String>? _defineFallImages() {
    final DateTime date = DateTime.now();
    if (date.betweenIgnoreYear(DateTime(2024, 10), DateTime(2024, 11))) {
      return [Images.autumnLeaves];
    }
    if (date.betweenIgnoreYear(DateTime(2024, 11), DateTime(2025, 2, 28))) {
      return [Images.snowflake];
    }
    return null;
  }


  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final List<String>? images = _defineFallImages();
    return (
      images == null
      || (!ref.watch(mainProvider).falling)
    )
    ? const SizedBox()
    : const IgnorePointer(
      child: RepaintBoundary(
        child: FlutterFall(
          totalObjects: 25,
          particleImage: [Images.snowflake],
        ),
      ),
    );
  }
}

extension DateTimeExtensions on DateTime {
  bool betweenIgnoreYear(final DateTime start, final DateTime end) {
    // Convert to a uniform year (0) for comparison
    final DateTime thisDate = DateTime(0, month, day);
    final DateTime startDate = DateTime(0, start.month, start.day);
    final DateTime endDate = DateTime(0, end.month, end.day);

    // Check if date range crosses year boundary (e.g., November to February)
    if (startDate.isAfter(endDate)) {
      // When the range wraps around the year boundary
      return thisDate.isAfter(startDate) || thisDate.isBefore(endDate) || thisDate == startDate || thisDate == endDate;
    } else {
      // Standard range within the same year
      return (thisDate.isAfter(startDate) && thisDate.isBefore(endDate)) || thisDate == startDate || thisDate == endDate;
    }
  }

  bool sameDate(final DateTime other) {
    return year == other.year && month == other.month && other.day == day;
  }
}
