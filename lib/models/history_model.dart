import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';

/// Root response containing DNS query history and request duration
class HistoryModel extends Equatable {
  /// Historical query statistics entries
  final List<HistoryEntry> history;

  /// Time in seconds it took to process the request
  final double took;

  const HistoryModel({required this.history, required this.took});

  /// Creates a [HistoryModel] from JSON
  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(HistoryModel, json);
    return HistoryModel(
      history: (json['history'] as List<dynamic>)
          .map((e) => HistoryEntry.fromJson(e))
          .toList(),
      took: (json['took'] as num).toDouble(),
    );
  }

  /// Converts this object to JSON
  Map<String, dynamic> toJson() => {
    'history': history.map((e) => e.toJson()).toList(),
    'took': took,
  };

  /// Returns a copy of this object with updated fields
  HistoryModel copyWith({List<HistoryEntry>? history, double? took}) =>
      HistoryModel(history: history ?? this.history, took: took ?? this.took);

  @override
  List<Object?> get props => [history, took];
}

/// Single historical data point for DNS query statistics
class HistoryEntry extends Equatable {
  /// Timestamp of this entry as a DateTime
  /// (converted from Unix timestamp in seconds)
  final DateTime timestamp;

  /// Total number of DNS queries
  final int total;

  /// Number of queries served from cache
  final int cached;

  /// Number of queries that were blocked
  final int blocked;

  /// Number of queries forwarded to upstream servers
  final int forwarded;

  const HistoryEntry({
    required this.timestamp,
    required this.total,
    required this.cached,
    required this.blocked,
    required this.forwarded,
  });

  /// Creates a [HistoryEntry] from JSON
  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
    timestamp: DateTime.fromMillisecondsSinceEpoch(
      (json['timestamp'] as num).toInt() * 1000,
    ),
    total: json['total'] ?? 0,
    cached: json['cached'] ?? 0,
    blocked: json['blocked'] ?? 0,
    forwarded: json['forwarded'] ?? 0,
  );

  /// Converts this object to JSON
  /// Timestamp is serialized as Unix timestamp in seconds
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.millisecondsSinceEpoch ~/ 1000,
    'total': total,
    'cached': cached,
    'blocked': blocked,
    'forwarded': forwarded,
  };

  /// Returns a copy of this object with updated fields
  HistoryEntry copyWith({
    DateTime? timestamp,
    int? total,
    int? cached,
    int? blocked,
    int? forwarded,
  }) => HistoryEntry(
    timestamp: timestamp ?? this.timestamp,
    total: total ?? this.total,
    cached: cached ?? this.cached,
    blocked: blocked ?? this.blocked,
    forwarded: forwarded ?? this.forwarded,
  );

  @override
  List<Object?> get props => [timestamp, total, cached, blocked, forwarded];
}
