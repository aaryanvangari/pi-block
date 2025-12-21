// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

class PiholeConfigModel extends Equatable {
  final Config config;
  final double took;

  const PiholeConfigModel({required this.config, required this.took});

  factory PiholeConfigModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "PiholeConfigModel.fromJson",
    );
    return PiholeConfigModel(
      config: Config.fromJson(json['config']),
      took: (json['took'] as num).toDouble(),
    );
  }   

  Map<String, dynamic> toJson() => {'config': config.toJson(), 'took': took};

  PiholeConfigModel copyWith({Config? config, double? took}) =>
      PiholeConfigModel(config: config ?? this.config, took: took ?? this.took);

  @override
  List<Object?> get props => [config, took];
}

class Config extends Equatable {
  final Dns dns;
  final Dhcp dhcp;
  final Ntp ntp;
  final Resolver resolver;
  final Database database;
  final Webserver webserver;
  final Files files;
  final Misc misc;
  final Debug debug;

  const Config({
    required this.dns,
    required this.dhcp,
    required this.ntp,
    required this.resolver,
    required this.database,
    required this.webserver,
    required this.files,
    required this.misc,
    required this.debug,
  });

  factory Config.fromJson(Map<String, dynamic> json) => Config(
    dns: Dns.fromJson(json['dns']),
    dhcp: Dhcp.fromJson(json['dhcp']),
    ntp: Ntp.fromJson(json['ntp']),
    resolver: Resolver.fromJson(json['resolver']),
    database: Database.fromJson(json['database']),
    webserver: Webserver.fromJson(json['webserver']),
    files: Files.fromJson(json['files']),
    misc: Misc.fromJson(json['misc']),
    debug: Debug.fromJson(json['debug']),
  );

  Map<String, dynamic> toJson() => {
    'dns': dns.toJson(),
    'dhcp': dhcp.toJson(),
    'ntp': ntp.toJson(),
    'resolver': resolver.toJson(),
    'database': database.toJson(),
    'webserver': webserver.toJson(),
    'files': files.toJson(),
    'misc': misc.toJson(),
    'debug': debug.toJson(),
  };

  Config copyWith({
    Dns? dns,
    Dhcp? dhcp,
    Ntp? ntp,
    Resolver? resolver,
    Database? database,
    Webserver? webserver,
    Files? files,
    Misc? misc,
    Debug? debug,
  }) => Config(
    dns: dns ?? this.dns,
    dhcp: dhcp ?? this.dhcp,
    ntp: ntp ?? this.ntp,
    resolver: resolver ?? this.resolver,
    database: database ?? this.database,
    webserver: webserver ?? this.webserver,
    files: files ?? this.files,
    misc: misc ?? this.misc,
    debug: debug ?? this.debug,
  );

  @override
  List<Object?> get props => [
    dns,
    dhcp,
    ntp,
    resolver,
    database,
    webserver,
    files,
    misc,
    debug,
  ];
}

class Dns extends Equatable {
  final List<String> upstreams;
  final bool CNAMEdeepInspect;
  final bool blockESNI;
  final bool EDNS0ECS;
  final bool ignoreLocalhost;
  final bool showDNSSEC;
  final bool analyzeOnlyAandAAAA;
  final bool domainNeeded;
  final bool expandHosts;
  final Domain domain;
  final bool bogusPriv;
  final bool dnssec;
  final String interface;
  final String hostRecord;
  final String listeningMode;
  final bool queryLogging;
  final List<String> cnameRecords;
  final int port;
  final bool localise;
  final Cache cache;
  final List<String> hosts;
  final List<String> revServers;
  final Blocking blocking;
  final SpecialDomains specialDomains;
  final Reply reply;
  final RateLimit rateLimit;

  const Dns({
    required this.upstreams,
    required this.CNAMEdeepInspect,
    required this.blockESNI,
    required this.EDNS0ECS,
    required this.ignoreLocalhost,
    required this.showDNSSEC,
    required this.analyzeOnlyAandAAAA,
    required this.domainNeeded,
    required this.expandHosts,
    required this.domain,
    required this.bogusPriv,
    required this.dnssec,
    required this.interface,
    required this.hostRecord,
    required this.listeningMode,
    required this.queryLogging,
    required this.cnameRecords,
    required this.port,
    required this.localise,
    required this.cache,
    required this.hosts,
    required this.revServers,
    required this.blocking,
    required this.specialDomains,
    required this.reply,
    required this.rateLimit,
  });

  factory Dns.fromJson(Map<String, dynamic> json) => Dns(
    upstreams: List<String>.from(json['upstreams']),
    CNAMEdeepInspect: json['CNAMEdeepInspect'],
    blockESNI: json['blockESNI'],
    EDNS0ECS: json['EDNS0ECS'],
    ignoreLocalhost: json['ignoreLocalhost'],
    showDNSSEC: json['showDNSSEC'],
    analyzeOnlyAandAAAA: json['analyzeOnlyAandAAAA'],
    domainNeeded: json['domainNeeded'],
    expandHosts: json['expandHosts'],
    domain: Domain.fromJson(json['domain']),
    bogusPriv: json['bogusPriv'],
    dnssec: json['dnssec'],
    interface: json['interface'],
    hostRecord: json['hostRecord'],
    listeningMode: json['listeningMode'],
    queryLogging: json['queryLogging'],
    cnameRecords: List<String>.from(json['cnameRecords']),
    port: json['port'],
    localise: json['localise'],
    cache: Cache.fromJson(json['cache']),
    hosts: List<String>.from(json['hosts']),
    revServers: List<String>.from(json['revServers']),
    blocking: Blocking.fromJson(json['blocking']),
    specialDomains: SpecialDomains.fromJson(json['specialDomains']),
    reply: Reply.fromJson(json['reply']),
    rateLimit: RateLimit.fromJson(json['rateLimit']),
  );

