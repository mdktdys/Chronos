import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/models/zamenaFileLink_model.dart';

class ZamenaLinksBottomSheet extends StatelessWidget {
  final List<ZamenaFileLink> links;

  const ZamenaLinksBottomSheet({
    required this.links,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: Theme.of(context).colorScheme.primary,),
            borderRadius: const BorderRadius.all(Radius.circular(20),
          ),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (final __, final _) => const Divider(),
          itemCount: links.length,
          itemBuilder: (final context, final index) {
            return GestureDetector(
              onTap: () => launchUrl(Uri.parse(links.toList()[index].link),),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ссылка:',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    Text(
                      links.toList()[index].link,
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      'Время добавления в систему:',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    Text(
                      links.toList()[index].created.toddmmyyhhmm(),
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
