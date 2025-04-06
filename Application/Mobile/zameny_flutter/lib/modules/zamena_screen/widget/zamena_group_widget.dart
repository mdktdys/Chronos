import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';

class ZamenaGroupWidget extends ConsumerWidget {
  final List<Zamena> groupZamenas;
  final bool isFullZamena;
  final Group? group;

  const ZamenaGroupWidget({
    required this.isFullZamena,
    required this.groupZamenas,
    required this.group,
    super.key
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              group!.name,
              style: context.styles.ubuntuInverseSurface20
            ),
            isFullZamena
              ? Text(
                  'Полная замена',
                  style: context.styles.ubuntu18.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.7))
                )
              : const SizedBox.shrink(),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: groupZamenas.map((final zamena) {
            final course =  ref.watch(courseProvider(zamena.courseID)) ?? Course.mock();
            final teacher = ref.watch(teacherProvider(zamena.teacherID)) ?? Teacher.mock();
            final cabinet = ref.watch(cabinetProvider(zamena.cabinetID)) ?? Cabinet.mock();

            if (course.id == 10843) {
              return EmptyCourseTileRework(
                placeReason: '',
                searchType: SearchType.group,
                obed: false,
                index: zamena.lessonTimingsID,
                lesson: Lesson(
                  id: -1,
                  number: zamena.lessonTimingsID,
                  group: zamena.groupID,
                  date: zamena.date,
                  course: zamena.courseID,
                  teacher: zamena.teacherID,
                  cabinet: zamena.cabinetID
                )
              );
            }

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                ),
                child: CourseTileRework(
                  placeReason: '',
                  searchType: SearchType.group,
                  index: zamena.lessonTimingsID,
                  isSaturday: false,
                  lesson: Lesson(
                    id: course.id,
                    number: zamena.lessonTimingsID,
                    group: group!.id,
                    date: zamena.date,
                    course: course.id,
                    teacher: teacher.id,
                    cabinet: cabinet.id,
                  )
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