  Map<String, dynamic> toJson() => {
    'upstreams': upstreams,
    'CNAMEdeepInspect': CNAMEdeepInspect,
    'blockESNI': blockESNI,
    'EDNS0ECS': EDNS0ECS,
    'ignoreLocalhost': ignoreLocalhost,
    'showDNSSEC': showDNSSEC,
    'analyzeOnlyAandAAAA': analyzeOnlyAandAAAA,
    'domainNeeded': domainNeeded,
    'expandHosts': expandHosts,
    'domain': domain.toJson(),
    'bogusPriv': bogusPriv,
    'dnssec': dnssec,
    'interface': interface,
    'hostRecord': hostRecord,
    'listeningMode': listeningMode,
    'queryLogging': queryLogging,
    'cnameRecords': cnameRecords,
    'port': port,
    'localise': localise,
    'cache': cache.toJson(),
    'hosts': hosts,
    'revServers': revServers,
    'blocking': blocking.toJson(),
    'specialDomains': specialDomains.toJson(),
    'reply': reply.toJson(),
    'rateLimit': rateLimit.toJson(),
  };

  Dns copyWith({
    List<String>? upstreams,
    bool? CNAMEdeepInspect,
    bool? blockESNI,
    bool? EDNS0ECS,
    bool? ignoreLocalhost,
    bool? showDNSSEC,
    bool? analyzeOnlyAandAAAA,
    bool? domainNeeded,
    bool? expandHosts,
    Domain? domain,
    bool? bogusPriv,
    bool? dnssec,
    String? interface,
    String? hostRecord,
    String? listeningMode,
    bool? queryLogging,
    List<String>? cnameRecords,
    int? port,
    bool? localise,
    Cache? cache,
    List<String>? hosts,
    List<String>? revServers,
    Blocking? blocking,
    SpecialDomains? specialDomains,
    Reply? reply,
    RateLimit? rateLimit,
  }) => Dns(
    upstreams: upstreams ?? this.upstreams,
    CNAMEdeepInspect: CNAMEdeepInspect ?? this.CNAMEdeepInspect,
    blockESNI: blockESNI ?? this.blockESNI,
    EDNS0ECS: EDNS0ECS ?? this.EDNS0ECS,
    ignoreLocalhost: ignoreLocalhost ?? this.ignoreLocalhost,
    showDNSSEC: showDNSSEC ?? this.showDNSSEC,
    analyzeOnlyAandAAAA: analyzeOnlyAandAAAA ?? this.analyzeOnlyAandAAAA,
    domainNeeded: domainNeeded ?? this.domainNeeded,
    expandHosts: expandHosts ?? this.expandHosts,
    domain: domain ?? this.domain,
    bogusPriv: bogusPriv ?? this.bogusPriv,
    dnssec: dnssec ?? this.dnssec,
    interface: interface ?? this.interface,
    hostRecord: hostRecord ?? this.hostRecord,
    listeningMode: listeningMode ?? this.listeningMode,
    queryLogging: queryLogging ?? this.queryLogging,
    cnameRecords: cnameRecords ?? this.cnameRecords,
    port: port ?? this.port,
    localise: localise ?? this.localise,
    cache: cache ?? this.cache,
    hosts: hosts ?? this.hosts,
    revServers: revServers ?? this.revServers,
    blocking: blocking ?? this.blocking,
    specialDomains: specialDomains ?? this.specialDomains,
    reply: reply ?? this.reply,
    rateLimit: rateLimit ?? this.rateLimit,
  );

  @override
  List<Object?> get props => [
    upstreams,
    CNAMEdeepInspect,
    blockESNI,
    EDNS0ECS,
    ignoreLocalhost,
    showDNSSEC,
    analyzeOnlyAandAAAA,
    domainNeeded,
    expandHosts,
    domain,
    bogusPriv,
    dnssec,
    interface,
    hostRecord,
    listeningMode,
    queryLogging,
    cnameRecords,
    port,
    localise,
    cache,
    hosts,
    revServers,
    blocking,
    specialDomains,
    reply,
    rateLimit,
  ];
}

class Domain extends Equatable {
  final String name;
  final bool local;

  const Domain({required this.name, required this.local});

  factory Domain.fromJson(Map<String, dynamic> json) =>
      Domain(name: json['name'], local: json['local']);

  Map<String, dynamic> toJson() => {'name': name, 'local': local};

  Domain copyWith({String? name, bool? local}) =>
      Domain(name: name ?? this.name, local: local ?? this.local);

  @override
  List<Object?> get props => [name, local];
}

class Cache extends Equatable {
  final int size;
  final int optimizer;
  final int upstreamBlockedTTL;

  const Cache({
    required this.size,
    required this.optimizer,
    required this.upstreamBlockedTTL,
  });

  factory Cache.fromJson(Map<String, dynamic> json) => Cache(
    size: json['size'],
    optimizer: json['optimizer'],
    upstreamBlockedTTL: json['upstreamBlockedTTL'],
  );

  Map<String, dynamic> toJson() => {
    'size': size,
    'optimizer': optimizer,
    'upstreamBlockedTTL': upstreamBlockedTTL,
  };

  Cache copyWith({int? size, int? optimizer, int? upstreamBlockedTTL}) => Cache(
    size: size ?? this.size,
    optimizer: optimizer ?? this.optimizer,
    upstreamBlockedTTL: upstreamBlockedTTL ?? this.upstreamBlockedTTL,
  );

  @override
  List<Object?> get props => [size, optimizer, upstreamBlockedTTL];
}

class Blocking extends Equatable {
  final bool active;
  final String mode;
  final String edns;

  const Blocking({
    required this.active,
    required this.mode,
    required this.edns,
  });

  factory Blocking.fromJson(Map<String, dynamic> json) =>
      Blocking(active: json['active'], mode: json['mode'], edns: json['edns']);

