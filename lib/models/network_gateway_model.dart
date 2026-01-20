import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';

class NetworkGatewayModel extends Equatable {
  final List<GatewayModel> gateway;
  final List<RouteModel> routes;
  final List<NetworkInterfaceModel> interfaces;
  final double took;

  const NetworkGatewayModel({
    required this.gateway,
    required this.routes,
    required this.interfaces,
    required this.took,
  });

  factory NetworkGatewayModel.empty() => const NetworkGatewayModel(
    gateway: [],
    routes: [],
    interfaces: [],
    took: 0,
  );

  NetworkGatewayModel copyWith({
    List<GatewayModel>? gateway,
    List<RouteModel>? routes,
    List<NetworkInterfaceModel>? interfaces,
    double? took,
  }) {
    return NetworkGatewayModel(
      gateway: gateway ?? this.gateway,
      routes: routes ?? this.routes,
      interfaces: interfaces ?? this.interfaces,
      took: took ?? this.took,
    );
  }

  factory NetworkGatewayModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(NetworkGatewayModel, json);
    return NetworkGatewayModel(
      gateway: (json['gateway'] as List<dynamic>? ?? [])
          .map((e) => GatewayModel.fromJson(e))
          .toList(),
      routes: (json['routes'] as List<dynamic>? ?? [])
          .map((e) => RouteModel.fromJson(e))
          .toList(),
      interfaces: (json['interfaces'] as List<dynamic>? ?? [])
          .map((e) => NetworkInterfaceModel.fromJson(e))
          .toList(),
      took: (json['took'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'gateway': gateway.map((e) => e.toJson()).toList(),
    'routes': routes.map((e) => e.toJson()).toList(),
    'interfaces': interfaces.map((e) => e.toJson()).toList(),
    'took': took,
  };

  @override
  List<Object?> get props => [gateway, routes, interfaces, took];
}

/// ===============================
/// GATEWAY
/// ===============================
class GatewayModel extends Equatable {
  final String family;
  final String interfaceName;
  final String address;
  final List<String> local;

  const GatewayModel({
    required this.family,
    required this.interfaceName,
    required this.address,
    required this.local,
  });

  factory GatewayModel.empty() =>
      const GatewayModel(family: '', interfaceName: '', address: '', local: []);

  GatewayModel copyWith({
    String? family,
    String? interfaceName,
    String? address,
    List<String>? local,
  }) {
    return GatewayModel(
      family: family ?? this.family,
      interfaceName: interfaceName ?? this.interfaceName,
      address: address ?? this.address,
      local: local ?? this.local,
    );
  }

  factory GatewayModel.fromJson(Map<String, dynamic> json) {
    return GatewayModel(
      family: json['family'] ?? '',
      interfaceName: json['interface'] ?? '',
      address: json['address'] ?? '',
      local: List<String>.from(json['local'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'family': family,
    'interface': interfaceName,
    'address': address,
    'local': local,
  };

  @override
  List<Object?> get props => [family, interfaceName, address, local];
}

/// ===============================
/// ROUTE
/// ===============================
class RouteModel extends Equatable {
  final int table;
  final String family;
  final String protocol;
  final String scope;
  final String type;
  final List<String> flags;
  final int iflags;
  final String? gateway;
  final String? oif;
  final String dst;
  final String? prefsrc;
  final int? priority;
  final int? cstamp;
  final int? tstamp;
  final int? expires;
  final int? error;
  final int? used;
  final int? pref;

  const RouteModel({
    required this.table,
    required this.family,
    required this.protocol,
    required this.scope,
    required this.type,
    required this.flags,
    required this.iflags,
    required this.dst,
    this.gateway,
    this.oif,
    this.prefsrc,
    this.priority,
    this.cstamp,
    this.tstamp,
    this.expires,
    this.error,
    this.used,
    this.pref,
  });

  factory RouteModel.empty() => const RouteModel(
    table: 0,
    family: '',
    protocol: '',
    scope: '',
    type: '',
    flags: [],
    iflags: 0,
    dst: '',
  );

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      table: json['table'] ?? 0,
      family: json['family'] ?? '',
      protocol: json['protocol'] ?? '',
      scope: json['scope'] ?? '',
      type: json['type'] ?? '',
      flags: List<String>.from(json['flags'] ?? []),
      iflags: json['iflags'] ?? 0,
      gateway: json['gateway'],
      oif: json['oif'],
      dst: json['dst'] ?? '',
      prefsrc: json['prefsrc'],
      priority: json['priority'],
      cstamp: json['cstamp'],
      tstamp: json['tstamp'],
      expires: json['expires'],
      error: json['error'],
      used: json['used'],
      pref: json['pref'],
    );
  }

  Map<String, dynamic> toJson() => {
    'table': table,
    'family': family,
    'protocol': protocol,
    'scope': scope,
    'type': type,
    'flags': flags,
    'iflags': iflags,
    'gateway': gateway,
    'oif': oif,
    'dst': dst,
    'prefsrc': prefsrc,
    'priority': priority,
    'cstamp': cstamp,
    'tstamp': tstamp,
    'expires': expires,
    'error': error,
    'used': used,
    'pref': pref,
  };

  @override
  List<Object?> get props => [
    table,
    family,
    protocol,
    scope,
    type,
    flags,
    iflags,
    dst,
    gateway,
    oif,
    prefsrc,
    priority,
    cstamp,
    tstamp,
    expires,
    error,
    used,
    pref,
  ];
}

/// ===============================
/// NETWORK INTERFACE
/// ===============================
class NetworkInterfaceModel extends Equatable {
  final String name;
  final int index;
  final String family;
  final int? speed;
  final String type;
  final List<String> flags;
  final String ifname;
  final int txqlen;
  final String state;
  final int linkmode;
  final int mtu;
  final int minMtu;
  final int maxMtu;
  final int group;
  final int promiscuity;
  final List<int>? unknown;
  final int numTxQueues;
  final int numRxQueues;
  final int gsoMaxSegs;
  final int gsoMaxSize;
  final bool carrier;
  final String qdisc;
  final int carrierChanges;
  final int carrierUpCount;
  final int carrierDownCount;
  final bool protoDown;
  final int map;
  final String address;
  final String broadcast;
  final String? linkKind;
  final int? linkNetnsid;
  final int? link;
  final InterfaceStatsModel stats;
  final List<InterfaceAddressModel> addresses;
  final String? parentDeviceName;
  final String? parentDeviceBusName;

  const NetworkInterfaceModel({
    required this.name,
    required this.index,
    required this.family,
    this.speed,
    required this.type,
    required this.flags,
    required this.ifname,
    required this.txqlen,
    required this.state,
    required this.linkmode,
    required this.mtu,
    required this.minMtu,
    required this.maxMtu,
    required this.group,
    required this.promiscuity,
    this.unknown,
    required this.numTxQueues,
    required this.numRxQueues,
    required this.gsoMaxSegs,
    required this.gsoMaxSize,
    required this.carrier,
    required this.qdisc,
    required this.carrierChanges,
    required this.carrierUpCount,
    required this.carrierDownCount,
    required this.protoDown,
    required this.map,
    required this.address,
    required this.broadcast,
    this.linkKind,
    this.linkNetnsid,
    this.link,
    required this.stats,
    required this.addresses,
    this.parentDeviceName,
    this.parentDeviceBusName,
  });

  factory NetworkInterfaceModel.fromJson(Map<String, dynamic> json) {
    return NetworkInterfaceModel(
      name: json['name'] ?? '',
      index: json['index'] ?? 0,
      family: json['family'] ?? '',
      speed: json['speed'],
      type: json['type'] ?? '',
      flags: List<String>.from(json['flags'] ?? []),
      ifname: json['ifname'] ?? '',
      txqlen: json['txqlen'] ?? 0,
      state: json['state'] ?? '',
      linkmode: json['linkmode'] ?? 0,
      mtu: json['mtu'] ?? 0,
      minMtu: json['min_mtu'] ?? 0,
      maxMtu: json['max_mtu'] ?? 0,
      group: json['group'] ?? 0,
      promiscuity: json['promiscuity'] ?? 0,
      unknown: (json['unknown'] as List<dynamic>?)?.cast<int>(),
      numTxQueues: json['num_tx_queues'] ?? 0,
      numRxQueues: json['num_rx_queues'] ?? 0,
      gsoMaxSegs: json['gso_max_segs'] ?? 0,
      gsoMaxSize: json['gso_max_size'] ?? 0,
      carrier: json['carrier'] ?? false,
      qdisc: json['qdisc'] ?? '',
      carrierChanges: json['carrier_changes'] ?? 0,
      carrierUpCount: json['carrier_up_count'] ?? 0,
      carrierDownCount: json['carrier_down_count'] ?? 0,
      protoDown: json['proto_down'] ?? false,
      map: json['map'] ?? 0,
      address: json['address'] ?? '',
      broadcast: json['broadcast'] ?? '',
      linkKind: json['link_kind'],
      linkNetnsid: json['link_netnsid'],
      link: json['link'],
      stats: InterfaceStatsModel.fromJson(json['stats'] ?? {}),
      addresses: (json['addresses'] as List<dynamic>? ?? [])
          .map((e) => InterfaceAddressModel.fromJson(e))
          .toList(),
      parentDeviceName: json['parent_dev_name'],
      parentDeviceBusName: json['parent_dev_bus_name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'index': index,
    'family': family,
    'speed': speed,
    'type': type,
    'flags': flags,
    'ifname': ifname,
    'txqlen': txqlen,
    'state': state,
    'linkmode': linkmode,
    'mtu': mtu,
    'min_mtu': minMtu,
    'max_mtu': maxMtu,
    'group': group,
    'promiscuity': promiscuity,
    'unknown': unknown,
    'num_tx_queues': numTxQueues,
    'num_rx_queues': numRxQueues,
    'gso_max_segs': gsoMaxSegs,
    'gso_max_size': gsoMaxSize,
    'carrier': carrier,
    'qdisc': qdisc,
    'carrier_changes': carrierChanges,
    'carrier_up_count': carrierUpCount,
    'carrier_down_count': carrierDownCount,
    'proto_down': protoDown,
    'map': map,
    'address': address,
    'broadcast': broadcast,
    'link_kind': linkKind,
    'link_netnsid': linkNetnsid,
    'link': link,
    'stats': stats.toJson(),
    'addresses': addresses.map((e) => e.toJson()).toList(),
    "parent_dev_name": parentDeviceName,
    "parent_dev_bus_name": parentDeviceBusName,
  };

  @override
  List<Object?> get props => [name, index, family, speed, type, ifname];
}

/// ===============================
/// STATS
/// ===============================
class InterfaceStatsModel extends Equatable {
  final TrafficValue rxBytes;
  final TrafficValue txBytes;
  final int bits;
  final int rxPackets;
  final int txPackets;
  final int rxErrors;
  final int txErrors;
  final int rxDropped;
  final int txDropped;
  final int multicast;
  final int collisions;
  final int rxLengthErrors;
  final int rxOverErrors;
  final int rxCrcErrors;
  final int rxFrameErrors;
  final int rxFifoErrors;
  final int rxMissedErrors;
  final int txAbortedErrors;
  final int txCarrierErrors;
  final int txFifoErrors;
  final int txHeartbeatErrors;
  final int txWindowErrors;
  final int rxCompressed;
  final int txCompressed;
  final int rxNohandler;

  const InterfaceStatsModel({
    required this.rxBytes,
    required this.txBytes,
    required this.bits,
    required this.rxPackets,
    required this.txPackets,
    required this.rxErrors,
    required this.txErrors,
    required this.rxDropped,
    required this.txDropped,
    required this.multicast,
    required this.collisions,
    required this.rxLengthErrors,
    required this.rxOverErrors,
    required this.rxCrcErrors,
    required this.rxFrameErrors,
    required this.rxFifoErrors,
    required this.rxMissedErrors,
    required this.txAbortedErrors,
    required this.txCarrierErrors,
    required this.txFifoErrors,
    required this.txHeartbeatErrors,
    required this.txWindowErrors,
    required this.rxCompressed,
    required this.txCompressed,
    required this.rxNohandler,
  });

  factory InterfaceStatsModel.fromJson(Map<String, dynamic> json) {
    return InterfaceStatsModel(
      rxBytes: TrafficValue.fromJson(json['rx_bytes'] ?? {}),
      txBytes: TrafficValue.fromJson(json['tx_bytes'] ?? {}),
      bits: json['bits'] ?? 0,
      rxPackets: json['rx_packets'] ?? 0,
      txPackets: json['tx_packets'] ?? 0,
      rxErrors: json['rx_errors'] ?? 0,
      txErrors: json['tx_errors'] ?? 0,
      rxDropped: json['rx_dropped'] ?? 0,
      txDropped: json['tx_dropped'] ?? 0,
      multicast: json['multicast'] ?? 0,
      collisions: json['collisions'] ?? 0,
      rxLengthErrors: json['rx_length_errors'] ?? 0,
      rxOverErrors: json['rx_over_errors'] ?? 0,
      rxCrcErrors: json['rx_crc_errors'] ?? 0,
      rxFrameErrors: json['rx_frame_errors'] ?? 0,
      rxFifoErrors: json['rx_fifo_errors'] ?? 0,
      rxMissedErrors: json['rx_missed_errors'] ?? 0,
      txAbortedErrors: json['tx_aborted_errors'] ?? 0,
      txCarrierErrors: json['tx_carrier_errors'] ?? 0,
      txFifoErrors: json['tx_fifo_errors'] ?? 0,
      txHeartbeatErrors: json['tx_heartbeat_errors'] ?? 0,
      txWindowErrors: json['tx_window_errors'] ?? 0,
      rxCompressed: json['rx_compressed'] ?? 0,
      txCompressed: json['tx_compressed'] ?? 0,
      rxNohandler: json['rx_nohandler'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'rx_bytes': rxBytes.toJson(),
    'tx_bytes': txBytes.toJson(),
    'bits': bits,
    'rx_packets': rxPackets,
    'tx_packets': txPackets,
    'rx_errors': rxErrors,
    'tx_errors': txErrors,
    'rx_dropped': rxDropped,
    'tx_dropped': txDropped,
    'multicast': multicast,
    'collisions': collisions,
    'rx_length_errors': rxLengthErrors,
    'rx_over_errors': rxOverErrors,
    'rx_crc_errors': rxCrcErrors,
    'rx_frame_errors': rxFrameErrors,
    'rx_fifo_errors': rxFifoErrors,
    'rx_missed_errors': rxMissedErrors,
    'tx_aborted_errors': txAbortedErrors,
    'tx_carrier_errors': txCarrierErrors,
    'tx_fifo_errors': txFifoErrors,
    'tx_heartbeat_errors': txHeartbeatErrors,
    'tx_window_errors': txWindowErrors,
    'rx_compressed': rxCompressed,
    'tx_compressed': txCompressed,
    'rx_nohandler': rxNohandler,
  };

  @override
  List<Object?> get props => [rxBytes, txBytes, bits];
}

/// ===============================
/// TRAFFIC VALUE
/// ===============================
class TrafficValue extends Equatable {
  final double value;
  final String unit;

  const TrafficValue({required this.value, required this.unit});

  factory TrafficValue.fromJson(Map<String, dynamic> json) {
    return TrafficValue(
      value: (json['value'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'value': value, 'unit': unit};

  @override
  List<Object?> get props => [value, unit];
}

/// ===============================
/// INTERFACE ADDRESS
/// ===============================
class InterfaceAddressModel extends Equatable {
  final int index;
  final String family;
  final String scope;
  final List<String> flags;
  final int prefixlen;
  final String address;
  final String? addressType;
  final String? local;
  final String? localType;
  final String? broadcast;
  final String? broadcastType;
  final String label;
  final int prefered;
  final int valid;
  final double cstamp;
  final double tstamp;
  final List<int>? unknown;

  const InterfaceAddressModel({
    required this.index,
    required this.family,
    required this.scope,
    required this.flags,
    required this.prefixlen,
    required this.address,
    this.addressType,
    this.local,
    this.localType,
    this.broadcast,
    this.broadcastType,
    required this.label,
    required this.prefered,
    required this.valid,
    required this.cstamp,
    required this.tstamp,
    this.unknown,
  });

  factory InterfaceAddressModel.fromJson(Map<String, dynamic> json) {
    return InterfaceAddressModel(
      index: json['index'] ?? 0,
      family: json['family'] ?? '',
      scope: json['scope'] ?? '',
      flags: List<String>.from(json['flags'] ?? []),
      prefixlen: json['prefixlen'] ?? 0,
      address: json['address'] ?? '',
      addressType: json['address_type'],
      local: json['local'],
      localType: json['local_type'],
      broadcast: json['broadcast'],
      broadcastType: json['broadcast_type'],
      label: json['label'] ?? '',
      prefered: json['prefered'] ?? 0,
      valid: json['valid'] ?? 0,
      cstamp: (json['cstamp'] as num?)?.toDouble() ?? 0,
      tstamp: (json['tstamp'] as num?)?.toDouble() ?? 0,
      unknown: (json['unknown'] as List<dynamic>?)?.cast<int>(),
    );
  }

  Map<String, dynamic> toJson() => {
    'index': index,
    'family': family,
    'scope': scope,
    'flags': flags,
    'prefixlen': prefixlen,
    'address': address,
    'address_type': addressType,
    'local': local,
    'local_type': localType,
    'broadcast': broadcast,
    'broadcast_type': broadcastType,
    'label': label,
    'prefered': prefered,
    'valid': valid,
    'cstamp': cstamp,
    'tstamp': tstamp,
    'unknown': unknown,
  };

  @override
  List<Object?> get props => [index, family, scope, prefixlen, address, label];
}
