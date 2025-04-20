import 'package:flutter/material.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/widgets/button.dart';

part 'export_schedule_provider.g.dart';

enum ExportScheduleType {
  current(
    'Как тут',
    null,
    Images.export,
  ),
  excel(
    'Excel',
    'Будет отображено расписание без замен',
    Images.excel,
  );

  final String title;
  final String? description;
  final String image;

  const ExportScheduleType(
    this.title,
    this.description,
    this.image,
  );
}

@Riverpod()
ScheduleExport scheduleExport (final Ref ref) {
  return ScheduleExport(ref: ref);
}

class ScheduleExport {
  final Ref ref;

  ScheduleExport({required this.ref});

  Future<void> exportSchedule ({
    required final BuildContext context
  }) async {

    showModalBottomSheet(
      barrierColor: Colors.black.withValues(alpha: 0.3),
      backgroundColor: Theme.of(context).colorScheme.surface,
      context: context,
      builder: (final context) => const ExportScheduleBottomSheet()
    );
  }

  Future<void> export({
    required final ExportScheduleType type,
    required final BuildContext context,
  }) async {
    final SearchItem searchItem = ref.read(searchItemProvider)!;
    if (type == ExportScheduleType.current) {
      await ref.read(scheduleSettingsProvider).export(
        searchItem: searchItem,
      );
    } else if (type == ExportScheduleType.excel) {
      await ref.read(scheduleSettingsProvider).exportExcel(
        theme: Theme.of(context),
        searchItem: searchItem,
      );
    }
    return;
  }
}

class ExportScheduleBottomSheet extends ConsumerStatefulWidget {
  const ExportScheduleBottomSheet({super.key});

  @override
  ConsumerState<ExportScheduleBottomSheet> createState() => _ExportScheduleBottomSheetState();
}

class _ExportScheduleBottomSheetState extends ConsumerState<ExportScheduleBottomSheet> {
  ExportScheduleType selectedType = ExportScheduleType.current;

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Text(
              'Экспорт расписания',
              textAlign: TextAlign.center,
              style: context.styles.ubuntuPrimaryBold20,
            ),
            Row(
              spacing: 8,
              children: List.generate(ExportScheduleType.values.length, (final int index) {
                final ExportScheduleType type = ExportScheduleType.values[index];
                return Expanded(
                  child: Bounceable(
                    onTap: () {
                      selectedType = type;
                      setState(() {
                        
                      });
                    },
                    child: ExportTile(
                      selected: selectedType == type,
                      type: type,
                    ),
                  ),
                );
              }).toList()
            ),
            AnimatedSwitcher(
              duration: Delays.morphDuration,
              child: Text(
                key: ValueKey(selectedType),
                selectedType.description ?? '',
                textAlign: TextAlign.center,
                style: context.styles.ubuntuInverseSurface40014,
              ),
            ),
            Button.primary(
              context: context,
              onClicked: () {
                ref.read(scheduleExportProvider).export(
                  type: selectedType,
                  context: context,
                );
              },
              text: 'Скачать'
            )
          ],
        ),
      ),
    );
  }
}

class ExportTile extends StatelessWidget {
  final bool selected;
  final ExportScheduleType type;

  const ExportTile({
    required this.type,
    required this.selected,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedOpacity(
      opacity: selected ? 1 : 0.6,
      duration: Delays.morphDuration,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.primary)
        ),
        child: Column(
          spacing: 8,
          children: [
            SvgPicture.asset(
              type.image,
              colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
            ),
            Text(
              type.title,
              style: context.styles.ubuntuInverseSurface16,
            )
          ],
        ),
      ),
    );
  }
}
