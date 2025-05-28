import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zameny_flutter/shared/domain/models/group_model.dart';
import 'package:zameny_flutter/new/repository/reposiory.dart';
import 'package:zameny_flutter/secrets.dart';

class SupabaseDataRepository implements DataRepository {
  final SupabaseClient client = SupabaseClient(API_URL, API_ANON_KEY);

  @override
  Future<List<Group>> getGroups() async {
    final response = await client.from('Groups').select();
    return response.map((final group) => Group.fromMap(group)).toList();
  }
}
