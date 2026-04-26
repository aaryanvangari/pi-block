import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';

/// Represents the API response containing devices and request timing
class NetworkDevicesModel extends Equatable {
  /// List of devices returned by the API
  final List<Device> devices;

  /// Time in seconds taken to process the request
  final double took;

  /// Empty constructor
  const NetworkDevicesModel({this.devices = const [], this.took = 0.0});

  /// Create instance from JSON
  factory NetworkDevicesModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(NetworkDevicesModel, json);
    return NetworkDevicesModel(
      devices: (json['devices'] as List<dynamic>? ?? [])
          .map((e) => Device.fromJson(e as Map<String, dynamic>))
          .toList(),
      took: (json['took'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {'devices': devices.map((e) => e.toJson()).toList(), 'took': took};
  }

  /// Creates a copy of this object with the given fields replaced
  NetworkDevicesModel copyWith({List<Device>? devices, double? took}) {
    return NetworkDevicesModel(
      devices: devices ?? this.devices,
      took: took ?? this.took,
    );
  }

  @override
  List<Object?> get props => [devices, took];
}

/// Device model
/// Represents a single network device known to Pi-hole
class Device extends Equatable {
  /// Device network table ID
  final int id;

  /// MAC address of the device
  final String hwaddr;

  /// Interface the device is connected to
  final String interfaceName;

  /// Unix timestamp when the device was first seen
  final int firstSeen;

  /// Unix timestamp of the last query from this device
  final int lastQuery;

  /// Total number of queries received from this device
  final int numQueries;

  /// Vendor name associated with the MAC address (can be null)
  final String? macVendor;

  /// List of associated IP addresses
  final List<DeviceIp> ips;

  /// Empty constructor
  const Device({
    this.id = 0,
    this.hwaddr = '',
    this.interfaceName = '',
    this.firstSeen = 0,
    this.lastQuery = 0,
    this.numQueries = 0,
    this.macVendor,
    this.ips = const [],
  });

  /// Create instance from JSON
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] ?? 0,
      hwaddr: json['hwaddr'] ?? '',
      interfaceName: json['interface'] ?? '',
      firstSeen: json['firstSeen'] ?? 0,
      lastQuery: json['lastQuery'] ?? 0,
      numQueries: json['numQueries'] ?? 0,
      macVendor: json['macVendor'],
      ips: (json['ips'] as List<dynamic>? ?? [])
          .map((e) => DeviceIp.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hwaddr': hwaddr,
      'interface': interfaceName,
      'firstSeen': firstSeen,
      'lastQuery': lastQuery,
      'numQueries': numQueries,
      'macVendor': macVendor,
      'ips': ips.map((e) => e.toJson()).toList(),
    };
  }

  /// Creates a copy of this object with the given fields replaced
  Device copyWith({
    int? id,
    String? hwaddr,
    String? interfaceName,
    int? firstSeen,
    int? lastQuery,
    int? numQueries,
    String? macVendor,
    List<DeviceIp>? ips,
  }) {
    return Device(
      id: id ?? this.id,
      hwaddr: hwaddr ?? this.hwaddr,
      interfaceName: interfaceName ?? this.interfaceName,
      firstSeen: firstSeen ?? this.firstSeen,
      lastQuery: lastQuery ?? this.lastQuery,
      numQueries: numQueries ?? this.numQueries,
      macVendor: macVendor ?? this.macVendor,
      ips: ips ?? this.ips,
    );
  }

  @override
  List<Object?> get props => [
    id,
    hwaddr,
    interfaceName,
    firstSeen,
    lastQuery,
    numQueries,
    macVendor,
    ips,
  ];
}

/// Device IP model
/// Represents an IP address associated with a device
class DeviceIp extends Equatable {
  /// IP address (IPv4 or IPv6)
  final String ip;

  /// Hostname associated with the IP (can be null)
  final String? name;

  /// Unix timestamp when this IP was last seen
  final int lastSeen;

  /// Unix timestamp when hostname was last updated
  final int nameUpdated;

  /// Empty constructor
  const DeviceIp({
    this.ip = '',
    this.name,
    this.lastSeen = 0,
    this.nameUpdated = 0,
  });

  /// Create instance from JSON
  factory DeviceIp.fromJson(Map<String, dynamic> json) {
    return DeviceIp(
      ip: json['ip'] ?? '',
      name: json['name'],
      lastSeen: json['lastSeen'] ?? 0,
      nameUpdated: json['nameUpdated'] ?? 0,
    );
  }

  /// Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'name': name,
      'lastSeen': lastSeen,
      'nameUpdated': nameUpdated,
    };
  }

  /// Creates a copy of this object with the given fields replaced
  DeviceIp copyWith({
    String? ip,
    String? name,
    int? lastSeen,
    int? nameUpdated,
  }) {
    return DeviceIp(
      ip: ip ?? this.ip,
      name: name ?? this.name,
      lastSeen: lastSeen ?? this.lastSeen,
      nameUpdated: nameUpdated ?? this.nameUpdated,
    );
  }

  @override
  List<Object?> get props => [ip, name, lastSeen, nameUpdated];
}
