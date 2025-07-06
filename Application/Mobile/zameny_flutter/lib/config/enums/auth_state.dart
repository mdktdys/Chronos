import 'package:zameny_flutter/config/enums/auth_status_enum.dart';

class AuthState {
  final AuthStatus status;
  final String? accessToken;
  final String? errorMessage;
  final Map<String, dynamic>? user;

  AuthState({
    this.status = AuthStatus.initial,
    this.accessToken,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    final AuthStatus? status,
    final String? accessToken,
    final String? errorMessage,
    final Map<String, dynamic>? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      accessToken: accessToken ?? this.accessToken,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }
}
