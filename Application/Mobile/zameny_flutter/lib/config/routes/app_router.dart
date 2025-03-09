import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:zameny_flutter/config/app/app.dart';
import 'package:zameny_flutter/config/bottom_bar_items.dart';

final routerProvider = Provider<GoRouter>((final ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (final context, final state) {
          Map<String, dynamic> params = state.uri.queryParameters;
          final DateTime? navigationDate = params['date']; 
          final String? typeId = params['type'];
          final String? id = params['id'];
          final String? page =  params['page'];

          final int pageIndex = model.where((final pg) => pg.path == page).firstOrNull?.index ?? 1;

          return ApplicationBase(page: pageIndex);
        },
      ),
    ]
  );
});
