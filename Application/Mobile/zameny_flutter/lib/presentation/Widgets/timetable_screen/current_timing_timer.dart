import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';

import '../../../domain/Models/lesson_timings_model.dart';

class CurrentTimingTimer extends StatefulWidget {
  final bool obed;
  const CurrentTimingTimer({super.key, required this.obed});

  @override
  State<CurrentTimingTimer> createState() => _CurrentTimingTimerState();
}

class _CurrentTimingTimerState extends State<CurrentTimingTimer> {
  late Timer ticker;

  @override
  void initState() {
    super.initState();
    ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      tick();
    });
  }

  tick() {
    setState(() {});
  }

  @override
  void dispose() {
    ticker.cancel();
    super.dispose();
  }

  String getElapsedTime(bool obed) {
    LessonTimings timing = getLessonTiming(obed)!;
    bool isSaturday = DateTime.now().weekday == 6;
    Duration left = isSaturday
        ? timing.saturdayEnd.difference(DateTime.now())
        : (obed
            ? timing.obedEnd.difference(DateTime.now())
            : timing.end.difference(DateTime.now()));

    int hours = left.inHours;
    int minutes = left.inMinutes;
    int seconds = left.inSeconds;

    int secs = seconds % 60;
    int mints = minutes % 60;

    return '$hours:${mints > 9 ? mints : '0$mints'}:${secs > 9 ? secs : '0$secs'}';
  }

  LessonTimings? getLessonTiming(bool obed) {
    DateTime current = DateTime.now();
    bool isSaturday = current.weekday == 6;
    if (isSaturday) {
      LessonTimings? timing = GetIt.I
          .get<Data>()
          .timings
          .where((element) =>
              element.start.isBefore(current) &&
              element.saturdayEnd.isAfter(current))
          .firstOrNull;
      return timing;
    } else {
      if (obed) {
        LessonTimings? timing = GetIt.I
            .get<Data>()
            .timings
            .where((element) =>
                element.obedStart.isBefore(current) &&
                element.obedEnd.isAfter(current))
            .firstOrNull;
        return timing;
      } else {
        LessonTimings? timing = GetIt.I
            .get<Data>()
            .timings
            .where((element) =>
                element.start.isBefore(current) && element.end.isAfter(current))
            .firstOrNull;
        return timing;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LessonTimings? timing = getLessonTiming(widget.obed);
    DateTime current = DateTime.now();
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      curve: Curves.ease,
      child: timing == null || current.weekday == 7
          ? const SizedBox()
          : Builder(builder: (context) {
              return SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Сейчас идет ${timing.number} пара",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Ubuntu')),
                        const SizedBox(height: 5),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Осталось: ${getElapsedTime(widget.obed)}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: widget.obed && timing.number > 3
                                          ? Colors.green
                                          : Theme.of(context)
                                              .primaryColorLight
                                              .withOpacity(0.7),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Ubuntu')),
                            ]),
                      ]),
                ),
              );
            }),
    );
  }
}
