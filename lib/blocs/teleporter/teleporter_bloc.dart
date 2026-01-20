import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/import_options_model.dart';
import 'package:pi_block/services/export_service.dart';

class TeleporterBloc extends Bloc<TeleporterEvent, TeleporterState> {
  final PiholeRepository piholeRepository;
  late Uint8List pendingBytes;

  TeleporterBloc(this.piholeRepository)
    : super(
        TeleporterState(status: TeleporterStateStatus.initial, message: ""),
      ) {
    on<ExportConfiguration>(_onExportConfiguration);
    on<ToggleImportOption>(_onToggleExportOption);
    on<ImportConfiguration>(_onImportConfiguration);
    on<ImportFileSelected>(_loadFile);
  }

  void _loadFile(
    ImportFileSelected event,
    Emitter<TeleporterState> emit,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        withData: true,
      );

      if (result == null) return;

      final file = result.files.single;

      pendingBytes = file.bytes!;
      emit(
        state.copyWith(
          fileName: file.name,
          actionStatus: TeleporterActionStateStatus.initial,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: TeleporterActionStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void _onImportConfiguration(
    ImportConfiguration event,
    Emitter<TeleporterState> emit,
  ) async {
    emit(state.copyWith(actionStatus: TeleporterActionStateStatus.loading));
    try {
      ImportOptionsModel importOptionsModel = ImportOptionsModel(
        config: state.configuration,
        dhcpLeases: state.dhcpLeases,
        gravity: TeleporterGravityOptions(
          group: state.groups,
          adlist: state.lists,
          adlistByGroup: state.lists,
          domainlist: state.domainsRegexes,
          domainlistByGroup: state.domainsRegexes,
          client: state.clients,
          clientByGroup: state.clients,
        ),
      );
      if (state.fileName.isEmpty) {
        throw Exception("File is not provided");
      }
      await piholeRepository.importConfiguration(
        pendingBytes,
        state.fileName,
        importOptionsModel,
      );

      emit(
        state.copyWith(
          actionStatus: TeleporterActionStateStatus.success,
          message: "Successfully Imported",
          fileName: "",
          clients: false,
          configuration: false,
          dhcpLeases: false,
          domainsRegexes: false,
          groups: false,
          lists: false,
        ),
      );

      // resetting status so that notifications does not fire up with previous state
      emit(
        state.copyWith(
          actionStatus: TeleporterActionStateStatus.initial,
          status: TeleporterStateStatus.initial,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: TeleporterActionStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void _onToggleExportOption(
    ToggleImportOption event,
    Emitter<TeleporterState> emit,
  ) {
    switch (event.key) {
      case 'configuration':
        emit(state.copyWith(configuration: event.value));
        break;
      case 'dhcpLeases':
        emit(state.copyWith(dhcpLeases: event.value));
        break;
      case 'groups':
        emit(state.copyWith(groups: event.value));
        break;
      case 'lists':
        emit(state.copyWith(lists: event.value));
        break;
      case 'domainsRegexes':
        emit(state.copyWith(domainsRegexes: event.value));
        break;
      case 'clients':
        emit(state.copyWith(clients: event.value));
        break;
    }
  }

  void _onExportConfiguration(
    ExportConfiguration event,
    Emitter<TeleporterState> emit,
  ) async {
    emit(state.copyWith(status: TeleporterStateStatus.loading));
    try {
      final response = await piholeRepository.exportConfiguration();
      ExportService exportService = ExportService();
      String fileName = 'pihole-teleporter.zip';

      ExportResult exportResult = await exportService.exportZip(
        response.bodyBytes,
        fileName,
      );

      switch (exportResult) {
        case ExportResult.success:
          emit(
            state.copyWith(
              status: TeleporterStateStatus.success,
              message: 'Successfully downloaded',
            ),
          );
          break;

        case ExportResult.cancelled:
          emit(
            state.copyWith(
              status: TeleporterStateStatus.initial,
              message: 'Export cancelled',
            ),
          );
          break;

        case ExportResult.failed:
          emit(
            state.copyWith(
              status: TeleporterStateStatus.failure,
              error: 'Failed to export configuration',
            ),
          );
          break;
      }

      emit(state.copyWith(status: TeleporterStateStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          status: TeleporterStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}

sealed class TeleporterEvent extends Equatable {
  const TeleporterEvent();

  @override
  List<Object> get props => [];
}

final class ExportConfiguration extends TeleporterEvent {
  const ExportConfiguration();
}

final class ImportConfiguration extends TeleporterEvent {
  const ImportConfiguration();
}

class ToggleImportOption extends TeleporterEvent {
  final String key;
  final bool value;

  const ToggleImportOption(this.key, this.value);

  @override
  List<Object> get props => [key, value];
}

class ImportFileSelected extends TeleporterEvent {
  const ImportFileSelected();

  @override
  List<Object> get props => [];
}

enum TeleporterStateStatus { initial, loading, success, failure, empty }

enum TeleporterActionStateStatus { initial, loading, success, failure }

class TeleporterState extends Equatable {
  final TeleporterStateStatus status;
  final String error;
  final String message;
  final TeleporterActionStateStatus actionStatus;
  final String fileName;

  // Export options
  final bool configuration;
  final bool dhcpLeases;
  final bool groups;
  final bool lists;
  final bool domainsRegexes;
  final bool clients;

  const TeleporterState({
    this.status = TeleporterStateStatus.initial,
    this.actionStatus = TeleporterActionStateStatus.initial,
    this.error = "",
    this.message = "",
    this.configuration = true,
    this.dhcpLeases = true,
    this.groups = true,
    this.lists = true,
    this.domainsRegexes = true,
    this.clients = true,
    this.fileName = "",
  });

  TeleporterState copyWith({
    TeleporterStateStatus? status,
    TeleporterActionStateStatus? actionStatus,
    String? error,
    String? message,
    bool? configuration,
    bool? dhcpLeases,
    bool? groups,
    bool? lists,
    bool? domainsRegexes,
    bool? clients,
    String? fileName,
  }) {
    return TeleporterState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      error: error ?? this.error,
      message: message ?? this.message,
      configuration: configuration ?? this.configuration,
      dhcpLeases: dhcpLeases ?? this.dhcpLeases,
      groups: groups ?? this.groups,
      lists: lists ?? this.lists,
      domainsRegexes: domainsRegexes ?? this.domainsRegexes,
      clients: clients ?? this.clients,
      fileName: fileName ?? this.fileName,
    );
  }

  @override
  List<Object?> get props => [
    status,
    actionStatus,
    error,
    message,
    configuration,
    dhcpLeases,
    groups,
    lists,
    domainsRegexes,
    clients,
    fileName,
  ];
}
