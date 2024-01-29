import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
        Icon(
          Icons.school_rounded,
          color: Theme.of(context).primaryColorLight,
          size: 36,
        ),
        Text(
          "Schedule",
          style: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Ubuntu'),
        ),
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                barrierColor: Colors.black.withOpacity(0.3),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  context: context,
                  builder: (context) => Container(
                    height: 100,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("Show debug"),
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => TalkerScreen(
                                            talker: GetIt.I.get<Talker>()))),
                              )
                            ],
                          ),
                        ),
                      ));
            },
            icon: Icon(
              Icons.more_horiz_rounded,
              size: 36,
              color: Theme.of(context).primaryColorLight,
            ))
      ],
    );
  }
}
