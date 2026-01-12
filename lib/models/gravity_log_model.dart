import 'package:equatable/equatable.dart';

enum GravityLogType { success, info, warning, error, none, streamError }

class GravityLog extends Equatable {
  final GravityLogType type;
  final String message;
  final String? error;

  const GravityLog({
    required this.type,
    required this.message,
    this.error = "",
  });

  @override
  List<Object?> get props => [type, message, error];
}
