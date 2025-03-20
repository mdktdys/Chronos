import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
final bottomSheetsProvider = Provider<BottomSheetsProvider>((final ref) {
  return BottomSheetsProvider(ref);
});

class BottomSheetsProvider {
  Ref ref;
  BuildContext? context;

  BottomSheetsProvider(this.ref);

  void setupContext(final BuildContext context){
    this.context = context;
  }

  Future<void> openSheet(final Widget sheet) async {
    showModalBottomSheet(
      context: context!, builder: (final context) {
      return sheet;
    });
  }
}
