import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const TimeTableHeader(),
                  const SizedBox(height: 10),
                   Text("СЕРЕЖА ДАЙ ДОДЕЛАТЬ",style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),)
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
        // IconButton(
        //   icon: const Icon(
        //     Icons.bug_report,
        //     size: 28,
        //   ),
        //   onPressed: () {
        //   },
        //   color: Theme.of(context).primaryColorLight,
        // ),
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
        // IconButton(
        //     onPressed: () {
        //     },
        //     icon: Icon(
        //       Icons.more_horiz_rounded,
        //       size: 36,
        //       color: Theme.of(context).primaryColorLight,
        //     ))
      ],
    );
  }
}
