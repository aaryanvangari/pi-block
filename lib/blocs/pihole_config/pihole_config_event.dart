part of 'pihole_config_bloc.dart';

@immutable
sealed class PiholeConfigEvent {}

final class PiholeConfigFetched extends PiholeConfigEvent {}
