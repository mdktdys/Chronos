import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/presentation/Providers/time_table_provider.dart';

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
    TimeTableProvider provider = context.watch<TimeTableProvider>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const TimeTableHeader(),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              width: 8,
                              decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            FractionallySizedBox(
                              heightFactor: provider.getHeight(),
                              child: Container(
                                alignment: Alignment.topCenter,
                                width: 10,
                                decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(1),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(7, (index) {
                                LessonTimings? timing = GetIt.I
                                    .get<Data>()
                                    .timings
                                    .where(
                                      (element) =>
                                          element.number == (index + 1),
                                    )
                                    .firstOrNull;
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.1),
                                  ),
                                  height: 80,
                                  child: timing == null
                                      ? SizedBox()
                                      : Row(
                                          children: [
                                            const SizedBox(width: 20),
                                            Container(
                                              width: 45,
                                              height: 45,
                                              child: Center(
                                                child: Text(
                                                  (index + 1).toString(),
                                                  style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      width: 2)),
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                                "${timing!.start}-${timing!.end}",
                                                style: TextStyle(
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
                  ),
                  const SizedBox(height: 85),
                ],
              ),
            ),
          )
        ],
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
