import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

share({required String text, required List<Uint8List> files}) async {
  final result = await Share.shareXFiles(
      files
          .map((e) => XFile.fromData(e, name: '$text ${UuidValue.fromByteList(e)}',mimeType: 'image/png'))
          .toList(),
      text: text,);

  if (result.status == ShareResultStatus.success) {
  }
}
