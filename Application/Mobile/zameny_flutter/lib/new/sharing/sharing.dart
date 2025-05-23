import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/new/sharing/sharing_stub.dart'
    if (dart.library.js_interop) 'package:zameny_flutter/new/sharing/sharing_web.dart'
    if (dart.library.io) 'package:zameny_flutter/new/sharing/sharing_mobile.dart';

final sharingProvier = Provider<_Sharing>((final ref) {
  return _Sharing(ref);
});

class _Sharing {
  final Ref ref;

  _Sharing(this.ref);

  Future<void> shareFile({
    required final String text,
    required final List<Uint8List> files,
    required final String format,
  }) async {
    share(
      text: text,
      files: files,
      format: format
    );
  }
}
