import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/spacing.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_group_widget.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_view.dart';
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
    final List<Group> groups = groupsList.map((final int groupId) {
      return ref.watch(groupProvider(groupId))!;
    }).toList();
    
    final String filter = ref.watch(zamenaSearchStringProvider);
    final List<Group> filtered = groups.where((final Group group) => group.name.toLowerCase().contains(filter)).toList();

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: Spacing.listHorizontalPadding, right: Spacing.listHorizontalPadding),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (final BuildContext context, final int index) {
        final Group group = filtered.elementAt(index);
        final List<Zamena> groupZamenas = zamenas.where((final Zamena zamena) => zamena.groupID == group.id).toList();
        final bool isFullZamena = fullZamenas.any((final ZamenaFull fullzamena) => fullzamena.group == group.id);

        return ZamenaGroupWidget(
          groupZamenas: groupZamenas,
          isFullZamena: isFullZamena,
          group: group,
        );
      },
    );
  }
}
