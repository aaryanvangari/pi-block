part of 'notifications_bloc.dart';

@immutable
sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsLoading extends NotificationsState {}

final class NotificationsSuccess extends NotificationsState {
  final List<DiagnosticMessageModel> diagnosticMessagesList;

  NotificationsSuccess({required this.diagnosticMessagesList});
}

final class NotificationsFailure extends NotificationsState {
  final String error;

  NotificationsFailure(this.error);
}

final class NotificationsEmpty extends NotificationsState {
  final List<DiagnosticMessageModel> diagnosticMessagesList;

  NotificationsEmpty({required this.diagnosticMessagesList});
}

final class NotificationItemOperationLoading extends NotificationsState {}

final class NotificationItemOperationSuccess extends NotificationsState {
  final String message;

  NotificationItemOperationSuccess(this.message);
}

final class NotificationItemOperationFailure extends NotificationsState {
  final String errorMessage;

  NotificationItemOperationFailure(this.errorMessage);
}
