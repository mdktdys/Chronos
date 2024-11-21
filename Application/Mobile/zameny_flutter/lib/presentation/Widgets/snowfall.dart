
import 'package:flutter/material.dart';
import 'package:flutterfall/flutterfall.dart';
import 'package:provider/provider.dart';
import 'package:zameny_flutter/configs/images.dart';
import 'package:zameny_flutter/domain/Providers/main_provider.dart';

class SnowFall extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final List<String>? images = _defineFallImages();
    return images == null || (!context.watch<MainProvider>().falling)
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
  bool betweenIgnoreYear(DateTime start, DateTime end) {
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
}
