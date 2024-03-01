import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        Container(
            width: 52,
            height: 52,
            child: Center(
                child: SvgPicture.asset(
              "assets/icon/vuesax_linear_note.svg",
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.inverseSurface,
                  BlendMode.srcIn),
              width: 32,
              height: 32,
            ))),
        Text(
          "Расписание",
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
                  builder: (context) => SizedBox(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "Показать логи Talker",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      fontFamily: 'Ubuntu'),
                                ),
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
