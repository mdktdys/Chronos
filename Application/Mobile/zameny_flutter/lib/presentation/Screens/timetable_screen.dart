import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/domain/Providers/time_table_provider.dart';
import 'package:zameny_flutter/domain/Models/models.dart';
import 'package:zameny_flutter/domain/Services/tools.dart';

class TimeTableWrapper extends StatelessWidget {
  const TimeTableWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimeTableProvider(),
      child: const TimeTableScreen(),
    );
  }
}

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const TimeTableHeader(),
                const SizedBox(height: 10),
                const CurrentLessonTimer(),
                // const SizedBox(height: 10),
                Row(
                  children: [
                    // SizedBox(
                    //   width: 18,
                    //   child: Stack(
                    //     children: [
                    //       Container(
                    //         alignment: Alignment.topCenter,
                    //         width: 8,
                    //         decoration: BoxDecoration(
                    //             color: Colors.amber.withOpacity(0.15),
                    //             borderRadius: BorderRadius.circular(20)),
                    //       ),
                    //       FractionallySizedBox(
                    //         heightFactor: provider.getHeight(),
                    //         child: Container(
                    //           alignment: Alignment.topCenter,
                    //           width: 10,
                    //           decoration: BoxDecoration(
                    //               color: Colors.amber.withOpacity(1),
                    //               borderRadius: BorderRadius.circular(20)),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                          children: List.generate(7, (index) {
                        LessonTimings? timing = GetIt.I
                            .get<Data>()
                            .timings
                            .where(
                              (element) => element.number == (index + 1),
                            )
                            .firstOrNull;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.1),
                          ),
                          child: timing == null
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    const SizedBox(width: 20),
                                    Container(
                                      width: 45,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 2)),
                                      child: Center(
                                        child: Text(
                                          (index + 1).toString(),
                                          style: const TextStyle(
                                              fontFamily: 'Ubuntu',
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                        "${getTimeFromDateTime(timing.start)}-${getTimeFromDateTime(timing.end)}",
                                        style: const TextStyle(
                                            fontFamily: 'Ubuntu',
                                            color: Colors.white,
                                            fontSize: 20))
                                  ],
                                ),
                        );
                      })),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class CurrentLessonTimer extends StatefulWidget {
  const CurrentLessonTimer({
    super.key,
  });

  @override
  State<CurrentLessonTimer> createState() => _CurrentLessonTimerState();
}

class _CurrentLessonTimerState extends State<CurrentLessonTimer> {
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

  String getElapsedTime() {
    LessonTimings timing = getLessonTiming()!;
    bool isSaturday = DateTime.now().weekday == 6;
    Duration left = isSaturday
        ? timing.saturdayEnd.difference(DateTime.now())
        : timing.end.difference(DateTime.now());

    int hours = left.inHours;
    int minutes = left.inMinutes;
    int seconds = left.inSeconds;

    int secs = seconds % 60;

    return '$hours:${minutes % 60}:${secs > 9 ? secs : '0$secs'}';
  }

  LessonTimings? getLessonTiming() {
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
      LessonTimings? timing = GetIt.I
          .get<Data>()
          .timings
          .where((element) =>
              element.start.isBefore(current) && element.end.isAfter(current))
          .firstOrNull;
      return timing;
    }
  }

  @override
  Widget build(BuildContext context) {
    LessonTimings? timing = getLessonTiming();
    DateTime current = DateTime.now();
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      curve: Curves.ease,
      child: timing == null || current.weekday == 7
          ? const SizedBox()
          : SizedBox(
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
                      Text("Осталось: ${getElapsedTime()}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(0.7),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Ubuntu')),
                    ]),
              ),
            ),
    );
  }
}

class TimeTableHeader extends StatelessWidget {
  const TimeTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: 52,
            height: 52,
            child: Center(
                child: SvgPicture.asset(
              "assets/icon/notification.svg",
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.inverseSurface,
                  BlendMode.srcIn),
              width: 32,
              height: 32,
            ))),
        Expanded(
          child: Text(
            "Звонки",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Ubuntu'),
          ),
        ),
        const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.more_horiz_rounded,
              size: 36,
              color: Colors.transparent,
            ))
      ],
    );
  }
}
