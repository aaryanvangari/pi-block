import 'package:equatable/equatable.dart';

/// Represents a single log entry
class LogModel extends Equatable {
  /// Log line creation time (converted from Unix timestamp with fractions)
  final DateTime timestamp;

  /// Log line content
  final String message;

  /// Log line priority (if available)
  final String? prio;

  const LogModel({required this.timestamp, required this.message, this.prio});

  /// Creates an empty LogModel
  factory LogModel.empty() {
    return LogModel(
      timestamp: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      message: '',
      prio: null,
    );
  }

  /// Returns true if this instance is empty
  bool get isEmpty =>
      timestamp.millisecondsSinceEpoch == 0 && message.isEmpty && prio == null;

  /// Creates a LogModel from JSON
  ///
  /// Handles Unix timestamps in seconds with fractional precision
  /// Example: 1767323309.5316505
  factory LogModel.fromJson(Map<String, dynamic> json) {
    final num rawTimestamp = json['timestamp'] as num? ?? 0;

    return LogModel(
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (rawTimestamp * 1000).round(),
        isUtc: true,
      ),
      message: json['message'] as String? ?? '',
      prio: json['prio'] as String?,
    );
  }

  /// Converts this LogModel to JSON
  ///
  /// Serializes DateTime back to Unix timestamp (seconds with fractions)
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch / 1000,
      'message': message,
      'prio': prio,
    };
  }

  @override
  List<Object?> get props => [timestamp, message, prio];
}
