// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

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

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "SummaryModel.fromJson",
    );
    return SummaryModel(
      queries: Queries.fromJson(json['queries']),
      clients: Clients.fromJson(json['clients']),
      gravity: Gravity.fromJson(json['gravity']),
      took: json['took'],
    );
  }

  Map<String, dynamic> toJson() => {
    "queries": queries.toJson(),
    "clients": clients.toJson(),
    "gravity": gravity.toJson(),
    "took": took,
  };

  @override
  List<Object?> get props => [queries, clients, gravity, took];
}

/// -------------------- Queries --------------------
class Queries extends Equatable{
  /// Total number of queries
  final int total;

  /// Number of blocked queries
  final int blocked;

  /// Percent of blocked queries
  final double percentBlocked;

  /// Number of unique domains FTL knows
  final int uniqueDomains;

  /// Number of queries forwarded upstream
  final int forwarded;

  /// Number of queries replied to from cache or local configuration
  final int cached;

  /// Average number of queries per second
  final double frequency;

  /// Number of individual queries by type
  final QueryTypes types;

  /// Number of individual queries by status
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

  factory Queries.fromJson(Map<String, dynamic> json) => Queries(
    total: json['total'],
    blocked: json['blocked'],
    percentBlocked: json['percent_blocked'].toDouble() ?? 0,
    uniqueDomains: json['unique_domains'],
    forwarded: json['forwarded'],
    cached: json['cached'],
    frequency: json['frequency'].toDouble() ?? 0,
    types: QueryTypes.fromJson(json['types']),
    status: QueryStatus.fromJson(json['status']),
  );

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
    status
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

  factory QueryTypes.fromJson(Map<String, dynamic> json) => QueryTypes(
    A: json['A'],
    AAAA: json['AAAA'],
    ANY: json['ANY'],
    SRV: json['SRV'],
    SOA: json['SOA'],
    PTR: json['PTR'],
    TXT: json['TXT'],
    NAPTR: json['NAPTR'],
    MX: json['MX'],
    DS: json['DS'],
    RRSIG: json['RRSIG'],
    DNSKEY: json['DNSKEY'],
    NS: json['NS'],
    SVCB: json['SVCB'],
    HTTPS: json['HTTPS'],
    OTHER: json['OTHER'],
  );

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
class QueryStatus extends Equatable{
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

  factory QueryStatus.fromJson(Map<String, dynamic> json) => QueryStatus(
    UNKNOWN: json['UNKNOWN'],
    GRAVITY: json['GRAVITY'],
    FORWARDED: json['FORWARDED'],
    CACHE: json['CACHE'],
    REGEX: json['REGEX'],
    DENYLIST: json['DENYLIST'],
    EXTERNAL_BLOCKED_IP: json['EXTERNAL_BLOCKED_IP'],
    EXTERNAL_BLOCKED_NULL: json['EXTERNAL_BLOCKED_NULL'],
    EXTERNAL_BLOCKED_NXRA: json['EXTERNAL_BLOCKED_NXRA'],
    GRAVITY_CNAME: json['GRAVITY_CNAME'],
    REGEX_CNAME: json['REGEX_CNAME'],
    DENYLIST_CNAME: json['DENYLIST_CNAME'],
    RETRIED: json['RETRIED'],
    RETRIED_DNSSEC: json['RETRIED_DNSSEC'],
    IN_PROGRESS: json['IN_PROGRESS'],
    DBBUSY: json['DBBUSY'],
    SPECIAL_DOMAIN: json['SPECIAL_DOMAIN'],
    CACHE_STALE: json['CACHE_STALE'],
    EXTERNAL_BLOCKED_EDE15: json['EXTERNAL_BLOCKED_EDE15'],
  );

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
    EXTERNAL_BLOCKED_EDE15
  ];
}

/// -------------------- Clients --------------------
class Clients extends Equatable{
  /// Number of active clients (seen in the last 24 hours)
  final int active;

  /// Total number of clients seen by FTL
  final int total;

  const Clients({required this.active, required this.total});

  factory Clients.fromJson(Map<String, dynamic> json) =>
      Clients(active: json['active'], total: json['total']);

  Map<String, dynamic> toJson() => {"active": active, "total": total};

  @override
  List<Object?> get props => [
    active,
    total
  ];
}

/// -------------------- Gravity --------------------
class Gravity extends Equatable{
  /// Number of domains on the Pi-hole's gravity list
  final int domainsBeingBlocked;

  /// Unix timestamp of last gravity update (0 if unknown)
  final int lastUpdate;

  const Gravity({required this.domainsBeingBlocked, required this.lastUpdate});

  factory Gravity.fromJson(Map<String, dynamic> json) => Gravity(
    domainsBeingBlocked: json['domains_being_blocked'],
    lastUpdate: json['last_update'],
  );

  Map<String, dynamic> toJson() => {
    "domains_being_blocked": domainsBeingBlocked,
    "last_update": lastUpdate,
  };

  @override
  List<Object?> get props => [
    domainsBeingBlocked,
    lastUpdate
  ];
}
