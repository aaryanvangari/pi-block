part of 'auth_bloc.dart';

enum AuthStateStatus { initial, loading, loggedIn, failure, loggedOut }

class AuthState extends Equatable {
  final String sid;
  final String csrf;
  final String message;
  final int validity;
  final String scheme;
  final String server;
  final int port;
  final int sessionValidUntil;
  final AuthStateStatus status;
  final String error;
  final String errorDescription;
  const AuthState({
    this.sid = "",
    this.csrf = "",
    this.message = "",
    this.validity = 0,
    this.scheme = "",
    this.server = "",
    this.port = 0,
    this.sessionValidUntil = 0,
    this.status = AuthStateStatus.initial,
    this.error = "",
    this.errorDescription = "",
  });

  AuthState copyWith({
    String? sid,
    String? csrf,
    String? message,
    int? validity,
    String? scheme,
    String? server,
    int? port,
    int? sessionValidUntil,
    AuthStateStatus? status,
    String? error,
    String? errorDescription,
  }) {
    return AuthState(
      sid: sid ?? this.sid,
      csrf: csrf ?? this.csrf,
      message: message ?? this.message,
      validity: validity ?? this.validity,
      scheme: scheme ?? this.scheme,
      server: server ?? this.server,
      port: port ?? this.port,
      sessionValidUntil: sessionValidUntil ?? this.sessionValidUntil,
      status: status ?? this.status,
      error: error ?? this.error,
      errorDescription: errorDescription ?? this.errorDescription,
    );
  }

  @override
  List<Object> get props => [
    sid,
    csrf,
    message,
    validity,
    scheme,
    server,
    port,
    sessionValidUntil,
    status,
    error,
    errorDescription,
  ];
}
