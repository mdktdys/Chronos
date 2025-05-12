import 'package:dio/dio.dart';

import 'package:zameny_flutter/models/group_model.dart';
import 'package:zameny_flutter/new/repository/reposiory.dart';

class FastAPIDataRepository implements DataRepository {
  final String url = 'https://api.uksivt.xyz/api/v1';
  final Dio dio = Dio();

  @override
  Future<List<Group>> getGroups() async {
    final Response response = await dio.get('$url/groups');
    return (response.data as List).map((final item) => Group.fromMap(item as Map<String, dynamic>)).toList();
  }
}
