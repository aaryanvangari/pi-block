import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';

class MetricsModel extends Equatable {
  final Metrics metrics;
  final double took;

  const MetricsModel({required this.metrics, required this.took});

  factory MetricsModel.empty() =>
      MetricsModel(metrics: Metrics.empty(), took: 0);

  bool get isEmpty => metrics.isEmpty;

  factory MetricsModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(MetricsModel, json);
    return MetricsModel(
      metrics: Metrics.fromJson(json['metrics'] ?? {}),
      took: (json['took'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'metrics': metrics.toJson(), 'took': took};

  MetricsModel copyWith({Metrics? metrics, double? took}) {
    return MetricsModel(
      metrics: metrics ?? this.metrics,
      took: took ?? this.took,
    );
  }

  @override
  List<Object?> get props => [metrics, took];
}

/// ===============================
/// Metrics container
/// ===============================
class Metrics extends Equatable {
  final DnsMetrics dns;
  final DhcpMetrics dhcp;

  const Metrics({required this.dns, required this.dhcp});

  factory Metrics.empty() =>
      Metrics(dns: DnsMetrics.empty(), dhcp: DhcpMetrics.empty());

  bool get isEmpty => dns.isEmpty && dhcp.isEmpty;

  factory Metrics.fromJson(Map<String, dynamic> json) {
    return Metrics(
      dns: DnsMetrics.fromJson(json['dns'] ?? {}),
      dhcp: DhcpMetrics.fromJson(json['dhcp'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {'dns': dns.toJson(), 'dhcp': dhcp.toJson()};

  Metrics copyWith({DnsMetrics? dns, DhcpMetrics? dhcp}) {
    return Metrics(dns: dns ?? this.dns, dhcp: dhcp ?? this.dhcp);
  }

  @override
  List<Object?> get props => [dns, dhcp];
}

/// ===============================
/// DNS metrics
/// ===============================
class DnsMetrics extends Equatable {
  final DnsCache cache;
  final DnsReplies replies;

  const DnsMetrics({required this.cache, required this.replies});

  factory DnsMetrics.empty() =>
      DnsMetrics(cache: DnsCache.empty(), replies: DnsReplies.empty());

  bool get isEmpty => cache.isEmpty && replies.isEmpty;

  factory DnsMetrics.fromJson(Map<String, dynamic> json) {
    return DnsMetrics(
      cache: DnsCache.fromJson(json['cache'] ?? {}),
      replies: DnsReplies.fromJson(json['replies'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'cache': cache.toJson(),
    'replies': replies.toJson(),
  };

  @override
  List<Object?> get props => [cache, replies];
}

/// ===============================
/// DNS Cache
/// ===============================
class DnsCache extends Equatable {
  final int size;
  final int inserted;
  final int evicted;
  final int expired;
  final int immortal;
  final List<DnsCacheEntry> content;

  const DnsCache({
    required this.size,
    required this.inserted,
    required this.evicted,
    required this.expired,
    required this.immortal,
    required this.content,
  });

  factory DnsCache.empty() => const DnsCache(
    size: 0,
    inserted: 0,
    evicted: 0,
    expired: 0,
    immortal: 0,
    content: [],
  );

  bool get isEmpty =>
      size == 0 &&
      inserted == 0 &&
      evicted == 0 &&
      expired == 0 &&
      immortal == 0 &&
      content.isEmpty;

  factory DnsCache.fromJson(Map<String, dynamic> json) {
    return DnsCache(
      size: json['size'] ?? 0,
      inserted: json['inserted'] ?? 0,
      evicted: json['evicted'] ?? 0,
      expired: json['expired'] ?? 0,
      immortal: json['immortal'] ?? 0,
      content: (json['content'] as List<dynamic>? ?? [])
          .map((e) => DnsCacheEntry.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'size': size,
    'inserted': inserted,
    'evicted': evicted,
    'expired': expired,
    'immortal': immortal,
    'content': content.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    size,
    inserted,
    evicted,
    expired,
    immortal,
    content,
  ];
}

/// ===============================
/// DNS Cache Entry
/// ===============================
class DnsCacheEntry extends Equatable {
  final int type;
  final String name;
  final CacheCount count;

  const DnsCacheEntry({
    required this.type,
    required this.name,
    required this.count,
  });

  factory DnsCacheEntry.empty() =>
      DnsCacheEntry(type: 0, name: '', count: CacheCount.empty());

  bool get isEmpty => type == 0 && name.isEmpty && count.isEmpty;

  factory DnsCacheEntry.fromJson(Map<String, dynamic> json) {
    return DnsCacheEntry(
      type: json['type'] ?? 0,
      name: json['name'] ?? '',
      count: CacheCount.fromJson(json['count'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'name': name,
    'count': count.toJson(),
  };

  @override
  List<Object?> get props => [type, name, count];
}

/// ===============================
/// Cache count
/// ===============================
class CacheCount extends Equatable {
  final int valid;
  final int stale;

  const CacheCount({required this.valid, required this.stale});

  factory CacheCount.empty() => const CacheCount(valid: 0, stale: 0);

  bool get isEmpty => valid == 0 && stale == 0;

  factory CacheCount.fromJson(Map<String, dynamic> json) {
    return CacheCount(valid: json['valid'] ?? 0, stale: json['stale'] ?? 0);
  }

  Map<String, dynamic> toJson() => {'valid': valid, 'stale': stale};

  @override
  List<Object?> get props => [valid, stale];
}

/// ===============================
/// DNS Replies
/// ===============================
class DnsReplies extends Equatable {
  final int forwarded;
  final int unanswered;
  final int local;
  final int optimized;
  final int auth;
  final int sum;

  const DnsReplies({
    required this.forwarded,
    required this.unanswered,
    required this.local,
    required this.optimized,
    required this.auth,
    required this.sum,
  });

  factory DnsReplies.empty() => const DnsReplies(
    forwarded: 0,
    unanswered: 0,
    local: 0,
    optimized: 0,
    auth: 0,
    sum: 0,
  );

  bool get isEmpty =>
      forwarded == 0 &&
      unanswered == 0 &&
      local == 0 &&
      optimized == 0 &&
      auth == 0 &&
      sum == 0;

  factory DnsReplies.fromJson(Map<String, dynamic> json) {
    return DnsReplies(
      forwarded: json['forwarded'] ?? 0,
      unanswered: json['unanswered'] ?? 0,
      local: json['local'] ?? 0,
      optimized: json['optimized'] ?? 0,
      auth: json['auth'] ?? 0,
      sum: json['sum'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'forwarded': forwarded,
    'unanswered': unanswered,
    'local': local,
    'optimized': optimized,
    'auth': auth,
    'sum': sum,
  };

  @override
  List<Object?> get props => [
    forwarded,
    unanswered,
    local,
    optimized,
    auth,
    sum,
  ];
}

/// ===============================
/// DHCP metrics
/// ===============================
class DhcpMetrics extends Equatable {
  final int ack;
  final int nak;
  final int decline;
  final int offer;
  final int discover;
  final int inform;
  final int request;
  final int release;
  final int noanswer;
  final int bootp;
  final int pxe;
  final DhcpLeases leases;

  const DhcpMetrics({
    required this.ack,
    required this.nak,
    required this.decline,
    required this.offer,
    required this.discover,
    required this.inform,
    required this.request,
    required this.release,
    required this.noanswer,
    required this.bootp,
    required this.pxe,
    required this.leases,
  });

  factory DhcpMetrics.empty() => DhcpMetrics(
    ack: 0,
    nak: 0,
    decline: 0,
    offer: 0,
    discover: 0,
    inform: 0,
    request: 0,
    release: 0,
    noanswer: 0,
    bootp: 0,
    pxe: 0,
    leases: DhcpLeases.empty(),
  );

  bool get isEmpty =>
      ack == 0 &&
      nak == 0 &&
      decline == 0 &&
      offer == 0 &&
      discover == 0 &&
      inform == 0 &&
      request == 0 &&
      release == 0 &&
      noanswer == 0 &&
      bootp == 0 &&
      pxe == 0 &&
      leases.isEmpty;

  factory DhcpMetrics.fromJson(Map<String, dynamic> json) {
    return DhcpMetrics(
      ack: json['ack'] ?? 0,
      nak: json['nak'] ?? 0,
      decline: json['decline'] ?? 0,
      offer: json['offer'] ?? 0,
      discover: json['discover'] ?? 0,
      inform: json['inform'] ?? 0,
      request: json['request'] ?? 0,
      release: json['release'] ?? 0,
      noanswer: json['noanswer'] ?? 0,
      bootp: json['bootp'] ?? 0,
      pxe: json['pxe'] ?? 0,
      leases: DhcpLeases.fromJson(json['leases'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'ack': ack,
    'nak': nak,
    'decline': decline,
    'offer': offer,
    'discover': discover,
    'inform': inform,
    'request': request,
    'release': release,
    'noanswer': noanswer,
    'bootp': bootp,
    'pxe': pxe,
    'leases': leases.toJson(),
  };

  @override
  List<Object?> get props => [
    ack,
    nak,
    decline,
    offer,
    discover,
    inform,
    request,
    release,
    noanswer,
    bootp,
    pxe,
    leases,
  ];
}

/// ===============================
/// DHCP leases
/// ===============================
class DhcpLeases extends Equatable {
  final int allocated4;
  final int pruned4;
  final int allocated6;
  final int pruned6;

  const DhcpLeases({
    required this.allocated4,
    required this.pruned4,
    required this.allocated6,
    required this.pruned6,
  });

  factory DhcpLeases.empty() =>
      const DhcpLeases(allocated4: 0, pruned4: 0, allocated6: 0, pruned6: 0);

  bool get isEmpty =>
      allocated4 == 0 && pruned4 == 0 && allocated6 == 0 && pruned6 == 0;

  factory DhcpLeases.fromJson(Map<String, dynamic> json) {
    return DhcpLeases(
      allocated4: json['allocated_4'] ?? 0,
      pruned4: json['pruned_4'] ?? 0,
      allocated6: json['allocated_6'] ?? 0,
      pruned6: json['pruned_6'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'allocated_4': allocated4,
    'pruned_4': pruned4,
    'allocated_6': allocated6,
    'pruned_6': pruned6,
  };

  @override
  List<Object?> get props => [allocated4, pruned4, allocated6, pruned6];
}
