
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zameny_flutter/presentation/Providers/schedule_provider.dart';

class SearchResultHeader extends StatelessWidget {
  const SearchResultHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ScheduleProvider provider = context.watch<ScheduleProvider>();
    return Column(
      children: [
        Text(provider.getSearchTypeNamed(),
            style: TextStyle(
                color: Theme.of(context).colorScheme.inverseSurface,
                fontFamily: 'Ubuntu',
                fontSize: 18)),
        Text(provider.searchDiscribtion(),
            style: TextStyle(
                color: Theme.of(context).colorScheme.inverseSurface,
                fontFamily: 'Ubuntu',
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}