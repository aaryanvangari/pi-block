import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';

/// ------------------------------------------------------------
/// Root response model
/// ------------------------------------------------------------
class ClientsSuggestionModel extends Equatable {
  /// List of client activity records
  final List<ClientSuggestionModel> clients;

  /// Time in seconds it took to process the request
  final double took;

  const ClientsSuggestionModel({this.clients = const [], this.took = 0.0});

  /// Empty response
  factory ClientsSuggestionModel.empty() => const ClientsSuggestionModel();

  /// Create from JSON
  factory ClientsSuggestionModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(ClientsSuggestionModel, json);
    return ClientsSuggestionModel(
      clients:
          (json['clients'] as List<dynamic>?)
              ?.map((e) => ClientSuggestionModel.fromJson(e))
              .toList() ??
          const [],
      took: (json['took'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'clients': clients.map((e) => e.toJson()).toList(), 'took': took};
  }

  /// Copy with
  ClientsSuggestionModel copyWith({
    List<ClientSuggestionModel>? clients,
    double? took,
  }) {
    return ClientsSuggestionModel(
      clients: clients ?? this.clients,
      took: took ?? this.took,
    );
  }

  @override
  List<Object?> get props => [clients, took];
}

/// ------------------------------------------------------------
/// Client activity model
/// ------------------------------------------------------------
class ClientSuggestionModel extends Equatable {
  /// Hardware (MAC) address of the client
  final String? hwaddr;

  /// Vendor resolved from MAC address
  final String? macVendor;

  /// Unix timestamp of the last query from this client
  final int lastQuery;

  /// Comma-separated list of IP addresses
  final String? addresses;

  /// Comma-separated list of hostnames (if available)
  final String? names;

  const ClientSuggestionModel({
    this.hwaddr,
    this.macVendor,
    this.lastQuery = 0,
    this.addresses,
    this.names,
  });

  /// Empty model
  factory ClientSuggestionModel.empty() => const ClientSuggestionModel();

  /// Create from JSON
  factory ClientSuggestionModel.fromJson(Map<String, dynamic> json) {
    return ClientSuggestionModel(
      hwaddr: json['hwaddr'] as String?,
      macVendor: json['macVendor'] as String?,
      lastQuery: json['lastQuery'] as int? ?? 0,
      addresses: json['addresses'] as String?,
      names: json['names'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'hwaddr': hwaddr,
      'macVendor': macVendor,
      'lastQuery': lastQuery,
      'addresses': addresses,
      'names': names,
    };
  }

  /// This is custom format for displaying clients
  /// in a presentable format.
  @override
  String toString() {
    if (names != null && names!.isNotEmpty) {
      return addresses != null && addresses!.isNotEmpty
          ? '$names ($addresses)'
          : names!;
    }
    return hwaddr ?? "";
  }

  /// Copy with
  ClientSuggestionModel copyWith({
    String? hwaddr,
    String? macVendor,
    int? lastQuery,
    String? addresses,
    String? names,
  }) {
    return ClientSuggestionModel(
      hwaddr: hwaddr ?? this.hwaddr,
      macVendor: macVendor ?? this.macVendor,
      lastQuery: lastQuery ?? this.lastQuery,
      addresses: addresses ?? this.addresses,
      names: names ?? this.names,
    );
  }

  @override
  List<Object?> get props => [hwaddr, macVendor, lastQuery, addresses, names];
}
