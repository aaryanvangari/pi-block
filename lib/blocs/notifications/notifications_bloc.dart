import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/diagnostic_message_model.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final PiholeRepository piholeRepository;

  NotificationsBloc(this.piholeRepository)
    : super(
        NotificationsState(
          status: NotificationsStateStatus.initial,
          messages: [],
        ),
      ) {
    on<LoadNotifications>(_onLoadNotifications);
    on<DeleteNotification>(_deleteNotification);
  }

  /// Initial load
  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(status: NotificationsStateStatus.loading));

    try {
      List<DiagnosticMessageModel> messages = await piholeRepository
          .getDiagnosticMessages();

      emit(
        state.copyWith(
          status: NotificationsStateStatus.success,
          messages: messages,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationsStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void _deleteNotification(
    DeleteNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(itemStatus: NotificationsItemStateStatus.loading));
    try {
      await piholeRepository.deleteDiagnosticMessages(
        event.diagnosticMessageModel.id,
      );
      // ignoring the deleted item
      final updatedMessages = state.messages
          .where((d) => d.id != event.diagnosticMessageModel.id)
          .toList();
      emit(
        state.copyWith(
          messages: updatedMessages,
          itemStatus: NotificationsItemStateStatus.success,
          message: "Successfully Deleted",
        ),
      );

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: NotificationsItemStateStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: NotificationsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

final class LoadNotifications extends NotificationsEvent {
  const LoadNotifications();
}

final class DeleteNotification extends NotificationsEvent {
  final DiagnosticMessageModel diagnosticMessageModel;
  const DeleteNotification(this.diagnosticMessageModel);
}

enum NotificationsStateStatus { initial, loading, success, failure, empty }

enum NotificationsItemStateStatus { initial, loading, success, failure }

class NotificationsState extends Equatable {
  final List<DiagnosticMessageModel> messages;
  final NotificationsStateStatus status;
  final NotificationsItemStateStatus itemStatus;
  final String error;
  final String message;
  const NotificationsState({
    required this.messages,
    this.status = NotificationsStateStatus.initial,
    this.itemStatus = NotificationsItemStateStatus.initial,
    this.error = "",
    this.message = "",
  });

  NotificationsState copyWith({
    List<DiagnosticMessageModel>? messages,
    NotificationsStateStatus? status,
    NotificationsItemStateStatus? itemStatus,
    String? error,
    String? message,
  }) {
    return NotificationsState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      itemStatus: itemStatus ?? this.itemStatus,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [messages, status, itemStatus, error, message];
}
