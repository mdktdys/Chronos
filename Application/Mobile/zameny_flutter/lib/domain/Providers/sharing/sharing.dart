import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zameny_flutter/domain/Providers/sharing/sharing_stub.dart'
    if (dart.library.js) 'package:zameny_flutter/domain/Providers/sharing/sharing_web.dart'
    if (dart.library.io) 'package:zameny_flutter/domain/Providers/sharing/sharing_mobile.dart';

final sharingProvier = Provider<_Sharing>((ref) {
  return _Sharing(ref);
});

class _Sharing {
  final Ref ref;

  _Sharing(this.ref);

  Future<void> shareFile(
      {required String text, required List<Uint8List> files}) async {
    share(text: text, files: files);
  }
}
