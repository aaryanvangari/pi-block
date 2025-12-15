import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/diagnostic_message_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final PiholeRepository piholeRepository;
  NotificationsBloc(this.piholeRepository) : super(NotificationsInitial()) {
    on<NotificationsFetched>(_getNotifications);
    on<DeleteNotification>(_deleteNotification);
  }

  void _getNotifications(
    NotificationsFetched event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());
    try {
      final notifications = await piholeRepository.getDiagnosticMessages();
      if (notifications.isEmpty) {
        emit(NotificationsEmpty(diagnosticMessagesList: []));
      } else {
        emit(NotificationsSuccess(diagnosticMessagesList: notifications));
      }
    } catch (e) {
      addError(e);
      emit(NotificationsFailure(e.toString()));
    }
  }

  void _deleteNotification(
    DeleteNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationItemOperationLoading());
    try {
      await piholeRepository.deleteDiagnosticMessages(
        event.diagnosticMessageModel.id,
      );
      emit(NotificationItemOperationSuccess("Successfully Deleted"));
    } catch (e) {
      addError(e);
      emit(NotificationItemOperationFailure(e.toString()));
    }
  }
}
