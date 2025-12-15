import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log(
      '${bloc.runtimeType} Created',
      level: Level.FINER.value,
      name: "AppBlocObserver.onCreate",
    );
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log(
      '${bloc.runtimeType} Changed - $change',
      level: Level.FINER.value,
      name: "AppBlocObserver.onChange",
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log(
      '${bloc.runtimeType} Transitioned - $transition',
      level: Level.FINER.value,
      name: "AppBlocObserver.onTransition",
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log(
      '${bloc.runtimeType} Error - $error',
      level: Level.SEVERE.value,
      name: "AppBlocObserver.onError",
    );
    super.onError(bloc, error, stackTrace);
  }
}
