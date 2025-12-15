// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

/// Response model for DNS query list API
class QueryListModel extends Equatable {
  /// List of DNS queries
  final List<QueryModel> queries;

  /// Pagination cursor
  final int cursor;

  /// Total number of records
  final int recordsTotal;

  /// Number of filtered records
  final int recordsFiltered;

  /// Draw counter (used by DataTables)
  final int draw;

  /// Time in seconds it took to process the request
  final double took;

  const QueryListModel({
    required this.queries,
    required this.cursor,
    required this.recordsTotal,
    required this.recordsFiltered,
    required this.draw,
    required this.took,
  });

  factory QueryListModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "QueryListModel.fromJson",
    );
    return QueryListModel(
      queries: (json['queries'] as List<dynamic>)
          .map((e) => QueryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      cursor: json["cursor"] ?? 0,
      recordsTotal: json["recordsTotal"] ?? 0,
      recordsFiltered: json["recordsFiltered"] ?? 0,
      draw: json["draw"] ?? 0,
      took: (json["took"] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "queries": queries.map((e) => e.toJson()).toList(),
    "cursor": cursor,
    "recordsTotal": recordsTotal,
    "recordsFiltered": recordsFiltered,
    "draw": draw,
    "took": took,
  };

  /// Returns a copy of this object with updated values
  QueryListModel copyWith({
    List<QueryModel>? queries,
    int? cursor,
    int? recordsTotal,
    int? recordsFiltered,
    int? draw,
    double? took,
  }) => QueryListModel(
    queries: queries ?? this.queries,
    cursor: cursor ?? this.cursor,
    recordsTotal: recordsTotal ?? this.recordsTotal,
    recordsFiltered: recordsFiltered ?? this.recordsFiltered,
    draw: draw ?? this.draw,
    took: took ?? this.took,
  );

  @override
  List<Object?> get props => [
    queries,
    cursor,
    recordsTotal,
    recordsFiltered,
    draw,
    took,
  ];
}

/// DNS reply information
class Reply extends Equatable {
  /// Reply type (e.g. NOERROR, NXDOMAIN)
  final String type;

  /// Response time in seconds
  final double time;

  const Reply({required this.type, required this.time});

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
    type: json['type'] ?? "",
    time: (json['time'] as num?)?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {'type': type, 'time': time};

  Reply copyWith({String? type, double? time}) =>
      Reply(type: type ?? this.type, time: time ?? this.time);

  @override
  List<Object?> get props => [type, time];
}

/// Client that initiated the DNS query
class Client extends Equatable {
  /// Client IP address
  final String ip;

  /// Client hostname (if available)
  final String name;

  const Client({required this.ip, required this.name});

  factory Client.fromJson(Map<String, dynamic> json) =>
      Client(ip: json['ip'] ?? "", name: json['name'] ?? "");

  Map<String, dynamic> toJson() => {'ip': ip, 'name': name};

  Client copyWith({String? ip, String? name}) =>
      Client(ip: ip ?? this.ip, name: name ?? this.name);

  @override
  List<Object?> get props => [ip, name];
}

/// Extended DNS error (EDE) information
class EDE extends Equatable {
  /// EDE error code
  final int code;

  /// Human-readable error description
  final String text;

  const EDE({required this.code, required this.text});

  factory EDE.fromJson(Map<String, dynamic> json) =>
      EDE(code: json['code'] ?? 0, text: json['text'] ?? "");

  Map<String, dynamic> toJson() => {'code': code, 'text': text};

  EDE copyWith({int? code, String? text}) =>
      EDE(code: code ?? this.code, text: text ?? this.text);

  @override
  List<Object?> get props => [code, text];
}

/// Individual DNS query entry
class QueryModel extends Equatable {
  /// Query ID
  final int id;

  /// Query timestamp (seconds since epoch)
  final double time;

  /// DNS record type (A, AAAA, PTR, etc.)
  final String type;

  /// Query status
  final String status;

  /// DNSSEC validation status
  final String dnssec;

  /// Queried domain name
  final String domain;

  /// Upstream server used
  final String upstream;

  /// Reply details
  final Reply reply;

  /// Client that issued the query
  final Client client;

  /// Associated list ID (if blocked)
  final int list_id;

  /// Extended DNS error details
  final EDE ede;

  /// Canonical name (CNAME), if present
  final String cname;

  const QueryModel({
    required this.id,
    required this.time,
    required this.type,
    required this.status,
    required this.dnssec,
    required this.domain,
    required this.upstream,
    required this.reply,
    required this.client,
    required this.list_id,
    required this.ede,
    required this.cname,
  });

  factory QueryModel.fromJson(Map<String, dynamic> json) => QueryModel(
    id: json["id"] ?? 0,
    time: (json["time"] as num?)?.toDouble() ?? 0,
    type: json["type"] ?? "",
    status: json["status"] ?? "",
    dnssec: json["dnssec"] ?? "",
    domain: json["domain"] ?? "",
    upstream: json["upstream"] ?? "",
    reply: Reply.fromJson(json["reply"] ?? {}),
    client: Client.fromJson(json["client"] ?? {}),
    list_id: json["list_id"] ?? 0,
    ede: EDE.fromJson(json["ede"] ?? {}),
    cname: json["cname"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "time": time,
    "type": type,
    "status": status,
    "dnssec": dnssec,
    "domain": domain,
    "upstream": upstream,
    "reply": reply.toJson(),
    "client": client.toJson(),
    "list_id": list_id,
    "ede": ede.toJson(),
    "cname": cname,
  };

  QueryModel copyWith({
    int? id,
    double? time,
    String? type,
    String? status,
    String? dnssec,
    String? domain,
    String? upstream,
    Reply? reply,
    Client? client,
    int? list_id,
    EDE? ede,
    String? cname,
  }) => QueryModel(
    id: id ?? this.id,
    time: time ?? this.time,
    type: type ?? this.type,
    status: status ?? this.status,
    dnssec: dnssec ?? this.dnssec,
    domain: domain ?? this.domain,
    upstream: upstream ?? this.upstream,
    reply: reply ?? this.reply,
    client: client ?? this.client,
    list_id: list_id ?? this.list_id,
    ede: ede ?? this.ede,
    cname: cname ?? this.cname,
  );

  @override
  List<Object?> get props => [
    id,
    time,
    type,
    status,
    dnssec,
    domain,
    upstream,
    reply,
    client,
    list_id,
    ede,
    cname,
  ];
}