  Map<String, dynamic> toJson() => {
    'active': active,
    'mode': mode,
    'edns': edns,
  };

  Blocking copyWith({bool? active, String? mode, String? edns}) => Blocking(
    active: active ?? this.active,
    mode: mode ?? this.mode,
    edns: edns ?? this.edns,
  );

  @override
  List<Object?> get props => [active, mode, edns];
}

class SpecialDomains extends Equatable {
  final bool mozillaCanary;
  final bool iCloudPrivateRelay;
  final bool designatedResolver;

  const SpecialDomains({
    required this.mozillaCanary,
    required this.iCloudPrivateRelay,
    required this.designatedResolver,
  });

  factory SpecialDomains.fromJson(Map<String, dynamic> json) => SpecialDomains(
    mozillaCanary: json['mozillaCanary'],
    iCloudPrivateRelay: json['iCloudPrivateRelay'],
    designatedResolver: json['designatedResolver'],
  );

  Map<String, dynamic> toJson() => {
    'mozillaCanary': mozillaCanary,
    'iCloudPrivateRelay': iCloudPrivateRelay,
    'designatedResolver': designatedResolver,
  };

  SpecialDomains copyWith({
    bool? mozillaCanary,
    bool? iCloudPrivateRelay,
    bool? designatedResolver,
  }) => SpecialDomains(
    mozillaCanary: mozillaCanary ?? this.mozillaCanary,
    iCloudPrivateRelay: iCloudPrivateRelay ?? this.iCloudPrivateRelay,
    designatedResolver: designatedResolver ?? this.designatedResolver,
  );

  @override
  List<Object?> get props => [
    mozillaCanary,
    iCloudPrivateRelay,
    designatedResolver,
  ];
}

class Reply extends Equatable {
  final ReplyHost host;
  final ReplyHost blocking;

  const Reply({required this.host, required this.blocking});

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
    host: ReplyHost.fromJson(json['host']),
    blocking: ReplyHost.fromJson(json['blocking']),
  );

  Map<String, dynamic> toJson() => {
    'host': host.toJson(),
    'blocking': blocking.toJson(),
  };

  Reply copyWith({ReplyHost? host, ReplyHost? blocking}) =>
      Reply(host: host ?? this.host, blocking: blocking ?? this.blocking);

  @override
  List<Object?> get props => [host, blocking];
}

class ReplyHost extends Equatable {
  final bool force4;
  final bool force6;
  final String IPv4;
  final String IPv6;

  const ReplyHost({
    required this.force4,
    required this.force6,
    required this.IPv4,
    required this.IPv6,
  });

  factory ReplyHost.fromJson(Map<String, dynamic> json) => ReplyHost(
    force4: json['force4'],
    force6: json['force6'],
    IPv4: json['IPv4'],
    IPv6: json['IPv6'],
  );

  Map<String, dynamic> toJson() => {
    'force4': force4,
    'force6': force6,
    'IPv4': IPv4,
    'IPv6': IPv6,
  };

  ReplyHost copyWith({
    bool? force4,
    bool? force6,
    String? IPv4,
    String? IPv6,
  }) => ReplyHost(
    force4: force4 ?? this.force4,
    force6: force6 ?? this.force6,
    IPv4: IPv4 ?? this.IPv4,
    IPv6: IPv6 ?? this.IPv6,
  );

  @override
  List<Object?> get props => [force4, force6, IPv4, IPv6];
}

class RateLimit extends Equatable {
  final int count;
  final int interval;

  const RateLimit({required this.count, required this.interval});

  factory RateLimit.fromJson(Map<String, dynamic> json) =>
      RateLimit(count: json['count'], interval: json['interval']);

  Map<String, dynamic> toJson() => {'count': count, 'interval': interval};

  RateLimit copyWith({int? count, int? interval}) => RateLimit(
    count: count ?? this.count,
    interval: interval ?? this.interval,
  );

  @override
  List<Object?> get props => [count, interval];
}

class Dhcp extends Equatable {
  final bool active;
  final String start;
  final String end;
  final String router;
  final String netmask;
  final String leaseTime;
  final bool ipv6;
  final bool rapidCommit;
  final bool multiDNS;
  final bool logging;
  final bool ignoreUnknownClients;
  final List<String> hosts;

  const Dhcp({
    required this.active,
    required this.start,
    required this.end,
    required this.router,
    required this.netmask,
    required this.leaseTime,
    required this.ipv6,
    required this.rapidCommit,
    required this.multiDNS,
    required this.logging,
    required this.ignoreUnknownClients,
    required this.hosts,
  });

  factory Dhcp.fromJson(Map<String, dynamic> json) => Dhcp(
    active: json['active'],
    start: json['start'],
    end: json['end'],
    router: json['router'],
    netmask: json['netmask'],
    leaseTime: json['leaseTime'],
    ipv6: json['ipv6'],
    rapidCommit: json['rapidCommit'],
    multiDNS: json['multiDNS'],
    logging: json['logging'],
    ignoreUnknownClients: json['ignoreUnknownClients'],
    hosts: List<String>.from(json['hosts']),
  );

  Map<String, dynamic> toJson() => {
    'active': active,
    'start': start,
    'end': end,
    'router': router,
    'netmask': netmask,
    'leaseTime': leaseTime,
    'ipv6': ipv6,
    'rapidCommit': rapidCommit,
    'multiDNS': multiDNS,
    'logging': logging,
    'ignoreUnknownClients': ignoreUnknownClients,
    'hosts': hosts,
  };

