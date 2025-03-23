import 'package:flutter/material.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/config/theme/theme_provider.dart';
import 'package:zameny_flutter/config/theme/themes.dart';
import 'package:zameny_flutter/widgets/theme_tile.dart';

class ThemeSwitchBlock extends ConsumerStatefulWidget {
  const ThemeSwitchBlock({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThemeSwitchBlockState();
}

class _ThemeSwitchBlockState extends ConsumerState<ThemeSwitchBlock> {
  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.colorScheme.brightness == Brightness.dark;

    
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Тема',
            style: context.styles.ubuntuPrimaryBold20,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: SegmentedButtonTheme(
            data: theme.segmentedButtonTheme,
            child: SegmentedButton(
              onSelectionChanged: (final p0) {
                ref.read(lightThemeProvider).setThemeMode(p0.first);
              },
              segments: const [
                ButtonSegment(value: 1, icon: Icon(Icons.dark_mode)),
                ButtonSegment(value: 2, icon: Icon(Icons.light_mode)),
                ButtonSegment(value: 3, icon: Icon(Icons.phone_android)),
              ],
              selected: {
                ref.watch(lightThemeProvider).themeModeIndex,
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 80,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: themes.map((final (FlexScheme, FlexSchemeData) theme) {    
                return Row(
                  children: [
                    ThemeTile(
                      flexScheme: theme.$1,
                      scheme: theme.$2,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 5),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
