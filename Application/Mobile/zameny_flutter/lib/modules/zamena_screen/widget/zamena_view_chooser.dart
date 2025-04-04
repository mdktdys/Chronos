import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_provider.dart';

class ZamenaViewChooser extends ConsumerWidget {
  const ZamenaViewChooser({
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ZamenaViewType viewType = ref.watch(zamenaScreenProvider).view;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            ref.read(zamenaScreenProvider.notifier).changeView(ZamenaViewType.group);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Группы',
              style: context.styles.ubuntu16.copyWith(
                fontWeight: viewType == ZamenaViewType.group
                  ? FontWeight.bold
                  : FontWeight.w400,
                color: viewType == ZamenaViewType.group
                  ? theme.colorScheme.primary
                  : theme.colorScheme.inverseSurface.withValues(alpha: 0.6),
                ),
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            ref.read(zamenaScreenProvider.notifier).changeView(ZamenaViewType.teacher);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Преподаватели',
              style: context.styles.ubuntu16.copyWith(
                fontWeight: viewType == ZamenaViewType.teacher
                  ? FontWeight.bold
                  : FontWeight.w400,
                fontFamily: 'Ubuntu',
                fontSize: 16,
                color: viewType == ZamenaViewType.teacher
                  ? theme.colorScheme.primary
                  : theme.colorScheme.inverseSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