  Dhcp copyWith({
    bool? active,
    String? start,
    String? end,
    String? router,
    String? netmask,
    String? leaseTime,
    bool? ipv6,
    bool? rapidCommit,
    bool? multiDNS,
    bool? logging,
    bool? ignoreUnknownClients,
    List<String>? hosts,
  }) => Dhcp(
    active: active ?? this.active,
    start: start ?? this.start,
    end: end ?? this.end,
    router: router ?? this.router,
    netmask: netmask ?? this.netmask,
    leaseTime: leaseTime ?? this.leaseTime,
    ipv6: ipv6 ?? this.ipv6,
    rapidCommit: rapidCommit ?? this.rapidCommit,
    multiDNS: multiDNS ?? this.multiDNS,
    logging: logging ?? this.logging,
    ignoreUnknownClients: ignoreUnknownClients ?? this.ignoreUnknownClients,
    hosts: hosts ?? this.hosts,
  );

  @override
  List<Object?> get props => [
    active,
    start,
    end,
    router,
    netmask,
    leaseTime,
    ipv6,
    rapidCommit,
    multiDNS,
    logging,
    ignoreUnknownClients,
    hosts,
  ];
}

class Ntp extends Equatable {
  final NtpHost ipv4;
  final NtpHost ipv6;
  final NtpSync sync;

  const Ntp({required this.ipv4, required this.ipv6, required this.sync});

  factory Ntp.fromJson(Map<String, dynamic> json) => Ntp(
    ipv4: NtpHost.fromJson(json['ipv4']),
    ipv6: NtpHost.fromJson(json['ipv6']),
    sync: NtpSync.fromJson(json['sync']),
  );

  Map<String, dynamic> toJson() => {
    'ipv4': ipv4.toJson(),
    'ipv6': ipv6.toJson(),
    'sync': sync.toJson(),
  };

  Ntp copyWith({NtpHost? ipv4, NtpHost? ipv6, NtpSync? sync}) => Ntp(
    ipv4: ipv4 ?? this.ipv4,
    ipv6: ipv6 ?? this.ipv6,
    sync: sync ?? this.sync,
  );

  @override
  List<Object?> get props => [ipv4, ipv6, sync];
}

class NtpHost extends Equatable {
  final bool active;
  final String address;

  const NtpHost({required this.active, required this.address});

  factory NtpHost.fromJson(Map<String, dynamic> json) =>
      NtpHost(active: json['active'], address: json['address']);

  Map<String, dynamic> toJson() => {'active': active, 'address': address};

  NtpHost copyWith({bool? active, String? address}) =>
      NtpHost(active: active ?? this.active, address: address ?? this.address);

  @override
  List<Object?> get props => [active, address];
}

class NtpSync extends Equatable {
  final bool active;
  final String server;
  final int interval;
  final int count;
  final RTC rtc;

  const NtpSync({
    required this.active,
    required this.server,
    required this.interval,
    required this.count,
    required this.rtc,
  });

  factory NtpSync.fromJson(Map<String, dynamic> json) => NtpSync(
    active: json['active'],
    server: json['server'],
    interval: json['interval'],
    count: json['count'],
    rtc: RTC.fromJson(json['rtc']),
  );

  Map<String, dynamic> toJson() => {
    'active': active,
    'server': server,
    'interval': interval,
    'count': count,
    'rtc': rtc.toJson(),
  };

  NtpSync copyWith({
    bool? active,
    String? server,
    int? interval,
    int? count,
    RTC? rtc,
  }) => NtpSync(
    active: active ?? this.active,
    server: server ?? this.server,
    interval: interval ?? this.interval,
    count: count ?? this.count,
    rtc: rtc ?? this.rtc,
  );

  @override
  List<Object?> get props => [active, server, interval, count, rtc];
}

class RTC extends Equatable {
  final bool set;
  final String device;
  final bool utc;

  const RTC({required this.set, required this.device, required this.utc});

  factory RTC.fromJson(Map<String, dynamic> json) =>
      RTC(set: json['set'], device: json['device'], utc: json['utc']);

  Map<String, dynamic> toJson() => {'set': set, 'device': device, 'utc': utc};

  RTC copyWith({bool? set, String? device, bool? utc}) => RTC(
    set: set ?? this.set,
    device: device ?? this.device,
    utc: utc ?? this.utc,
  );

  @override
  List<Object?> get props => [set, device, utc];
}

class Resolver extends Equatable {
  final bool resolveIPv4;
  final bool resolveIPv6;
  final bool networkNames;
  final String refreshNames;

  const Resolver({
    required this.resolveIPv4,
    required this.resolveIPv6,
    required this.networkNames,
    required this.refreshNames,
  });

  factory Resolver.fromJson(Map<String, dynamic> json) => Resolver(
    resolveIPv4: json['resolveIPv4'],
    resolveIPv6: json['resolveIPv6'],
    networkNames: json['networkNames'],
    refreshNames: json['refreshNames'],
  );

  Map<String, dynamic> toJson() => {
    'resolveIPv4': resolveIPv4,
    'resolveIPv6': resolveIPv6,
    'networkNames': networkNames,
    'refreshNames': refreshNames,
  };

  Resolver copyWith({
    bool? resolveIPv4,
    bool? resolveIPv6,
    bool? networkNames,
    String? refreshNames,
  }) => Resolver(
    resolveIPv4: resolveIPv4 ?? this.resolveIPv4,
    resolveIPv6: resolveIPv6 ?? this.resolveIPv6,
    networkNames: networkNames ?? this.networkNames,
    refreshNames: refreshNames ?? this.refreshNames,
  );

  @override
  List<Object?> get props => [
    resolveIPv4,
    resolveIPv6,
    networkNames,
    refreshNames,
  ];
}

class Database extends Equatable {
  final bool DBimport;
  final int maxDBdays;
  final int DBinterval;
  final bool useWAL;
  final DBNetwork network;

  const Database({
    required this.DBimport,
    required this.maxDBdays,
    required this.DBinterval,
    required this.useWAL,
    required this.network,
  });

