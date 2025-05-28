import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_provider.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_view_group.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_view_teacher.dart';
import 'package:zameny_flutter/shared/domain/models/models.dart';
import 'package:zameny_flutter/widgets/failed_load_widget.dart';
import 'package:zameny_flutter/widgets/skeletonized_provider.dart';

class ZamenaView extends ConsumerWidget {
  const ZamenaView({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {

    return SkeletonizedProvider<(List<Zamena>,List<ZamenaFull>)>(
      provider: zamenasListProvider,
      fakeData: ZamenasNotifier.fake,
      data: (final (List<Zamena>, List<ZamenaFull>) data) {
        if (data.$1.isEmpty) {
          return Center(
            key: const ValueKey('noData'),
            child: Text(
              'Нет замен',
              style: context.styles.ubuntu14,
            ),
          );
        }
        final view = ref.watch(zamenaScreenProvider.select((final ZamenaScreenState value) => value.view));

        Widget? child;
        if (view == ZamenaViewType.group) {
          child = ZamenaViewGroup(
            zamenas: data.$1,
            fullZamenas: data.$2,
          );
        } else if (view == ZamenaViewType.teacher) {
           child = ZamenaViewTeacher(
            zamenas: data.$1,
            fullZamenas: data.$2,
          );
        }
    
        return AnimatedSwitcher(
          duration: Delays.morphDuration,
          child: child ?? const SizedBox(),
        );
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
    );
  }
}
