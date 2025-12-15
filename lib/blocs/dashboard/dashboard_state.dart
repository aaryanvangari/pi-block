part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class HostInfoState extends DashboardState {}

final class HostInfoInitial extends HostInfoState {}

final class HostInfoLoading extends HostInfoState {}

final class HostInfoLoaded extends HostInfoState {
  final HostModel hostModel;
  HostInfoLoaded(this.hostModel);
}

final class HostInfoError extends HostInfoState {
  final String errorMessage;
  HostInfoError(this.errorMessage);
}

final class SystemInfoState extends DashboardState {}

final class SystemInfoInitial extends SystemInfoState {}

final class SystemInfoLoading extends SystemInfoState {}

final class SystemInfoLoaded extends SystemInfoState {
  final SystemModel systemModel;
  SystemInfoLoaded(this.systemModel);
}

final class SystemInfoError extends SystemInfoState {
  final String errorMessage;
  SystemInfoError(this.errorMessage);
}

final class VersionInfoState extends DashboardState {}

final class VersionInfoInitial extends VersionInfoState {}

final class VersionInfoLoading extends VersionInfoState {}

final class VersionInfoLoaded extends VersionInfoState {
  final VersionModel versionModel;
  VersionInfoLoaded(this.versionModel);
}

final class VersionInfoError extends VersionInfoState {
  final String errorMessage;
  VersionInfoError(this.errorMessage);
}

final class SummaryInfoState extends DashboardState {}

final class SummaryInfoInitial extends SummaryInfoState {}

final class SummaryInfoLoading extends SummaryInfoState {}

final class SummaryInfoLoaded extends SummaryInfoState {
  final SummaryModel summaryModel;
  SummaryInfoLoaded(this.summaryModel);
}

final class SummaryInfoError extends SummaryInfoState {
  final String errorMessage;
  SummaryInfoError(this.errorMessage);
}
