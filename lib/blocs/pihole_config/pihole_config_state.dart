part of 'pihole_config_bloc.dart';

@immutable
sealed class PiholeConfigState {}

final class PiholeConfigInitial extends PiholeConfigState {}

final class PiholeConfigLoading extends PiholeConfigState {}

final class PiholeConfigSuccess extends PiholeConfigState {
  final PiholeConfigModel piholeConfigModel;

  PiholeConfigSuccess({required this.piholeConfigModel});
}

final class PiholeConfigFailure extends PiholeConfigState {
  final String error;

  PiholeConfigFailure(this.error);
}