  factory Database.fromJson(Map<String, dynamic> json) => Database(
    DBimport: json['DBimport'],
    maxDBdays: json['maxDBdays'],
    DBinterval: json['DBinterval'],
    useWAL: json['useWAL'],
    network: DBNetwork.fromJson(json['network']),
  );

  Map<String, dynamic> toJson() => {
    'DBimport': DBimport,
    'maxDBdays': maxDBdays,
    'DBinterval': DBinterval,
    'useWAL': useWAL,
    'network': network.toJson(),
  };

  Database copyWith({
    bool? DBimport,
    int? maxDBdays,
    int? DBinterval,
    bool? useWAL,
    DBNetwork? network,
  }) => Database(
    DBimport: DBimport ?? this.DBimport,
    maxDBdays: maxDBdays ?? this.maxDBdays,
    DBinterval: DBinterval ?? this.DBinterval,
    useWAL: useWAL ?? this.useWAL,
    network: network ?? this.network,
  );

  @override
  List<Object?> get props => [DBimport, maxDBdays, DBinterval, useWAL, network];
}

class DBNetwork extends Equatable {
  final bool parseARPcache;
  final int expire;

  const DBNetwork({required this.parseARPcache, required this.expire});

  factory DBNetwork.fromJson(Map<String, dynamic> json) =>
      DBNetwork(parseARPcache: json['parseARPcache'], expire: json['expire']);

  Map<String, dynamic> toJson() => {
    'parseARPcache': parseARPcache,
    'expire': expire,
  };

  DBNetwork copyWith({bool? parseARPcache, int? expire}) => DBNetwork(
    parseARPcache: parseARPcache ?? this.parseARPcache,
    expire: expire ?? this.expire,
  );

  @override
  List<Object?> get props => [parseARPcache, expire];
}

class Webserver extends Equatable {
  final String domain;
  final String acl;
  final String port;
  final int threads;
  final List<String> headers;
  final bool serve_all;
  final List<String> advancedOpts;
  final Session session;
  final Tls tls;
  final WebPaths paths;
  final Interface interface;
  final Api api;

  const Webserver({
    required this.domain,
    required this.acl,
    required this.port,
    required this.threads,
    required this.headers,
    required this.serve_all,
    required this.advancedOpts,
    required this.session,
    required this.tls,
    required this.paths,
    required this.interface,
    required this.api,
  });

  factory Webserver.fromJson(Map<String, dynamic> json) => Webserver(
    domain: json['domain'],
    acl: json['acl'],
    port: json['port'],
    threads: json['threads'],
    headers: List<String>.from(json['headers']),
    serve_all: json['serve_all'],
    advancedOpts: List<String>.from(json['advancedOpts']),
    session: Session.fromJson(json['session']),
    tls: Tls.fromJson(json['tls']),
    paths: WebPaths.fromJson(json['paths']),
    interface: Interface.fromJson(json['interface']),
    api: Api.fromJson(json['api']),
  );

  Map<String, dynamic> toJson() => {
    'domain': domain,
    'acl': acl,
    'port': port,
    'threads': threads,
    'headers': headers,
    'serve_all': serve_all,
    'advancedOpts': advancedOpts,
    'session': session.toJson(),
    'tls': tls.toJson(),
    'paths': paths.toJson(),
    'interface': interface.toJson(),
    'api': api.toJson(),
  };

  Webserver copyWith({
    String? domain,
    String? acl,
    String? port,
    int? threads,
    List<String>? headers,
    bool? serve_all,
    List<String>? advancedOpts,
    Session? session,
    Tls? tls,
    WebPaths? paths,
    Interface? interface,
    Api? api,
  }) => Webserver(
    domain: domain ?? this.domain,
    acl: acl ?? this.acl,
    port: port ?? this.port,
    threads: threads ?? this.threads,
    headers: headers ?? this.headers,
    serve_all: serve_all ?? this.serve_all,
    advancedOpts: advancedOpts ?? this.advancedOpts,
    session: session ?? this.session,
    tls: tls ?? this.tls,
    paths: paths ?? this.paths,
    interface: interface ?? this.interface,
    api: api ?? this.api,
  );

  @override
  List<Object?> get props => [
    domain,
    acl,
    port,
    threads,
    headers,
    serve_all,
    advancedOpts,
    session,
    tls,
    paths,
    interface,
    api,
  ];
}

class Session extends Equatable {
  final int timeout;
  final bool restore;

  const Session({required this.timeout, required this.restore});

  factory Session.fromJson(Map<String, dynamic> json) =>
      Session(timeout: json['timeout'], restore: json['restore']);

  Map<String, dynamic> toJson() => {'timeout': timeout, 'restore': restore};

  Session copyWith({int? timeout, bool? restore}) => Session(
    timeout: timeout ?? this.timeout,
    restore: restore ?? this.restore,
  );

  @override
  List<Object?> get props => [timeout, restore];
}

class Tls extends Equatable {
  final String cert;
  final int validity;

  const Tls({required this.cert, required this.validity});

  factory Tls.fromJson(Map<String, dynamic> json) =>
      Tls(cert: json['cert'], validity: json['validity']);

  Map<String, dynamic> toJson() => {'cert': cert, 'validity': validity};

  Tls copyWith({String? cert, int? validity}) =>
      Tls(cert: cert ?? this.cert, validity: validity ?? this.validity);

  @override
  List<Object?> get props => [cert, validity];
}

class WebPaths extends Equatable {
  final String webroot;
  final String webhome;
  final String prefix;

  const WebPaths({
    required this.webroot,
    required this.webhome,
    required this.prefix,
  });

  factory WebPaths.fromJson(Map<String, dynamic> json) => WebPaths(
    webroot: json['webroot'],
    webhome: json['webhome'],
    prefix: json['prefix'],
  );

