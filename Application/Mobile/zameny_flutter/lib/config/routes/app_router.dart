import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:zameny_flutter/config/app/app.dart';
import 'package:zameny_flutter/config/bottom_bar_items.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';

final routerProvider = Provider<GoRouter>((final ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (final context, final state) {
          Map<String, dynamic> params = state.uri.queryParameters;
          // final DateTime? navigationDate = params['date']; 
          final int? typeId = int.tryParse(params['type'] ?? '');
          final int? id = int.tryParse(params['id'] ?? '');
          final String? page =  params['page'];

          final int pageIndex = model.where((final pg) => pg.path == page).firstOrNull?.index ?? 1;

          if (id != null && typeId != null) {
            ref.read(searchItemProvider.notifier).getSearchItem(id: id, type: typeId);
          }

          return ApplicationBase(page: pageIndex);
        },
      ),
    ]
  );
});
