import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/config/spacing.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_file_link_provider.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_provider.dart';
import 'package:zameny_flutter/modules/zamena_screen/widget/zamena_view_chooser.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';
import 'package:zameny_flutter/new/providers/main_provider.dart';
import 'package:zameny_flutter/widgets/failed_load_widget.dart';
import 'package:zameny_flutter/widgets/screen_appear_builder.dart.dart';
import 'package:zameny_flutter/widgets/skeletonized_provider.dart';
import 'package:zameny_flutter/widgets/toggle_week_button.dart';


class ZamenaScreen extends ConsumerStatefulWidget {
  const ZamenaScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZamenaScreenState();
}

class _ZamenaScreenState extends ConsumerState<ZamenaScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(() => ref.read(mainProvider).updateScrollDirection(controller.position.userScrollDirection));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return ScreenAppearBuilder(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Spacing.listHorizontalPadding),
          controller: controller,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
             const ZamenaScreenHeader(),
              // const DateHeader(),
              const SizedBox(height: 10),
              const ZamenaDateNavigation(),
              const SizedBox(height: 8),
              const ZamenaViewChooser(),
              const SizedBox(height: 8),
              // const WarningDevBlank(),
              // const SizedBox(height: 10),
              const ZamenaFileBlock(),
              const SizedBox(height: 10),
              const ZamenaView(),
              SizedBox(height: Constants.bottomSpacing),
            ],
          ),
        ),
      ),
    );
  }
}

class ZamenaScreenHeader extends StatelessWidget {
  const ZamenaScreenHeader({super.key});

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Замены',
          style: context.styles.ubuntuPrimaryBold24,
        ),
      ],
    );
  }
}

class ZamenaView extends ConsumerStatefulWidget {
  const ZamenaView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZamenaViewState();
}

class _ZamenaViewState extends ConsumerState<ZamenaView> {
  @override
  Widget build(final BuildContext context) {
    final view = ref.watch(zamenaScreenProvider.select((final value) => value.view));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: SkeletonizedProvider<(List<Zamena>,List<ZamenaFull>)>(
        provider: zamenasListProvider,
        fakeData: ZamenasNotifier.fake,
        data: (final data) {
          if (data.$1.isEmpty) {
            return const Center(
              key: ValueKey('noData'),
              child: Text('Нет замен'),
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

class ZamenaFileBlock extends ConsumerWidget {
  const ZamenaFileBlock({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return AnimatedSize(
      duration: Delays.morphDuration,
      child: ref.watch(fetchZamenaFileLinksByDateProvider).when(
        data: (final data) {
          if(data.isEmpty) {
            return const SizedBox();
          }
          return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.open_in_new,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Column(
                    children: data.map((final ZamenaFileLink link) {
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => launchUrl(Uri.parse(link.link)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ссылка:',
                                  style: context.styles.ubuntuInverseSurface12,
                                ),
                                Text(
                                  link.link,
                                  style: context.styles.ubuntuInverseSurface10.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6))
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Время добавления в систему:',
                                  style: context.styles.ubuntuInverseSurface12,
                                ),
                                Text(
                                  '${link.created}',
                                  style: context.styles.ubuntuInverseSurface10.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6))
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),),
                ],
              ),);
      }, error: (final error, final obj) {
        return const SizedBox();
      }, loading: () {
        return const CircularProgressIndicator();
      },),
    );
  }
}

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
            final course =  ref.watch(courseProvider(zamena.courseID))!;
            final teacher = ref.watch(teacherProvider(zamena.teacherID))!;
            final cabinet = ref.watch(cabinetProvider(zamena.cabinetID))!;

            if (course.id == 10843) {
              return EmptyCourseTileRework(
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

class ZamenaDateNavigation extends ConsumerStatefulWidget {
  const ZamenaDateNavigation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ZamenaDateNavigationState();
}

class _ZamenaDateNavigationState extends ConsumerState<ZamenaDateNavigation> {
  @override
  Widget build(final BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ToggleWeekButton(
              next: false,
              onTap: () {
                ref.read(zamenaScreenProvider.notifier).toggleWeek(-1);
              },
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ref.watch(zamenaScreenProvider).currentDate.weekdayName(),
                        style: context.styles.ubuntuInverseSurfaceBold16,
                      ),
                      Text(
                        ref.watch(zamenaScreenProvider).currentDate.formatyyyymmdd(),
                        style: context.styles.ubuntu40012.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.5))
                      ),
                    ],
                  ),
                  AnimatedSize(
                    curve: Curves.easeOutCubic,
                    duration: const Duration(milliseconds: 150),
                    child: ref.watch(zamenaScreenProvider).currentDate.formatyyyymmdd() == DateTime.now().formatyyyymmdd()
                      ? Container(
                          margin: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              'Сегодня',
                              style: context.styles.ubuntuCanvasColorBold14,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            ToggleWeekButton(
              next: true,
              onTap: () {
                ref.read(zamenaScreenProvider.notifier).toggleWeek(1);
              },
            ),
          ],
        ),
      );
  }
}
