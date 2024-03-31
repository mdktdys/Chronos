import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';
import 'package:zameny_flutter/secrets.dart';

class SearchResultHeader extends StatelessWidget {
  const SearchResultHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ScheduleProvider provider = context.watch<ScheduleProvider>();
    GetIt.I.get<Talker>().debug(provider.searchType);
    bool enabled = provider.searchType == SearchType.teacher ? true : false;
    return Column(
      children: [
        Text(provider.getSearchTypeNamed(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.inverseSurface,
                fontFamily: 'Ubuntu',
                fontSize: 18)),
        Text(provider.searchDiscribtion(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.inverseSurface,
                fontFamily: 'Ubuntu',
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        enabled && IS_DEV
            ? Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        provider.chas();
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.1)),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.1)),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