  Map<String, dynamic> toJson() => {
    'webroot': webroot,
    'webhome': webhome,
    'prefix': prefix,
  };

  WebPaths copyWith({String? webroot, String? webhome, String? prefix}) =>
      WebPaths(
        webroot: webroot ?? this.webroot,
        webhome: webhome ?? this.webhome,
        prefix: prefix ?? this.prefix,
      );

  @override
  List<Object?> get props => [webroot, webhome, prefix];
}

class Interface extends Equatable {
  final bool boxed;
  final String theme;

  const Interface({required this.boxed, required this.theme});

  factory Interface.fromJson(Map<String, dynamic> json) =>
      Interface(boxed: json['boxed'], theme: json['theme']);

  Map<String, dynamic> toJson() => {'boxed': boxed, 'theme': theme};

  Interface copyWith({bool? boxed, String? theme}) =>
      Interface(boxed: boxed ?? this.boxed, theme: theme ?? this.theme);

  @override
  List<Object?> get props => [boxed, theme];
}

class Api extends Equatable {
  final int max_sessions;
  final bool prettyJSON;
  final String password;
  final String pwhash;
  final String totp_secret;
  final String app_pwhash;
  final bool app_sudo;
  final bool cli_pw;
  final List<String> excludeClients;
  final List<String> excludeDomains;
  final int maxHistory;
  final int maxClients;
  final bool client_history_global_max;
  final bool allow_destructive;
  final ApiTemp temp;

  const Api({
    required this.max_sessions,
    required this.prettyJSON,
    required this.password,
    required this.pwhash,
    required this.totp_secret,
    required this.app_pwhash,
    required this.app_sudo,
    required this.cli_pw,
    required this.excludeClients,
    required this.excludeDomains,
    required this.maxHistory,
    required this.maxClients,
    required this.client_history_global_max,
    required this.allow_destructive,
    required this.temp,
  });

  factory Api.fromJson(Map<String, dynamic> json) => Api(
    max_sessions: json['max_sessions'],
    prettyJSON: json['prettyJSON'],
    password: json['password'],
    pwhash: json['pwhash'],
    totp_secret: json['totp_secret'],
    app_pwhash: json['app_pwhash'],
    app_sudo: json['app_sudo'],
    cli_pw: json['cli_pw'],
    excludeClients: List<String>.from(json['excludeClients']),
    excludeDomains: List<String>.from(json['excludeDomains']),
    maxHistory: json['maxHistory'],
    maxClients: json['maxClients'],
    client_history_global_max: json['client_history_global_max'],
    allow_destructive: json['allow_destructive'],
    temp: ApiTemp.fromJson(json['temp']),
  );

  Map<String, dynamic> toJson() => {
    'max_sessions': max_sessions,
    'prettyJSON': prettyJSON,
    'password': password,
    'pwhash': pwhash,
    'totp_secret': totp_secret,
    'app_pwhash': app_pwhash,
    'app_sudo': app_sudo,
    'cli_pw': cli_pw,
    'excludeClients': excludeClients,
    'excludeDomains': excludeDomains,
    'maxHistory': maxHistory,
    'maxClients': maxClients,
    'client_history_global_max': client_history_global_max,
    'allow_destructive': allow_destructive,
    'temp': temp.toJson(),
  };

  Api copyWith({
    int? max_sessions,
    bool? prettyJSON,
    String? password,
    String? pwhash,
    String? totp_secret,
    String? app_pwhash,
    bool? app_sudo,
    bool? cli_pw,
    List<String>? excludeClients,
    List<String>? excludeDomains,
    int? maxHistory,
    int? maxClients,
    bool? client_history_global_max,
    bool? allow_destructive,
    ApiTemp? temp,
  }) => Api(
    max_sessions: max_sessions ?? this.max_sessions,
    prettyJSON: prettyJSON ?? this.prettyJSON,
    password: password ?? this.password,
    pwhash: pwhash ?? this.pwhash,
    totp_secret: totp_secret ?? this.totp_secret,
    app_pwhash: app_pwhash ?? this.app_pwhash,
    app_sudo: app_sudo ?? this.app_sudo,
    cli_pw: cli_pw ?? this.cli_pw,
    excludeClients: excludeClients ?? this.excludeClients,
    excludeDomains: excludeDomains ?? this.excludeDomains,
    maxHistory: maxHistory ?? this.maxHistory,
    maxClients: maxClients ?? this.maxClients,
    client_history_global_max:
        client_history_global_max ?? this.client_history_global_max,
    allow_destructive: allow_destructive ?? this.allow_destructive,
    temp: temp ?? this.temp,
  );

  @override
  List<Object?> get props => [
    max_sessions,
    prettyJSON,
    password,
    pwhash,
    totp_secret,
    app_pwhash,
    app_sudo,
    cli_pw,
    excludeClients,
    excludeDomains,
    maxHistory,
    maxClients,
    client_history_global_max,
    allow_destructive,
    temp,
  ];
}

class ApiTemp extends Equatable {
  final double limit;
  final String unit;

  const ApiTemp({required this.limit, required this.unit});

  factory ApiTemp.fromJson(Map<String, dynamic> json) =>
      ApiTemp(limit: (json['limit'] as num).toDouble(), unit: json['unit']);

  Map<String, dynamic> toJson() => {'limit': limit, 'unit': unit};

  ApiTemp copyWith({double? limit, String? unit}) =>
      ApiTemp(limit: limit ?? this.limit, unit: unit ?? this.unit);

  @override
  List<Object?> get props => [limit, unit];
}

class Files extends Equatable {
  final String pid;
  final String database;
  final String gravity;
  final String gravity_tmp;
  final String macvendor;
  final String pcap;
  final LogFiles log;

  const Files({
    required this.pid,
    required this.database,
    required this.gravity,
    required this.gravity_tmp,
    required this.macvendor,
    required this.pcap,
    required this.log,
  });

