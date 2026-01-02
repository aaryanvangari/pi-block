import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';

/// Root model representing the entire response
class ClientsStatsModel extends Equatable {
  /// List of clients who made queries
  final List<ClientStatsModel> clients;

  /// Total number of queries across all clients
  final int totalQueries;

  /// Number of queries that were blocked
  final int blockedQueries;

  /// Time in seconds it took to process the request
  final double took;

  const ClientsStatsModel({
    required this.clients,
    required this.totalQueries,
    required this.blockedQueries,
    required this.took,
  });

  /// Create a ClientsStatsModel instance from a JSON map
  factory ClientsStatsModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(ClientsStatsModel, json);
    return ClientsStatsModel(
      clients: (json['clients'] as List<dynamic>)
          .map((e) => ClientStatsModel.fromJson(e))
          .toList(),
      totalQueries: json['total_queries'] ?? 0,
      blockedQueries: json['blocked_queries'] ?? 0,
      took: json['took'] ?? 0,
    );
  }

  /// Convert ClientsStatsModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'clients': clients.map((e) => e.toJson()).toList(),
      'total_queries': totalQueries,
      'blocked_queries': blockedQueries,
      'took': took,
    };
  }

  ClientsStatsModel copyWith({
    List<ClientStatsModel>? clients,
    int? totalQueries,
    int? blockedQueries,
    double? took,
  }) => ClientsStatsModel(
    clients: clients ?? this.clients,
    totalQueries: totalQueries ?? this.totalQueries,
    blockedQueries: blockedQueries ?? this.blockedQueries,
    took: took ?? this.took,
  );

  @override
  List<Object> get props => [clients, totalQueries, blockedQueries, took];
}

/// Model representing a client entry
class ClientStatsModel extends Equatable {
  /// Client IP address (IPv4 or IPv6)
  final String ip;

  /// Client hostname, if available
  final String name;

  /// Number of queries made by this client
  final int count;

  const ClientStatsModel({
    required this.ip,
    required this.name,
    required this.count,
  });

  /// Create a ClientStatsModel instance from JSON map
  factory ClientStatsModel.fromJson(Map<String, dynamic> json) {
    return ClientStatsModel(
      ip: json['ip'] ?? "",
      name: json['name'] ?? "",
      count: json['count'] ?? 0,
    );
  }

  /// Convert ClientStatsModel instance to JSON
  Map<String, dynamic> toJson() {
    return {'ip': ip, 'name': name, 'count': count};
  }

  ClientStatsModel copyWith({String? ip, String? name, int? count}) =>
      ClientStatsModel(
        ip: ip ?? this.ip,
        name: name ?? this.name,
        count: count ?? this.count,
      );

  @override
  List<Object> get props => [ip, name, count];
}
