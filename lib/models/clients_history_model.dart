import 'package:equatable/equatable.dart';

/// Root response containing client statistics and historical data
class ClientHistoryModel extends Equatable {
  /// Map of client identifiers to their aggregated data
  final Map<String, ClientInfo> clients;

  /// Historical per-client query data
  final List<ClientHistoryEntry> history;

  /// Time in seconds it took to process the request
  final double took;

  const ClientHistoryModel({
    required this.clients,
    required this.history,
    required this.took,
  });

  /// Creates a [ClientHistoryModel] from JSON
  factory ClientHistoryModel.fromJson(Map<String, dynamic> json) {
    return ClientHistoryModel(
      clients: (json['clients'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(key, ClientInfo.fromJson(value as Map<String, dynamic>)),
      ),
      history: (json['history'] as List<dynamic>)
          .map((e) => ClientHistoryEntry.fromJson(e))
          .toList(),
      took: (json['took'] as num).toDouble(),
    );
  }

  /// Converts this object to JSON
  Map<String, dynamic> toJson() => {
    'clients': clients.map((k, v) => MapEntry(k, v.toJson())),
    'history': history.map((e) => e.toJson()).toList(),
    'took': took,
  };

  /// Returns a copy of this object with updated fields
  ClientHistoryModel copyWith({
    Map<String, ClientInfo>? clients,
    List<ClientHistoryEntry>? history,
    double? took,
  }) => ClientHistoryModel(
    clients: clients ?? this.clients,
    history: history ?? this.history,
    took: took ?? this.took,
  );

  @override
  List<Object?> get props => [clients, history, took];
}

/// Aggregated query data for a single client
class ClientInfo extends Equatable {
  /// Client name (may be null)
  final String name;

  /// Total number of queries made by this client
  final int total;

  const ClientInfo({required this.name, required this.total});

  /// Creates a [ClientInfo] from JSON
  factory ClientInfo.fromJson(Map<String, dynamic> json) =>
      ClientInfo(name: json['name'] ?? "", total: json['total']);

  /// Converts this object to JSON
  Map<String, dynamic> toJson() => {'name': name, 'total': total};

  /// Returns a copy of this object with updated fields
  ClientInfo copyWith({String? name, int? total}) =>
      ClientInfo(name: name ?? this.name, total: total ?? this.total);

  @override
  List<Object?> get props => [name, total];
}

/// Historical entry containing per-client query counts
class ClientHistoryEntry extends Equatable {
  /// Timestamp of this entry
  /// (converted from Unix timestamp in seconds)
  final DateTime timestamp;

  /// Map of client identifiers to number of queries at this timestamp
  final Map<String, int> data;

  const ClientHistoryEntry({required this.timestamp, required this.data});

  /// Creates a [ClientHistoryEntry] from JSON
  factory ClientHistoryEntry.fromJson(Map<String, dynamic> json) =>
      ClientHistoryEntry(
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          (json['timestamp'] as num).toInt() * 1000,
        ),
        data: (json['data'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, value as int),
        ),
      );

  /// Converts this object to JSON
  /// Timestamp is serialized as Unix timestamp in seconds
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.millisecondsSinceEpoch ~/ 1000,
    'data': data,
  };

  /// Returns a copy of this object with updated fields
  ClientHistoryEntry copyWith({DateTime? timestamp, Map<String, int>? data}) =>
      ClientHistoryEntry(
        timestamp: timestamp ?? this.timestamp,
        data: data ?? this.data,
      );

  @override
  List<Object?> get props => [timestamp, data];
}