  factory Files.fromJson(Map<String, dynamic> json) => Files(
    pid: json['pid'],
    database: json['database'],
    gravity: json['gravity'],
    gravity_tmp: json['gravity_tmp'],
    macvendor: json['macvendor'],
    pcap: json['pcap'],
    log: LogFiles.fromJson(json['log']),
  );

  Map<String, dynamic> toJson() => {
    'pid': pid,
    'database': database,
    'gravity': gravity,
    'gravity_tmp': gravity_tmp,
    'macvendor': macvendor,
    'pcap': pcap,
    'log': log.toJson(),
  };

  Files copyWith({
    String? pid,
    String? database,
    String? gravity,
    String? gravity_tmp,
    String? macvendor,
    String? pcap,
    LogFiles? log,
  }) => Files(
    pid: pid ?? this.pid,
    database: database ?? this.database,
    gravity: gravity ?? this.gravity,
    gravity_tmp: gravity_tmp ?? this.gravity_tmp,
    macvendor: macvendor ?? this.macvendor,
    pcap: pcap ?? this.pcap,
    log: log ?? this.log,
  );

  @override
  List<Object?> get props => [
    pid,
    database,
    gravity,
    gravity_tmp,
    macvendor,
    pcap,
    log,
  ];
}

class LogFiles extends Equatable {
  final String ftl;
  final String dnsmasq;
  final String webserver;

  const LogFiles({
    required this.ftl,
    required this.dnsmasq,
    required this.webserver,
  });

  factory LogFiles.fromJson(Map<String, dynamic> json) => LogFiles(
    ftl: json['ftl'],
    dnsmasq: json['dnsmasq'],
    webserver: json['webserver'],
  );

  Map<String, dynamic> toJson() => {
    'ftl': ftl,
    'dnsmasq': dnsmasq,
    'webserver': webserver,
  };

  LogFiles copyWith({String? ftl, String? dnsmasq, String? webserver}) =>
      LogFiles(
        ftl: ftl ?? this.ftl,
        dnsmasq: dnsmasq ?? this.dnsmasq,
        webserver: webserver ?? this.webserver,
      );

  @override
  List<Object?> get props => [ftl, dnsmasq, webserver];
}

class Misc extends Equatable {
  final int nice;
  final int delay_startup;
  final bool addr2line;
  final bool etc_dnsmasq_d;
  final int privacylevel;
  final List<String> dnsmasq_lines;
  final bool extraLogging;
  final bool readOnly;
  final bool normalizeCPU;
  final bool hide_dnsmasq_warn;
  final MiscCheck check;

  const Misc({
    required this.nice,
    required this.delay_startup,
    required this.addr2line,
    required this.etc_dnsmasq_d,
    required this.privacylevel,
    required this.dnsmasq_lines,
    required this.extraLogging,
    required this.readOnly,
    required this.normalizeCPU,
    required this.hide_dnsmasq_warn,
    required this.check,
  });

  factory Misc.fromJson(Map<String, dynamic> json) => Misc(
    nice: json['nice'],
    delay_startup: json['delay_startup'],
    addr2line: json['addr2line'],
    etc_dnsmasq_d: json['etc_dnsmasq_d'],
    privacylevel: json['privacylevel'],
    dnsmasq_lines: List<String>.from(json['dnsmasq_lines']),
    extraLogging: json['extraLogging'],
    readOnly: json['readOnly'],
    normalizeCPU: json['normalizeCPU'],
    hide_dnsmasq_warn: json['hide_dnsmasq_warn'],
    check: MiscCheck.fromJson(json['check']),
  );

  Map<String, dynamic> toJson() => {
    'nice': nice,
    'delay_startup': delay_startup,
    'addr2line': addr2line,
    'etc_dnsmasq_d': etc_dnsmasq_d,
    'privacylevel': privacylevel,
    'dnsmasq_lines': dnsmasq_lines,
    'extraLogging': extraLogging,
    'readOnly': readOnly,
    'normalizeCPU': normalizeCPU,
    'hide_dnsmasq_warn': hide_dnsmasq_warn,
    'check': check.toJson(),
  };

  Misc copyWith({
    int? nice,
    int? delay_startup,
    bool? addr2line,
    bool? etc_dnsmasq_d,
    int? privacylevel,
    List<String>? dnsmasq_lines,
    bool? extraLogging,
    bool? readOnly,
    bool? normalizeCPU,
    bool? hide_dnsmasq_warn,
    MiscCheck? check,
  }) => Misc(
    nice: nice ?? this.nice,
    delay_startup: delay_startup ?? this.delay_startup,
    addr2line: addr2line ?? this.addr2line,
    etc_dnsmasq_d: etc_dnsmasq_d ?? this.etc_dnsmasq_d,
    privacylevel: privacylevel ?? this.privacylevel,
    dnsmasq_lines: dnsmasq_lines ?? this.dnsmasq_lines,
    extraLogging: extraLogging ?? this.extraLogging,
    readOnly: readOnly ?? this.readOnly,
    normalizeCPU: normalizeCPU ?? this.normalizeCPU,
    hide_dnsmasq_warn: hide_dnsmasq_warn ?? this.hide_dnsmasq_warn,
    check: check ?? this.check,
  );

  @override
  List<Object?> get props => [
    nice,
    delay_startup,
    addr2line,
    etc_dnsmasq_d,
    privacylevel,
    dnsmasq_lines,
    extraLogging,
    readOnly,
    normalizeCPU,
    hide_dnsmasq_warn,
    check,
  ];
}

class MiscCheck extends Equatable {
  final bool load;
  final int shmem;
  final int disk;

  const MiscCheck({
    required this.load,
    required this.shmem,
    required this.disk,
  });

  factory MiscCheck.fromJson(Map<String, dynamic> json) =>
      MiscCheck(load: json['load'], shmem: json['shmem'], disk: json['disk']);

