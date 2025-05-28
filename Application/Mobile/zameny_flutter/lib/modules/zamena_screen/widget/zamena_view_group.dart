import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/spacing.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_group_widget.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';
import 'package:zameny_flutter/shared/domain/models/models.dart';


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

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: Spacing.listHorizontalPadding, right: Spacing.listHorizontalPadding),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupsList.length,
      itemBuilder: (final BuildContext context, final int index) {
        final int groupId = groupsList.elementAt(index);
        final List<Zamena> groupZamenas = zamenas.where((final Zamena zamena) => zamena.groupID == groupId).toList();
        final bool isFullZamena = fullZamenas.any((final ZamenaFull fullzamena) => fullzamena.group == groupId);
        final Group? group = ref.watch(groupProvider(groupId));

        return ZamenaGroupWidget(
          groupZamenas: groupZamenas,
          isFullZamena: isFullZamena,
          group: group,
        );
      },
    );
  }
}
