import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/logging/app_logger.dart';

class AppBlocObserver extends BlocObserver {
  final _log = AppLogger.get('AppBlocObserver');

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _log.finer(() => 'onCreate: ${bloc.runtimeType} Created');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _log.finer(() => 'onChange: ${bloc.runtimeType} Changed - $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _log.finer(() => 'onTransition: ${bloc.runtimeType} Transitioned - $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _log.finer(() => 'onError: ${bloc.runtimeType} Error - $error');
    super.onError(bloc, error, stackTrace);
  }
}
