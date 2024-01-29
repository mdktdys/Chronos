import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsVersionBlock extends StatelessWidget {
  const SettingsVersionBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final packageInfo = GetIt.I.get<PackageInfo>();
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Version: ${packageInfo.version} build: ${packageInfo.buildNumber} Github",
            style: const TextStyle(fontFamily: 'Monospace', color: Colors.grey),
            textAlign: TextAlign.start,
          ),
          const Text(
            "carefully made for people ✨",
            style: TextStyle(fontFamily: 'Monospace', color: Colors.grey),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
