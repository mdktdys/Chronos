import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

Future<void> share({
  required final String text,
  required final List<Uint8List> files,
  required final String format
}) async {
  final String mimeType = format == 'png' ? 'image/png' : 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  await Share.shareXFiles(
    files.map((final e) => XFile.fromData(e, name: '$text ${UuidValue.fromByteList(e)}',mimeType: mimeType)).toList(),
    text: text,
  );
}
