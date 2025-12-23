// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

/// ==================== SUMMARY ====================
class SummaryModel extends Equatable {
  /// Query statistics
  final Queries queries;

  /// Client statistics
  final Clients clients;

  /// Gravity (blocklist) information
  final Gravity gravity;

  /// Time in seconds it took to process the request
  final double took;

  const SummaryModel({
    required this.queries,
    required this.clients,
    required this.gravity,
    required this.took,
  });

  factory SummaryModel.empty() => SummaryModel(
    queries: Queries.empty(),
    clients: Clients.empty(),
    gravity: Gravity.empty(),
    took: 0,
  );

  factory SummaryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return SummaryModel.empty();
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "SummaryModel.fromJson",
    );
    return SummaryModel(
      queries: Queries.fromJson(json['queries']),
      clients: Clients.fromJson(json['clients']),
      gravity: Gravity.fromJson(json['gravity']),
      took: (json['took'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "queries": queries.toJson(),
    "clients": clients.toJson(),
    "gravity": gravity.toJson(),
    "took": took,
  };

  SummaryModel copyWith({
    Queries? queries,
    Clients? clients,
    Gravity? gravity,
    double? took,
  }) => SummaryModel(
    queries: queries ?? this.queries,
    clients: clients ?? this.clients,
    gravity: gravity ?? this.gravity,
    took: took ?? this.took,
  );

  @override
  List<Object?> get props => [queries, clients, gravity, took];
}

/// -------------------- Queries --------------------
class Queries extends Equatable {
  final int total;
  final int blocked;
  final double percentBlocked;
  final int uniqueDomains;
  final int forwarded;
  final int cached;
  final double frequency;
  final QueryTypes types;
  final QueryStatus status;

  const Queries({
    required this.total,
    required this.blocked,
    required this.percentBlocked,
    required this.uniqueDomains,
    required this.forwarded,
    required this.cached,
    required this.frequency,
    required this.types,
    required this.status,
  });

  factory Queries.empty() => Queries(
    total: 0,
    blocked: 0,
    percentBlocked: 0,
    uniqueDomains: 0,
    forwarded: 0,
    cached: 0,
    frequency: 0,
    types: QueryTypes.empty(),
    status: QueryStatus.empty(),
  );

  factory Queries.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return Queries.empty();

    return Queries(
      total: json['total'] ?? 0,
      blocked: json['blocked'] ?? 0,
      percentBlocked: (json['percent_blocked'] as num?)?.toDouble() ?? 0,
      uniqueDomains: json['unique_domains'] ?? 0,
      forwarded: json['forwarded'] ?? 0,
      cached: json['cached'] ?? 0,
      frequency: (json['frequency'] as num?)?.toDouble() ?? 0,
      types: QueryTypes.fromJson(json['types']),
      status: QueryStatus.fromJson(json['status']),
    );
  }

  Map<String, dynamic> toJson() => {
    "total": total,
    "blocked": blocked,
    "percent_blocked": percentBlocked,
    "unique_domains": uniqueDomains,
    "forwarded": forwarded,
    "cached": cached,
    "frequency": frequency,
    "types": types.toJson(),
    "status": status.toJson(),
  };

  Queries copyWith({
    int? total,
    int? blocked,
    double? percentBlocked,
    int? uniqueDomains,
    int? forwarded,
    int? cached,
    double? frequency,
    QueryTypes? types,
    QueryStatus? status,
  }) => Queries(
    total: total ?? this.total,
    blocked: blocked ?? this.blocked,
    percentBlocked: percentBlocked ?? this.percentBlocked,
    uniqueDomains: uniqueDomains ?? this.uniqueDomains,
    forwarded: forwarded ?? this.forwarded,
    cached: cached ?? this.cached,
    frequency: frequency ?? this.frequency,
    types: types ?? this.types,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [
    total,
    blocked,
    percentBlocked,
    uniqueDomains,
    forwarded,
    cached,
    frequency,
    types,
    status,
  ];
}

class StatsQueryTypes extends Equatable {
  final QueryTypes types;
  final double took;

  const StatsQueryTypes({required this.types, required this.took});

  factory StatsQueryTypes.fromJson(Map<String, dynamic> json) {
    return StatsQueryTypes(
      types: QueryTypes.fromJson(json["types"]),
      took: json["took"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {"types": types, "took": took};

  StatsQueryTypes copyWith({QueryTypes? types, double? took}) =>
      StatsQueryTypes(types: types ?? this.types, took: took ?? this.took);

  @override
  List<Object?> get props => [types, took];
}

/// -------------------- Query Types --------------------
class QueryTypes extends Equatable {
  final int A;
  final int AAAA;
  final int ANY;
  final int SRV;
  final int SOA;
  final int PTR;
  final int TXT;
  final int NAPTR;
  final int MX;
  final int DS;
  final int RRSIG;
  final int DNSKEY;
  final int NS;
  final int SVCB;
  final int HTTPS;
  final int OTHER;

  const QueryTypes({
    required this.A,
    required this.AAAA,
    required this.ANY,
    required this.SRV,
    required this.SOA,
    required this.PTR,
    required this.TXT,
    required this.NAPTR,
    required this.MX,
    required this.DS,
    required this.RRSIG,
    required this.DNSKEY,
    required this.NS,
    required this.SVCB,
    required this.HTTPS,
    required this.OTHER,
  });

  factory QueryTypes.empty() => const QueryTypes(
    A: 0,
    AAAA: 0,
    ANY: 0,
    SRV: 0,
    SOA: 0,
    PTR: 0,
    TXT: 0,
    NAPTR: 0,
    MX: 0,
    DS: 0,
    RRSIG: 0,
    DNSKEY: 0,
    NS: 0,
    SVCB: 0,
    HTTPS: 0,
    OTHER: 0,
  );

  factory QueryTypes.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return QueryTypes.empty();

    return QueryTypes(
      A: json['A'] ?? 0,
      AAAA: json['AAAA'] ?? 0,
      ANY: json['ANY'] ?? 0,
      SRV: json['SRV'] ?? 0,
      SOA: json['SOA'] ?? 0,
      PTR: json['PTR'] ?? 0,
      TXT: json['TXT'] ?? 0,
      NAPTR: json['NAPTR'] ?? 0,
      MX: json['MX'] ?? 0,
      DS: json['DS'] ?? 0,
      RRSIG: json['RRSIG'] ?? 0,
      DNSKEY: json['DNSKEY'] ?? 0,
      NS: json['NS'] ?? 0,
      SVCB: json['SVCB'] ?? 0,
      HTTPS: json['HTTPS'] ?? 0,
      OTHER: json['OTHER'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "A": A,
    "AAAA": AAAA,
    "ANY": ANY,
    "SRV": SRV,
    "SOA": SOA,
    "PTR": PTR,
    "TXT": TXT,
    "NAPTR": NAPTR,
    "MX": MX,
    "DS": DS,
    "RRSIG": RRSIG,
    "DNSKEY": DNSKEY,
    "NS": NS,
    "SVCB": SVCB,
    "HTTPS": HTTPS,
    "OTHER": OTHER,
  };

  QueryTypes copyWith({
    int? A,
    int? AAAA,
    int? ANY,
    int? SRV,
    int? SOA,
    int? PTR,
    int? TXT,
    int? NAPTR,
    int? MX,
    int? DS,
    int? RRSIG,
    int? DNSKEY,
    int? NS,
    int? SVCB,
    int? HTTPS,
    int? OTHER,
  }) => QueryTypes(
    A: A ?? this.A,
    AAAA: AAAA ?? this.AAAA,
    ANY: ANY ?? this.ANY,
    SRV: SRV ?? this.SRV,
    SOA: SOA ?? this.SOA,
    PTR: PTR ?? this.PTR,
    TXT: TXT ?? this.TXT,
    NAPTR: NAPTR ?? this.NAPTR,
    MX: MX ?? this.MX,
    DS: DS ?? this.DS,
    RRSIG: RRSIG ?? this.RRSIG,
    DNSKEY: DNSKEY ?? this.DNSKEY,
    NS: NS ?? this.NS,
    SVCB: SVCB ?? this.SVCB,
    HTTPS: HTTPS ?? this.HTTPS,
    OTHER: OTHER ?? this.OTHER,
  );

  @override
  List<Object?> get props => [
    A,
    AAAA,
    ANY,
    SRV,
    SOA,
    PTR,
    TXT,
    NAPTR,
    MX,
    DS,
    RRSIG,
    DNSKEY,
    NS,
    SVCB,
    HTTPS,
    OTHER,
  ];
}

/// -------------------- Query Status --------------------
class QueryStatus extends Equatable {
  final int UNKNOWN;
  final int GRAVITY;
  final int FORWARDED;
  final int CACHE;
  final int REGEX;
  final int DENYLIST;
  final int EXTERNAL_BLOCKED_IP;
  final int EXTERNAL_BLOCKED_NULL;
  final int EXTERNAL_BLOCKED_NXRA;
  final int GRAVITY_CNAME;
  final int REGEX_CNAME;
  final int DENYLIST_CNAME;
  final int RETRIED;
  final int RETRIED_DNSSEC;
  final int IN_PROGRESS;
  final int DBBUSY;
  final int SPECIAL_DOMAIN;
  final int CACHE_STALE;
  final int EXTERNAL_BLOCKED_EDE15;

  const QueryStatus({
    required this.UNKNOWN,
    required this.GRAVITY,
    required this.FORWARDED,
    required this.CACHE,
    required this.REGEX,
    required this.DENYLIST,
    required this.EXTERNAL_BLOCKED_IP,
    required this.EXTERNAL_BLOCKED_NULL,
    required this.EXTERNAL_BLOCKED_NXRA,
    required this.GRAVITY_CNAME,
    required this.REGEX_CNAME,
    required this.DENYLIST_CNAME,
    required this.RETRIED,
    required this.RETRIED_DNSSEC,
    required this.IN_PROGRESS,
    required this.DBBUSY,
    required this.SPECIAL_DOMAIN,
    required this.CACHE_STALE,
    required this.EXTERNAL_BLOCKED_EDE15,
  });

  factory QueryStatus.empty() => const QueryStatus(
    UNKNOWN: 0,
    GRAVITY: 0,
    FORWARDED: 0,
    CACHE: 0,
    REGEX: 0,
    DENYLIST: 0,
    EXTERNAL_BLOCKED_IP: 0,
    EXTERNAL_BLOCKED_NULL: 0,
    EXTERNAL_BLOCKED_NXRA: 0,
    GRAVITY_CNAME: 0,
    REGEX_CNAME: 0,
    DENYLIST_CNAME: 0,
    RETRIED: 0,
    RETRIED_DNSSEC: 0,
    IN_PROGRESS: 0,
    DBBUSY: 0,
    SPECIAL_DOMAIN: 0,
    CACHE_STALE: 0,
    EXTERNAL_BLOCKED_EDE15: 0,
  );

  factory QueryStatus.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return QueryStatus.empty();

    return QueryStatus(
      UNKNOWN: json['UNKNOWN'] ?? 0,
      GRAVITY: json['GRAVITY'] ?? 0,
      FORWARDED: json['FORWARDED'] ?? 0,
      CACHE: json['CACHE'] ?? 0,
      REGEX: json['REGEX'] ?? 0,
      DENYLIST: json['DENYLIST'] ?? 0,
      EXTERNAL_BLOCKED_IP: json['EXTERNAL_BLOCKED_IP'] ?? 0,
      EXTERNAL_BLOCKED_NULL: json['EXTERNAL_BLOCKED_NULL'] ?? 0,
      EXTERNAL_BLOCKED_NXRA: json['EXTERNAL_BLOCKED_NXRA'] ?? 0,
      GRAVITY_CNAME: json['GRAVITY_CNAME'] ?? 0,
      REGEX_CNAME: json['REGEX_CNAME'] ?? 0,
      DENYLIST_CNAME: json['DENYLIST_CNAME'] ?? 0,
      RETRIED: json['RETRIED'] ?? 0,
      RETRIED_DNSSEC: json['RETRIED_DNSSEC'] ?? 0,
      IN_PROGRESS: json['IN_PROGRESS'] ?? 0,
      DBBUSY: json['DBBUSY'] ?? 0,
      SPECIAL_DOMAIN: json['SPECIAL_DOMAIN'] ?? 0,
      CACHE_STALE: json['CACHE_STALE'] ?? 0,
      EXTERNAL_BLOCKED_EDE15: json['EXTERNAL_BLOCKED_EDE15'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "UNKNOWN": UNKNOWN,
    "GRAVITY": GRAVITY,
    "FORWARDED": FORWARDED,
    "CACHE": CACHE,
    "REGEX": REGEX,
    "DENYLIST": DENYLIST,
    "EXTERNAL_BLOCKED_IP": EXTERNAL_BLOCKED_IP,
    "EXTERNAL_BLOCKED_NULL": EXTERNAL_BLOCKED_NULL,
    "EXTERNAL_BLOCKED_NXRA": EXTERNAL_BLOCKED_NXRA,
    "GRAVITY_CNAME": GRAVITY_CNAME,
    "REGEX_CNAME": REGEX_CNAME,
    "DENYLIST_CNAME": DENYLIST_CNAME,
    "RETRIED": RETRIED,
    "RETRIED_DNSSEC": RETRIED_DNSSEC,
    "IN_PROGRESS": IN_PROGRESS,
    "DBBUSY": DBBUSY,
    "SPECIAL_DOMAIN": SPECIAL_DOMAIN,
    "CACHE_STALE": CACHE_STALE,
    "EXTERNAL_BLOCKED_EDE15": EXTERNAL_BLOCKED_EDE15,
  };

  QueryStatus copyWith({
    int? UNKNOWN,
    int? GRAVITY,
    int? FORWARDED,
    int? CACHE,
    int? REGEX,
    int? DENYLIST,
    int? EXTERNAL_BLOCKED_IP,
    int? EXTERNAL_BLOCKED_NULL,
    int? EXTERNAL_BLOCKED_NXRA,
    int? GRAVITY_CNAME,
    int? REGEX_CNAME,
    int? DENYLIST_CNAME,
    int? RETRIED,
    int? RETRIED_DNSSEC,
    int? IN_PROGRESS,
    int? DBBUSY,
    int? SPECIAL_DOMAIN,
    int? CACHE_STALE,
    int? EXTERNAL_BLOCKED_EDE15,
  }) => QueryStatus(
    UNKNOWN: UNKNOWN ?? this.UNKNOWN,
    GRAVITY: GRAVITY ?? this.GRAVITY,
    FORWARDED: FORWARDED ?? this.FORWARDED,
    CACHE: CACHE ?? this.CACHE,
    REGEX: REGEX ?? this.REGEX,
    DENYLIST: DENYLIST ?? this.DENYLIST,
    EXTERNAL_BLOCKED_IP: EXTERNAL_BLOCKED_IP ?? this.EXTERNAL_BLOCKED_IP,
    EXTERNAL_BLOCKED_NULL: EXTERNAL_BLOCKED_NULL ?? this.EXTERNAL_BLOCKED_NULL,
    EXTERNAL_BLOCKED_NXRA: EXTERNAL_BLOCKED_NXRA ?? this.EXTERNAL_BLOCKED_NXRA,
    GRAVITY_CNAME: GRAVITY_CNAME ?? this.GRAVITY_CNAME,
    REGEX_CNAME: REGEX_CNAME ?? this.REGEX_CNAME,
    DENYLIST_CNAME: DENYLIST_CNAME ?? this.DENYLIST_CNAME,
    RETRIED: RETRIED ?? this.RETRIED,
    RETRIED_DNSSEC: RETRIED_DNSSEC ?? this.RETRIED_DNSSEC,
    IN_PROGRESS: IN_PROGRESS ?? this.IN_PROGRESS,
    DBBUSY: DBBUSY ?? this.DBBUSY,
    SPECIAL_DOMAIN: SPECIAL_DOMAIN ?? this.SPECIAL_DOMAIN,
    CACHE_STALE: CACHE_STALE ?? this.CACHE_STALE,
    EXTERNAL_BLOCKED_EDE15:
        EXTERNAL_BLOCKED_EDE15 ?? this.EXTERNAL_BLOCKED_EDE15,
  );

  @override
  List<Object?> get props => [
    UNKNOWN,
    GRAVITY,
    FORWARDED,
    CACHE,
    REGEX,
    DENYLIST,
    EXTERNAL_BLOCKED_IP,
    EXTERNAL_BLOCKED_NULL,
    EXTERNAL_BLOCKED_NXRA,
    GRAVITY_CNAME,
    REGEX_CNAME,
    DENYLIST_CNAME,
    RETRIED,
    RETRIED_DNSSEC,
    IN_PROGRESS,
    DBBUSY,
    SPECIAL_DOMAIN,
    CACHE_STALE,
    EXTERNAL_BLOCKED_EDE15,
  ];
}

/// -------------------- Clients --------------------
class Clients extends Equatable {
  final int active;
  final int total;

  const Clients({required this.active, required this.total});

  factory Clients.empty() => const Clients(active: 0, total: 0);

  factory Clients.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return Clients.empty();
    return Clients(active: json['active'] ?? 0, total: json['total'] ?? 0);
  }

  Map<String, dynamic> toJson() => {"active": active, "total": total};

  Clients copyWith({int? active, int? total}) =>
      Clients(active: active ?? this.active, total: total ?? this.total);

  @override
  List<Object?> get props => [active, total];
}

/// -------------------- Gravity --------------------
class Gravity extends Equatable {
  final int domainsBeingBlocked;
  final int lastUpdate;

  const Gravity({required this.domainsBeingBlocked, required this.lastUpdate});

  factory Gravity.empty() =>
      const Gravity(domainsBeingBlocked: 0, lastUpdate: 0);

  factory Gravity.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return Gravity.empty();
    return Gravity(
      domainsBeingBlocked: json['domains_being_blocked'] ?? 0,
      lastUpdate: json['last_update'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "domains_being_blocked": domainsBeingBlocked,
    "last_update": lastUpdate,
  };

  Gravity copyWith({int? domainsBeingBlocked, int? lastUpdate}) => Gravity(
    domainsBeingBlocked: domainsBeingBlocked ?? this.domainsBeingBlocked,
    lastUpdate: lastUpdate ?? this.lastUpdate,
  );

  @override
  List<Object?> get props => [domainsBeingBlocked, lastUpdate];
}
