part of 'notifications_bloc.dart';

@immutable
sealed class NotificationsEvent {}

final class NotificationsFetched extends NotificationsEvent {}

final class DeleteNotification extends NotificationsEvent {
  final DiagnosticMessageModel diagnosticMessageModel;
  DeleteNotification(this.diagnosticMessageModel);
}
