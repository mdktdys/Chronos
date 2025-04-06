import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:web/web.dart';

Future<void> share({required final String text, required final List<Uint8List> files}) async {
  try {
    files.asMap().forEach((final index, final bytes) {
      final String base64Image = base64Encode(bytes);
      final String dataUrl = 'data:image/png;base64,$base64Image';
      final HTMLAnchorElement link = document.createElement('a') as HTMLAnchorElement;
      link.href = dataUrl;
      link.download = dataUrl;
      link.setAttribute('download', '$text.png');
      link.click();
    });
  } catch (error) {
    GetIt.I.get<Talker>().critical(error.toString());
  }
}
