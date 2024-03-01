import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

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
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const TimeTableHeader(),
                  const SizedBox(height: 10),
                  Text(
                    "СЕРЕЖА ДАЙ ДОДЕЛАТЬ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inverseSurface),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Одинцов гага буга поломай все снова",
                        style: TextStyle(
                          fontSize: 20,
                            color: Theme.of(context).colorScheme.inverseSurface),
                      ),
                    ),
                  )
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
        Container(
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
