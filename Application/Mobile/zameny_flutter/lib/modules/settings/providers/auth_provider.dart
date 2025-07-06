import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zameny_flutter/config/enums/auth_state.dart';
import 'package:zameny_flutter/config/enums/auth_status_enum.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((final ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  final Dio _dio = Dio();

  Future<void> startAuth() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final createStateResp = await _dio.post('https://api.uksivt.xyz/api/v1/telegram/create_state');
      final stateToken = createStateResp.data.toString();
      // Запускаем polling в отдельной функции
      log(stateToken);
      final Uri url = Uri.parse('https://t.me/UksivtZameny_bot?start=auth$stateToken');
      launchUrl(url);
      await _pollAuthStatus(stateToken);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> _pollAuthStatus(final String token) async {
    log('start listning');
    const int intervalMs = 2000;
    const int maxAttempts = (60 * 1000) ~/ intervalMs;

    for (int i = 0; i < maxAttempts; i++) {
      try {
        log('check status');
        final response = await _dio.get(
          'https://api.uksivt.xyz/api/v1/telegram/status',
          queryParameters: {'token': token},
        );

        if (response.statusCode == 200 && response.data?['access_token'] != null) {
          final accessToken = response.data['access_token'];
          log('success auth');

          // Получаем пользователя
          final user = await _fetchUser(accessToken);

          state = state.copyWith(
            status: AuthStatus.success,
            accessToken: accessToken,
            user: user,
          );
          return;
        }
      } catch (e) {
        state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
        return;
      }
      await Future.delayed(const Duration(milliseconds: intervalMs));
    }

    state = state.copyWith(status: AuthStatus.timeout);
  }

  Future<Map<String, dynamic>> _fetchUser(final String accessToken) async {
    final response = await _dio.get(
      'https://api.uksivt.xyz/api/v2/users/me',
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch user');
    }
  }
}
