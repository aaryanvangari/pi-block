import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

/// Root model representing the entire response
class DomainsModel extends Equatable {
  /// List of domains
  final List<StatDomainModel> domains;

  /// Total number of queries across all clients
  final int totalQueries;

  /// Number of queries that were blocked
  final int blockedQueries;

  /// Time in seconds it took to process the request
  final double took;

  const DomainsModel({
    required this.domains,
    required this.totalQueries,
    required this.blockedQueries,
    required this.took,
  });

  /// Create a DomainsModel instance from a JSON map
  factory DomainsModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "DomainsModel.fromJson",
    );
    return DomainsModel(
      domains: (json['domains'] as List<dynamic>)
          .map((e) => StatDomainModel.fromJson(e))
          .toList(),
      totalQueries: json['total_queries'] ?? 0,
      blockedQueries: json['blocked_queries'] ?? 0,
      took: json['took'] ?? 0,
    );
  }

  /// Convert DomainsModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'domains': domains.map((e) => e.toJson()).toList(),
      'total_queries': totalQueries,
      'blocked_queries': blockedQueries,
      'took': took,
    };
  }

  DomainsModel copyWith({
    List<StatDomainModel>? domains,
    int? totalQueries,
    int? blockedQueries,
    double? took,
  }) => DomainsModel(
    domains: domains ?? this.domains,
    totalQueries: totalQueries ?? this.totalQueries,
    blockedQueries: blockedQueries ?? this.blockedQueries,
    took: took ?? this.took,
  );

  @override
  List<Object> get props => [domains, totalQueries, blockedQueries, took];
}

/// Model representing a domain entry in stats page
class StatDomainModel extends Equatable {
  /// Requested domain
  final String domain;

  /// Number of times this domain has been requested
  final int count;

  const StatDomainModel({required this.domain, required this.count});

  /// Create a StatDomainModel instance from JSON map
  factory StatDomainModel.fromJson(Map<String, dynamic> json) {
    return StatDomainModel(
      domain: json['domain'] ?? "",
      count: json['count'] ?? 0,
    );
  }

  /// Convert StatDomainModel instance to JSON
  Map<String, dynamic> toJson() {
    return {'domain': domain, 'count': count};
  }

  StatDomainModel copyWith({String? domain, int? count}) => StatDomainModel(
    domain: domain ?? this.domain,
    count: count ?? this.count,
  );

  @override
  List<Object> get props => [domain, count];
}
