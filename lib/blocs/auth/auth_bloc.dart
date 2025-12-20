import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/components/api_exception.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final PiholeRepository piholeRepository;
  AuthBloc(this.piholeRepository) : super(AuthState()) {
    on<Login>(_login);
    on<Logout>(_logout);
  }

  bool checkSessionValidity() {
    int millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    if (state.sid.isNotEmpty &&
        ((state.sessionValidUntil > 0) &&
            (state.sessionValidUntil - millisecondsSinceEpoch) > 0)) {
      return true;
    }
    return false;
  }

  Future<void> _login(Login event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    try {
      Uri serverUrl = Uri.parse(event.serverUrl);
      SessionModel sessionModel = await piholeRepository.login(
        serverUrl,
        event.apiToken,
      );
      DateTime time = DateTime.now();
      int sessionValidUntil =
          time.millisecondsSinceEpoch + (sessionModel.session!.validity * 1000);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("sid", sessionModel.session!.sid);
      prefs.setString("csrf", sessionModel.session!.csrf);
      prefs.setString("message", sessionModel.session!.message);
      prefs.setInt("validity", sessionModel.session!.validity);
      prefs.setString("scheme", serverUrl.scheme);
      prefs.setString("server", serverUrl.host);
      prefs.setInt("port", serverUrl.port);
      prefs.setInt("sessionValidUntil", sessionValidUntil);

      emit(
        state.copyWith(
          sid: sessionModel.session!.sid,
          csrf: sessionModel.session!.csrf,
          message: sessionModel.session!.message,
          validity: sessionModel.session!.validity,
          scheme: serverUrl.scheme,
          server: serverUrl.host,
          port: serverUrl.port,
          sessionValidUntil:
              time.millisecondsSinceEpoch +
              (sessionModel.session!.validity * 1000),
          status: AuthStateStatus.loggedIn,
          error: "",
        ),
      );
    } on APIException catch (e) {
      emit(
        state.copyWith(
          status: AuthStateStatus.failure,
          error: e.message,
          errorDescription: e.description,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStateStatus.failure,
          error: e.toString(),
          errorDescription: e.toString(),
        ),
      );
    }
  }

  Future<void> _logout(Logout event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    try {
      await piholeRepository.logout();
      final prefs = await SharedPreferences.getInstance();

      prefs.setString("sid", "");
      prefs.setString("csrf", "");
      prefs.setString("message", "");
      prefs.setInt("validity", 0);
      prefs.setString("scheme", "");
      prefs.setString("server", "");
      prefs.setInt("port", 0);
      prefs.setInt("sessionValidUntil", 0);

      emit(
        state.copyWith(
          sid: "",
          csrf: "",
          message: "",
          validity: 0,
          scheme: "",
          server: "",
          port: 0,
          sessionValidUntil: 0,
          status: AuthStateStatus.loggedOut,
          error: "",
          errorDescription: "",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStateStatus.failure, error: e.toString()),
      );
    }
  }
}
