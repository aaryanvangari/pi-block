part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadHostInfo extends DashboardEvent {
  const LoadHostInfo();
}

class LoadSystemInfo extends DashboardEvent {
  const LoadSystemInfo();
}

class LoadVersionInfo extends DashboardEvent {
  const LoadVersionInfo();
}

class LoadSummaryInfo extends DashboardEvent {
  const LoadSummaryInfo();
}
