import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

Future<void> share({required final String text, required final List<Uint8List> files}) async {
  await Share.shareXFiles(
    files.map((final e) => XFile.fromData(e, name: '$text ${UuidValue.fromByteList(e)}',mimeType: 'image/png')).toList(),
    text: text,
  );
}
