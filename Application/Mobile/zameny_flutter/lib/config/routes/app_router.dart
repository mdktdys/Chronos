import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:zameny_flutter/config/bottom_bar_items.dart';
import 'package:zameny_flutter/modules/main_screen.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/widgets/pages_view_widget.dart';

final routerProvider = Provider<GoRouter>((final ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (final context, final state) {
          Map<String, dynamic> params = state.uri.queryParameters;
          final int? typeId = int.tryParse(params['type'] ?? '');
          final int? id = int.tryParse(params['id'] ?? '');
          final String? page =  params['page'];

          final int pageIndex = model.where((final pg) => pg.path == page).firstOrNull?.index ?? 1;

          if (id != null && typeId != null) {
            ref.read(searchItemProvider.notifier).getSearchItem(id: id, type: typeId);
          }

          return MainScreen(page: pageIndex);
        },
        routes: [
          GoRoute(
            path: 'pixel',
            builder: (final context, final state) {
              return const PixelBattleScreen();
            },
          )
        ]
      ),
    ]
  );
});
