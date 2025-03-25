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
                fontWeight: ref.watch(zamenaScreenProvider).view == ZamenaViewType.group
                  ? FontWeight.bold
                  : FontWeight.w400,
                color: ref.watch(zamenaScreenProvider).view == ZamenaViewType.group
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6),
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
              'Преподы',
              style: context.styles.ubuntu16.copyWith(
                fontWeight: ref.watch(zamenaScreenProvider).view == ZamenaViewType.teacher
                  ? FontWeight.bold
                  : FontWeight.w400,
                fontFamily: 'Ubuntu',
                fontSize: 16,
                color: ref.watch(zamenaScreenProvider).view == ZamenaViewType.teacher
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
