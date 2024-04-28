import 'dart:html' as html;
import 'dart:typed_data';

share({required String text, required List<Uint8List> files}) async {
  final html.Blob blob = html.Blob(files, 'image/png');
  final String url = html.Url.createObjectUrlFromBlob(blob);

  html.AnchorElement(href: url)
    ..setAttribute('download', "$text.png")
    ..click();

  html.Url.revokeObjectUrl(url);
}
