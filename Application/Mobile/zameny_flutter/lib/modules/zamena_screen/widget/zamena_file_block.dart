import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_file_link_provider.dart';


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
        return const SizedBox();
      },),
    );
  }
}
