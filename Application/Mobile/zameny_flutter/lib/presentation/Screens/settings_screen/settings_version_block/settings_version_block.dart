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
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8,),
          Text(
            "Версия: ${packageInfo.version} билд: ${packageInfo.buildNumber} Github",
            style: const TextStyle(fontFamily: 'Monospace', color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.start,
          ),  
          // const Text(
          //   "сделано для людей ✨",
          //   style: TextStyle(fontFamily: 'Monospace', color: Colors.grey, fontSize: 12),
          //   textAlign: TextAlign.start,
          // ),
        ],
      ),
    );
  }
}
