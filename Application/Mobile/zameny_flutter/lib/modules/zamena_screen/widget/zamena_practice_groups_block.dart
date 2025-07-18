import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/spacing.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_groups_practice_provider.dart';
import 'package:zameny_flutter/shared/domain/models/models.dart';
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

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Spacing.listHorizontalPadding),
          child: Column(
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
                  return SearchItemChip(title: group.name);
                }).toList(),
              )
            ],
          ),
        );
      }, error: (final error, final obj) {
        return const SizedBox();
      }, loading: () {
        return const SizedBox();
      },
    );
  }
}

class ZamenaTeacherCabinetSwaps extends ConsumerWidget {
  const ZamenaTeacherCabinetSwaps({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return ref.watch(fetchTeacherCabinetSwapsProvider).when(
      data: (final data) {
        if (data.isEmpty) {
          return const SizedBox();
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Spacing.listHorizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              Text(
                'Замены кабинетов',
                style: context.styles.ubuntuInverseSurface20,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: data.map((final (Teacher, Cabinet) pair) {
                  return SearchItemChip(title: '${pair.$1.name} -> ${pair.$2.name}');
                }).toList(),
              )
            ],
          ),
        );
      }, error: (final error, final obj) {
        return const SizedBox();
      }, loading: () {
        return const SizedBox();
      },
    );
  }
}
