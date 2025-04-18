import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_provider.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_view_group.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_view_teacher.dart';
import 'package:zameny_flutter/widgets/failed_load_widget.dart';
import 'package:zameny_flutter/widgets/skeletonized_provider.dart';

class ZamenaView extends ConsumerStatefulWidget {
  const ZamenaView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZamenaViewState();
}

class _ZamenaViewState extends ConsumerState<ZamenaView> {
  @override
  Widget build(final BuildContext context) {
    final view = ref.watch(zamenaScreenProvider.select((final ZamenaScreenState value) => value.view));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: SkeletonizedProvider<(List<Zamena>,List<ZamenaFull>)>(
        provider: zamenasListProvider,
        fakeData: ZamenasNotifier.fake,
        data: (final (List<Zamena>,List<ZamenaFull>) data) {
          if (data.$1.isEmpty) {
            return Center(
              key: const ValueKey('noData'),
              child: Text(
                'Нет замен',
                style: context.styles.ubuntu14,
              ),
            );
          }

          switch (view) {
            case ZamenaViewType.group:
              return ZamenaViewGroup(
                zamenas: data.$1,
                fullZamenas: data.$2,
              );
            case ZamenaViewType.teacher:
              return ZamenaViewTeacher(
                zamenas: data.$1,
                fullZamenas: data.$2,
              );
          }
        },
        error: (final error, final trace) {
          return Center(
            key: const ValueKey('error'),
            child: FailedLoadWidget(
              error: error.toString(),
              onClicked: () => ref.invalidate(zamenasListProvider)
            ),
          );
        },
      )
    );
  }
}
