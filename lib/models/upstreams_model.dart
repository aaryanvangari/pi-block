import 'package:equatable/equatable.dart';

/// Root model representing the full upstream statistics response
class UpstreamsModel extends Equatable {
  /// List of upstream destinations
  final List<Upstream> upstreams;

  /// Number of forwarded queries
  final int forwardedQueries;

  /// Total number of queries
  final int totalQueries;

  /// Time in seconds it took to process the request
  final double took;

  const UpstreamsModel({
    required this.upstreams,
    required this.forwardedQueries,
    required this.totalQueries,
    required this.took,
  });

  /// Create an UpstreamModel instance from JSON
  factory UpstreamsModel.fromJson(Map<String, dynamic> json) {
    return UpstreamsModel(
      upstreams: (json['upstreams'] as List<dynamic>)
          .map((e) => Upstream.fromJson(e))
          .toList(),
      forwardedQueries: json['forwarded_queries'] ?? 0,
      totalQueries: json['total_queries'] ?? 0,
      took: json['took'] ?? 0,
    );
  }

  /// Convert UpstreamsModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'upstreams': upstreams.map((e) => e.toJson()).toList(),
      'forwarded_queries': forwardedQueries,
      'total_queries': totalQueries,
      'took': took,
    };
  }

  /// Creates a modified copy of this object
  UpstreamsModel copyWith({
    List<Upstream>? upstreams,
    int? forwardedQueries,
    int? totalQueries,
    double? took,
  }) {
    return UpstreamsModel(
      upstreams: upstreams ?? this.upstreams,
      forwardedQueries: forwardedQueries ?? this.forwardedQueries,
      totalQueries: totalQueries ?? this.totalQueries,
      took: took ?? this.took,
    );
  }

  @override
  List<Object?> get props => [upstreams, forwardedQueries, totalQueries, took];
}

/// Model representing each upstream destination entry
class Upstream extends Equatable {
  /// Upstream IP address (IPv4/IPv6) or null if not available
  final String ip;

  /// Upstream hostname or null if not available
  final String name;

  /// Destination port (-1 if not applicable)
  final int port;

  /// Number of queries routed to this upstream
  final int count;

  /// Response time statistics for this upstream
  final UpstreamStatistics statistics;

  const Upstream({
    required this.ip,
    required this.name,
    required this.port,
    required this.count,
    required this.statistics,
  });

  /// Create an Upstream instance from JSON
  factory Upstream.fromJson(Map<String, dynamic> json) {
    return Upstream(
      ip: json['ip'] ?? "",
      name: json['name'] ?? "",
      port: json['port'] ?? 0,
      count: json['count'] ?? 0,
      statistics: UpstreamStatistics.fromJson(json['statistics']),
    );
  }

  /// Convert Upstream instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'name': name,
      'port': port,
      'count': count,
      'statistics': statistics.toJson(),
    };
  }

  /// Creates a modified copy of this object
  Upstream copyWith({
    String? ip,
    String? name,
    int? port,
    int? count,
    UpstreamStatistics? statistics,
  }) {
    return Upstream(
      ip: ip ?? this.ip,
      name: name ?? this.name,
      port: port ?? this.port,
      count: count ?? this.count,
      statistics: statistics ?? this.statistics,
    );
  }

  @override
  List<Object?> get props => [ip, name, port, count, statistics];
}

/// Statistics representing upstream response performance
class UpstreamStatistics extends Equatable {
  /// Average response time in seconds (0 if not applicable)
  final double response;

  /// Standard deviation of the response time (0 if not applicable)
  final double variance;

  const UpstreamStatistics({required this.response, required this.variance});

  /// Create an UpstreamStatistics instance from JSON
  factory UpstreamStatistics.fromJson(Map<String, dynamic> json) {
    return UpstreamStatistics(
      response: json['response'].toDouble() ?? 0,
      variance: json['variance'].toDouble() ?? 0,
    );
  }

  /// Convert UpstreamStatistics instance to JSON
  Map<String, dynamic> toJson() {
    return {'response': response, 'variance': variance};
  }

  /// Creates a modified copy of this object
  UpstreamStatistics copyWith({double? response, double? variance}) {
    return UpstreamStatistics(
      response: response ?? this.response,
      variance: variance ?? this.variance,
    );
  }

  @override
  List<Object?> get props => [response, variance];
}
