import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_group_widget.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';


class ZamenaViewGroup extends ConsumerWidget {
  final List<ZamenaFull> fullZamenas;
  final List<Zamena> zamenas;

  const ZamenaViewGroup({
    required this.zamenas,
    required this.fullZamenas,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final Set<int> groupsList = zamenas.map((final Zamena zamena) => zamena.groupID).toSet();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: groupsList.map((final int groupId) {
        final List<Zamena> groupZamenas = zamenas.where((final Zamena zamena) => zamena.groupID == groupId).toList();
        final bool isFullZamena = fullZamenas.any((final ZamenaFull fullzamena) => fullzamena.group == groupId);
        final Group? group = ref.watch(groupProvider(groupId));

        return ZamenaGroupWidget(
          groupZamenas: groupZamenas,
          isFullZamena: isFullZamena,
          group: group,
        );
      }).toList(),
    );
  }
}
