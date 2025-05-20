import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_groups_practice_provider.dart';
import 'package:zameny_flutter/widgets/search_item_chip.dart';

class ZamenaPracticeGroupsBlock extends ConsumerWidget {
  const ZamenaPracticeGroupsBlock({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return ref.watch(fetchPracticeGroupsByDateProvider).when(
      data: (final data) {
        if(data.isEmpty) {
          return const SizedBox();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            Text(
              'Группы на практике',
              style: context.styles.ubuntuInverseSurface20,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: data.map((final Group group) {
                return SearchItemChip(searchItem: group);
              }).toList(),
            )
          ],
        );
    }, error: (final error, final obj) {
      return const SizedBox();
    }, loading: () {
      return const SizedBox();
    },);
  }
}
