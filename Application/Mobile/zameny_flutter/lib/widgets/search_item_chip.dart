import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';

class SearchItemChip extends ConsumerWidget {
  final String title;
  final VoidCallback? onTap;

  const SearchItemChip({
    required this.title,
    this.onTap,
    super.key
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Material(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Text(
            title,
            style: context.styles.ubuntuInverseSurface40014,
          )
        ),
      ),
    );
  }
}
