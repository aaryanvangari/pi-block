import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/error/exceptions/api_exception.dart';
import 'package:pi_block/services/user_session_service.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/session_model.dart';
import 'package:pi_block/models/user_session_model.dart';

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

      UserSessionModel userSessionModel = UserSessionModel(
        session: sessionModel.session ?? Session.empty(),
        serverUrl: serverUrl.toString(),
        sessionValidUntil: sessionValidUntil,
      );

      UserSessionService userSessionService = UserSessionService();
      userSessionService.saveSession(userSessionModel);

      emit(
        state.copyWith(
          sid: sessionModel.session!.sid,
          csrf: sessionModel.session!.csrf,
          message: sessionModel.session!.message,
          validity: sessionModel.session!.validity,
          scheme: serverUrl.scheme,
          server: serverUrl.host,
          port: serverUrl.port,
          sessionValidUntil: sessionValidUntil,
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
      bool isLoggedOut = await piholeRepository.logout();
      if (isLoggedOut) {
        UserSessionService userSessionService = UserSessionService();
        await userSessionService.clearSession();

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
      }
    } catch (e) {
      emit(
        state.copyWith(status: AuthStateStatus.failure, error: e.toString()),
      );
    }
  }
}
