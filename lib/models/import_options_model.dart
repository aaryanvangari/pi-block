import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';

/// Root import configuration options model.
class ImportOptionsModel extends Equatable {
  /// Import Pi-hole configuration
  final bool config;

  /// Import DHCP leases
  final bool dhcpLeases;

  /// Gravity-related import options
  final TeleporterGravityOptions gravity;

  const ImportOptionsModel({
    this.config = false,
    this.dhcpLeases = false,
    this.gravity = const TeleporterGravityOptions(),
  });

  /// Creates an instance from JSON.
  factory ImportOptionsModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(ImportOptionsModel, json);
    return ImportOptionsModel(
      config: json['config'] as bool? ?? false,
      dhcpLeases: json['dhcp_leases'] as bool? ?? false,
      gravity: TeleporterGravityOptions.fromJson(
        json['gravity'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  /// Converts this model to JSON.
  Map<String, dynamic> toJson() {
    return {
      'config': config,
      'dhcp_leases': dhcpLeases,
      'gravity': gravity.toJson(),
    };
  }

  /// Creates a copy with updated fields.
  ImportOptionsModel copyWith({
    bool? config,
    bool? dhcpLeases,
    TeleporterGravityOptions? gravity,
  }) {
    return ImportOptionsModel(
      config: config ?? this.config,
      dhcpLeases: dhcpLeases ?? this.dhcpLeases,
      gravity: gravity ?? this.gravity,
    );
  }

  @override
  List<Object?> get props => [config, dhcpLeases, gravity];
}

/// Gravity-specific import options.
class TeleporterGravityOptions extends Equatable {
  final bool group;
  final bool adlist;
  final bool adlistByGroup;
  final bool domainlist;
  final bool domainlistByGroup;
  final bool client;
  final bool clientByGroup;

  const TeleporterGravityOptions({
    this.group = false,
    this.adlist = false,
    this.adlistByGroup = false,
    this.domainlist = false,
    this.domainlistByGroup = false,
    this.client = false,
    this.clientByGroup = false,
  });

  /// Creates an instance from JSON.
  factory TeleporterGravityOptions.fromJson(Map<String, dynamic> json) {
    return TeleporterGravityOptions(
      group: json['group'] as bool? ?? false,
      adlist: json['adlist'] as bool? ?? false,
      adlistByGroup: json['adlist_by_group'] as bool? ?? false,
      domainlist: json['domainlist'] as bool? ?? false,
      domainlistByGroup: json['domainlist_by_group'] as bool? ?? false,
      client: json['client'] as bool? ?? false,
      clientByGroup: json['client_by_group'] as bool? ?? false,
    );
  }

  /// Converts this model to JSON.
  Map<String, dynamic> toJson() {
    return {
      'group': group,
      'adlist': adlist,
      'adlist_by_group': adlistByGroup,
      'domainlist': domainlist,
      'domainlist_by_group': domainlistByGroup,
      'client': client,
      'client_by_group': clientByGroup,
    };
  }

  /// Creates a copy with updated fields.
  TeleporterGravityOptions copyWith({
    bool? group,
    bool? adlist,
    bool? adlistByGroup,
    bool? domainlist,
    bool? domainlistByGroup,
    bool? client,
    bool? clientByGroup,
  }) {
    return TeleporterGravityOptions(
      group: group ?? this.group,
      adlist: adlist ?? this.adlist,
      adlistByGroup: adlistByGroup ?? this.adlistByGroup,
      domainlist: domainlist ?? this.domainlist,
      domainlistByGroup: domainlistByGroup ?? this.domainlistByGroup,
      client: client ?? this.client,
      clientByGroup: clientByGroup ?? this.clientByGroup,
    );
  }

  @override
  List<Object?> get props => [
        group,
        adlist,
        adlistByGroup,
        domainlist,
        domainlistByGroup,
        client,
        clientByGroup,
      ];
}