  Map<String, dynamic> toJson() => {'load': load, 'shmem': shmem, 'disk': disk};

  MiscCheck copyWith({bool? load, int? shmem, int? disk}) => MiscCheck(
    load: load ?? this.load,
    shmem: shmem ?? this.shmem,
    disk: disk ?? this.disk,
  );

  @override
  List<Object?> get props => [load, shmem, disk];
}

class Debug extends Equatable {
  final bool database;
  final bool networking;
  final bool locks;
  final bool queries;
  final bool flags;
  final bool shmem;
  final bool gc;
  final bool arp;
  final bool regex;
  final bool api;
  final bool tls;
  final bool overtime;
  final bool status;
  final bool caps;
  final bool dnssec;
  final bool vectors;
  final bool resolver;
  final bool edns0;
  final bool clients;
  final bool aliasclients;
  final bool events;
  final bool helper;
  final bool config;
  final bool inotify;
  final bool webserver;
  final bool extra;
  final bool reserved;
  final bool ntp;
  final bool netlink;
  final bool all;

  const Debug({
    required this.database,
    required this.networking,
    required this.locks,
    required this.queries,
    required this.flags,
    required this.shmem,
    required this.gc,
    required this.arp,
    required this.regex,
    required this.api,
    required this.tls,
    required this.overtime,
    required this.status,
    required this.caps,
    required this.dnssec,
    required this.vectors,
    required this.resolver,
    required this.edns0,
    required this.clients,
    required this.aliasclients,
    required this.events,
    required this.helper,
    required this.config,
    required this.inotify,
    required this.webserver,
    required this.extra,
    required this.reserved,
    required this.ntp,
    required this.netlink,
    required this.all,
  });

  factory Debug.fromJson(Map<String, dynamic> json) => Debug(
    database: json['database'],
    networking: json['networking'],
    locks: json['locks'],
    queries: json['queries'],
    flags: json['flags'],
    shmem: json['shmem'],
    gc: json['gc'],
    arp: json['arp'],
    regex: json['regex'],
    api: json['api'],
    tls: json['tls'],
    overtime: json['overtime'],
    status: json['status'],
    caps: json['caps'],
    dnssec: json['dnssec'],
    vectors: json['vectors'],
    resolver: json['resolver'],
    edns0: json['edns0'],
    clients: json['clients'],
    aliasclients: json['aliasclients'],
    events: json['events'],
    helper: json['helper'],
    config: json['config'],
    inotify: json['inotify'],
    webserver: json['webserver'],
    extra: json['extra'],
    reserved: json['reserved'],
    ntp: json['ntp'],
    netlink: json['netlink'],
    all: json['all'],
  );

  Map<String, dynamic> toJson() => {
    'database': database,
    'networking': networking,
    'locks': locks,
    'queries': queries,
    'flags': flags,
    'shmem': shmem,
    'gc': gc,
    'arp': arp,
    'regex': regex,
    'api': api,
    'tls': tls,
    'overtime': overtime,
    'status': status,
    'caps': caps,
    'dnssec': dnssec,
    'vectors': vectors,
    'resolver': resolver,
    'edns0': edns0,
    'clients': clients,
    'aliasclients': aliasclients,
    'events': events,
    'helper': helper,
    'config': config,
    'inotify': inotify,
    'webserver': webserver,
    'extra': extra,
    'reserved': reserved,
    'ntp': ntp,
    'netlink': netlink,
    'all': all,
  };

  Debug copyWith({
    bool? database,
    bool? networking,
    bool? locks,
    bool? queries,
    bool? flags,
    bool? shmem,
    bool? gc,
    bool? arp,
    bool? regex,
    bool? api,
    bool? tls,
    bool? overtime,
    bool? status,
    bool? caps,
    bool? dnssec,
    bool? vectors,
    bool? resolver,
    bool? edns0,
    bool? clients,
    bool? aliasclients,
    bool? events,
    bool? helper,
    bool? config,
    bool? inotify,
    bool? webserver,
    bool? extra,
    bool? reserved,
    bool? ntp,
    bool? netlink,
    bool? all,
  }) => Debug(
    database: database ?? this.database,
    networking: networking ?? this.networking,
    locks: locks ?? this.locks,
    queries: queries ?? this.queries,
    flags: flags ?? this.flags,
    shmem: shmem ?? this.shmem,
    gc: gc ?? this.gc,
    arp: arp ?? this.arp,
    regex: regex ?? this.regex,
    api: api ?? this.api,
    tls: tls ?? this.tls,
    overtime: overtime ?? this.overtime,
    status: status ?? this.status,
    caps: caps ?? this.caps,
    dnssec: dnssec ?? this.dnssec,
    vectors: vectors ?? this.vectors,
    resolver: resolver ?? this.resolver,
    edns0: edns0 ?? this.edns0,
    clients: clients ?? this.clients,
    aliasclients: aliasclients ?? this.aliasclients,
    events: events ?? this.events,
    helper: helper ?? this.helper,
    config: config ?? this.config,
    inotify: inotify ?? this.inotify,
    webserver: webserver ?? this.webserver,
    extra: extra ?? this.extra,
    reserved: reserved ?? this.reserved,
    ntp: ntp ?? this.ntp,
    netlink: netlink ?? this.netlink,
    all: all ?? this.all,
  );

  @override
  List<Object?> get props => [
    database,
    networking,
    locks,
    queries,
    flags,
    shmem,
    gc,
    arp,
    regex,
    api,
    tls,
    overtime,
    status,
    caps,
    dnssec,
    vectors,
    resolver,
    edns0,
    clients,
    aliasclients,
    events,
    helper,
    config,
    inotify,
    webserver,
    extra,
    reserved,
    ntp,
    netlink,
    all,
  ];
}
