import 'dart:developer';

import 'package:go_router/go_router.dart';

import 'package:zameny_flutter/config/app/app.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (final context, final state) {
        return const ApplicationBase(page: 1);
      },
      routes: [
        GoRoute(
          path: '/timetable',
          builder: (final context, final state) {
            return const ApplicationBase(page: 0);
          },
        ),
        GoRoute(
          path: '/schedule',
          builder: (final context, final state) {

            final Map<String, dynamic> params = state.uri.queryParameters;
            final DateTime? navigationDate = params['date']; 
            final String? typeId = params['type'];
            final String? id = params['id'];


            return const ApplicationBase(page: 1);
          },
        ),
        GoRoute(
          path: '/zamenas',
          builder: (final context, final state) {
            return const ApplicationBase(page: 2);
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (final context, final state) {
            return const ApplicationBase(page: 3);
          },
        ),
      ]
    ),
  ]
);
