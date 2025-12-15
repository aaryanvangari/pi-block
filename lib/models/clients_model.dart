import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

/// Root model representing the entire response
class ClientsModel extends Equatable {
  /// List of clients who made queries
  final List<ClientModel> clients;

  /// Total number of queries across all clients
  final int totalQueries;

  /// Number of queries that were blocked
  final int blockedQueries;

  /// Time in seconds it took to process the request
  final double took;

  const ClientsModel({
    required this.clients,
    required this.totalQueries,
    required this.blockedQueries,
    required this.took,
  });

  /// Create a ClientsModel instance from a JSON map
  factory ClientsModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "ClientsModel.fromJson",
    );
    return ClientsModel(
      clients: (json['clients'] as List<dynamic>)
          .map((e) => ClientModel.fromJson(e))
          .toList(),
      totalQueries: json['total_queries'] ?? 0,
      blockedQueries: json['blocked_queries'] ?? 0,
      took: json['took'] ?? 0,
    );
  }

  /// Convert ClientsModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'clients': clients.map((e) => e.toJson()).toList(),
      'total_queries': totalQueries,
      'blocked_queries': blockedQueries,
      'took': took,
    };
  }

  @override
  List<Object> get props => [clients, totalQueries, blockedQueries, took];
}

/// Model representing a client entry
class ClientModel extends Equatable {
  /// Client IP address (IPv4 or IPv6)
  final String ip;

  /// Client hostname, if available
  final String name;

  /// Number of queries made by this client
  final int count;

  const ClientModel({
    required this.ip,
    required this.name,
    required this.count,
  });

  /// Create a ClientModel instance from JSON map
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      ip: json['ip'] ?? "",
      name: json['name'] ?? "",
      count: json['count'] ?? 0,
    );
  }

  /// Convert ClientModel instance to JSON
  Map<String, dynamic> toJson() {
    return {'ip': ip, 'name': name, 'count': count};
  }

  @override
  List<Object> get props => [ip, name, count];
}
