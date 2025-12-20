part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class Login extends AuthEvent {
  const Login({required this.serverUrl, required this.apiToken});

  final String serverUrl;
  final String apiToken;

  @override
  List<Object> get props => [serverUrl, apiToken];
}

final class Logout extends AuthEvent {
  const Logout();

  @override
  List<Object> get props => [];
}
