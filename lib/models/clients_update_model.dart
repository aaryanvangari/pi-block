// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';
import 'package:pi_block/models/client_model.dart';
import 'package:pi_block/models/processed_model.dart';

/// ------------------------------------------------------------
/// Root response model
/// ------------------------------------------------------------
class ClientsUpdateModel extends Equatable {
  /// List of client objects returned by the API
  final List<ClientModel> clients;

  /// Processing result (can be null)
  final Processed? processed;

  /// Time in seconds taken to process the request
  final double took;

  const ClientsUpdateModel({
    this.clients = const [],
    this.processed,
    this.took = 0.0,
  });

  /// Empty object
  factory ClientsUpdateModel.empty() => const ClientsUpdateModel();

  /// Create from JSON
  factory ClientsUpdateModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(ClientsUpdateModel, json);
    return ClientsUpdateModel(
      clients:
          (json['clients'] as List<dynamic>?)
              ?.map((e) => ClientModel.fromJson(e))
              .toList() ??
          const [],
      processed: json['processed'] != null
          ? Processed.fromJson(json['processed'])
          : null,
      took: (json['took'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'clients': clients.map((e) => e.toJson()).toList(),
      'processed': processed?.toJson(),
      'took': took,
    };
  }

  /// Copy with
  ClientsUpdateModel copyWith({
    List<ClientModel>? clients,
    Processed? processed,
    double? took,
  }) {
    return ClientsUpdateModel(
      clients: clients ?? this.clients,
      processed: processed ?? this.processed,
      took: took ?? this.took,
    );
  }

  @override
  List<Object?> get props => [clients, processed, took];
}
