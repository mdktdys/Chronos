import 'package:get_it/get_it.dart';
import 'package:riverpod/riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zameny_flutter/domain/Models/zamenaFileLink_model.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';

final fullZamenasProviderOTA = FutureProvider.family<List<ZamenaFileLink>, (DateTime,DateTime)>(
  (ref, dates ) async {
    return await getZamenaFileLinks(start: dates.$1, end: dates.$2);
  },
);

// final fullZamenasProvider = FutureProvider<List<ZamenaFileLink>>((ref) {
//   List<ZamenaFileLink> links = ref.watch(fullZamenasProviderOTA(Date).future);
//   return links;
// });


Future<List<ZamenaFileLink>> getZamenaFileLinks(
      {required DateTime start, required DateTime end}) async {
    final dat = GetIt.I.get<Data>();

    List<ZamenaFileLink> zamenalinks = [];
    if (dat.zamenaFileLinks.any((element) =>
        element.date.isBefore(end) && element.date.isAfter(start))) {
    }

    final client = GetIt.I.get<SupabaseClient>();

    List<dynamic> data = await client
        .from('ZamenaFileLinks')
        .select('id,link,date,created_at')
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());

    for (var element in data) {
      ZamenaFileLink zamenaLink = ZamenaFileLink.fromMap(element);  
      dat.zamenaFileLinks.add(zamenaLink);
    }
    return zamenalinks;
  }