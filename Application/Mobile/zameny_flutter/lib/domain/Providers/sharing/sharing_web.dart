import 'dart:developer';
import 'dart:typed_data';
import 'package:web/web.dart';
import 'dart:convert';

share({required String text, required List<Uint8List> files}) async {
  try {
    files.asMap().forEach((index, bytes) {
      String base64Image = base64Encode(bytes);
      String dataUrl = 'data:image/png;base64,$base64Image';
      HTMLAnchorElement link = document.createElement('a') as HTMLAnchorElement;
      link.href = dataUrl;
      link.download = dataUrl;
      link.setAttribute("download", '$text.png');
      link.click();
    });
  } catch (error) {
    log(error.toString());
  }
}
