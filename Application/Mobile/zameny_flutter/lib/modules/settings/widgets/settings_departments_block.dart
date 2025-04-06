import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zameny_flutter/config/enums/department_forms_enum.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/modules/settings/widgets/settings_category_widget.dart';
import 'package:zameny_flutter/widgets/base_container.dart';

class SettingsDepartmentsBlock extends StatelessWidget {
  const SettingsDepartmentsBlock({super.key});

  @override
  Widget build(final BuildContext context) {
    return SettingsCategory(
      category: 'Заказать справку',
      tiles: [
        BaseContainer(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: DepartmentForms.values.map((final DepartmentForms department) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Bounceable(
                          hitTestBehavior: HitTestBehavior.translucent,
                          onTap: () async =>  await launchUrl(
                            Uri.parse(department.formUrl),
                            mode: LaunchMode.externalApplication
                          ),
                          child: Text(
                            department.title,
                            textAlign: TextAlign.left,
                            // style: context.styles.ubuntuBold16
                          ),
                        ),
                      ),
                      Bounceable(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: department.formUrl));
                        },
                        child: SvgPicture.asset(
                          Images.copy,
                          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.3), BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                  if (department != DepartmentForms.computer)
                    const Divider(
                      indent: 10,
                      endIndent: 10,
                    )
                ],
              );
            }).toList()
          )
        )
      ]
    );
  }
}
