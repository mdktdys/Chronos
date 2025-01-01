import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleScreenDesktop extends ConsumerWidget {
  const ScheduleScreenDesktop({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return const TeacherMonthStats();
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       Container(
  //         height: 100,
  //         width: 1000,
  //         decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)))),
  //         padding: const EdgeInsets.all(8),
  //         child: const Row(
  //           children: [
  //             // Expanded(child: SearchResultHeader()),
  //             // Expanded(child: DateHeader()),
  //             // Expanded(child: SizedBox()),
  //           ],
  //         ),
  //       ),
  //       // Expanded(
  //       //   child: LessonView(
  //       //     scrollController: ScrollController(),
  //       //     refresh: (){},
  //       //   ),
  //       // ),
  //     ],
  //   );
  // }
  }
}

// final monthTeacherStatsProvider = FutureProvider.family<List<dynamic>, >((final ref, ) async {
//   return ;
// });

class TeacherMonthStats extends StatelessWidget {
  const TeacherMonthStats({super.key});

  @override
  Widget build(final BuildContext context) {
    return const Placeholder();
  }
}
