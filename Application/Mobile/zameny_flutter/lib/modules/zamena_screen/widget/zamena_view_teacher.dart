import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';

class ZamenaViewTeacher extends ConsumerWidget {
  final List<ZamenaFull> fullZamenas;
  final List<Zamena> zamenas;

  const ZamenaViewTeacher({
    required this.zamenas,
    required this.fullZamenas,
    super.key
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final Set<int> teachersList = zamenas.map((final zamena) => zamena.teacherID).toSet();
    final date = DateTime.now();

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: teachersList.map((final teacherId) {
          final groupZamenas = zamenas.where((final zamena) => zamena.teacherID == teacherId).toList();
          groupZamenas.sort((final a,final b) => a.lessonTimingsID > b.lessonTimingsID ? 1 : -1);
          final Teacher? teacher = ref.watch(teacherProvider(teacherId));

          if (teacher == null) {
            return const SizedBox();
          }

          if(teacher.name.replaceAll(' ', '') == ''){
            return const SizedBox();
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    teacher.name,
                    style: context.styles.ubuntuInverseSurface20,
                  )
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: groupZamenas.map((final zamena) {
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
                        searchType: SearchType.teacher,
                        index: zamena.lessonTimingsID,
                        isSaturday: false,
                        lesson: Lesson(
                          number: zamena.lessonTimingsID,
                          cabinet: zamena.cabinetID,
                          course: zamena.courseID,
                          group: zamena.groupID,
                          id: zamena.courseID,
                          teacher: teacher.id,
                          date: date,
                        )
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }).toList(),);
  }
}
