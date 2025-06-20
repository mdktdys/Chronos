import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zameny_flutter/models/zamenaFileLink_model.dart';
import 'package:zameny_flutter/modules/zamena_screen/providers/zamena_provider.dart';
import 'package:zameny_flutter/new/notapi.dart';

part 'zamena_file_link_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<ZamenaFileLink>> fetchZamenaFileLinksByDate(final Ref ref) async {
  final DateTime date = ref.watch(zamenaScreenProvider.select((final value) => value.currentDate));
  return await Api.loadZamenaFileLinksByDate(date: date);
}
