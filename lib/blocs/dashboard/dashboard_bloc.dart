import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/host_model.dart';
import 'package:pi_block/models/summary_model.dart';
import 'package:pi_block/models/system_model.dart';
import 'package:pi_block/models/version_model.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final PiholeRepository piholeRepository;
  DashboardBloc(this.piholeRepository) : super(DashboardInitial()) {
    on<LoadHostInfo>(_getHostInfo);
    on<LoadSystemInfo>(_getSystemInfo);
    on<LoadVersionInfo>(_getVersionInfo);
    on<LoadSummaryInfo>(_getSummaryInfo);
  }

  void _getHostInfo(LoadHostInfo event, Emitter<DashboardState> emit) async {
    emit(HostInfoLoading());
    try {
      final hostModel = await piholeRepository.getHostInfo();
      emit(HostInfoLoaded(hostModel));
    } catch (e) {
      emit(HostInfoError(e.toString()));
    }
  }

  void _getSystemInfo(
    LoadSystemInfo event,
    Emitter<DashboardState> emit,
  ) async {
    emit(SystemInfoLoading());
    try {
      final systemModel = await piholeRepository.getSystemInfo();
      emit(SystemInfoLoaded(systemModel));
    } catch (e) {
      emit(SystemInfoError(e.toString()));
    }
  }

  void _getVersionInfo(
    LoadVersionInfo event,
    Emitter<DashboardState> emit,
  ) async {
    emit(VersionInfoLoading());
    try {
      final versionModel = await piholeRepository.getVersion();
      emit(VersionInfoLoaded(versionModel));
    } catch (e) {
      emit(VersionInfoError(e.toString()));
    }
  }

  void _getSummaryInfo(
    LoadSummaryInfo event,
    Emitter<DashboardState> emit,
  ) async {
    emit(SummaryInfoLoading());
    try {
      final summaryModel = await piholeRepository.getSummary();
      emit(SummaryInfoLoaded(summaryModel));
    } catch (e) {
      emit(SummaryInfoError(e.toString()));
    }
  }
}
