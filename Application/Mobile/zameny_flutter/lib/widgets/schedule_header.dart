import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/providers/search_item_provider.dart';
import 'package:zameny_flutter/widgets/frame_less_button.dart';

class ScheduleHeader extends ConsumerWidget {
  const ScheduleHeader({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return SizedBox(
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FrameLessButton(
            child: Image.asset('assets/icon/whale.png'),
            onClicked: () async {
              ref.read(searchItemProvider.notifier).setState(null);
            },
          ),
          Expanded(
            child: Text(
              'Расписание',
              textAlign: TextAlign.center,
              style: context.styles.ubuntuPrimaryBold24,
            ),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                barrierColor: Colors.black.withValues(alpha: 0.3),
                backgroundColor: Theme.of(context).colorScheme.surface,
                context: context,
                builder: (final context) => SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            'Показать логи Talker',
                            style: context.styles.ubuntu,
                          ),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (final context) => TalkerScreen(talker:GetIt.I.get<Talker>()))),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.more_horiz_rounded,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}
