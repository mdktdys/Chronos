import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';

class SettingsCategoryTile extends StatelessWidget {
  final VoidCallback onClicked;
  final String description;
  final String title;
  final String icon;

  const SettingsCategoryTile({
    required this.description,
    required this.onClicked,
    required this.title,
    required this.icon,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onClicked,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          borderRadius: const BorderRadius.all(Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.styles.ubuntuBold14,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: context.styles.ubuntu12,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,),
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    icon,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.inverseSurface, BlendMode.srcIn),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
