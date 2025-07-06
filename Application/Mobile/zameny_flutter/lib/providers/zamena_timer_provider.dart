import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final zamenaTimerProvider = FutureProvider.autoDispose<DateTime>((final ref) async {
  final res = await GetIt.I.get<SupabaseClient>().from('checks').select().order('id').limit(1);
  return DateTime.parse(res[0]['updated_at']);
});
