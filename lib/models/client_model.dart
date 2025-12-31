// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';

/// ------------------------------------------------------------
/// Client model
/// ------------------------------------------------------------
class ClientModel extends Equatable {
  /// Client IP / MAC / hostname / interface
  final String client;

  /// Optional user-provided comment
  final String comment;

  /// Group IDs this client belongs to
  final List<int> groups;

  /// Database ID
  final int id;

  /// Unix timestamp of item addition
  final int date_added;

  /// Unix timestamp of last item modification
  final int date_modified;

  /// Hostname (if available)
  final String name;

  const ClientModel({
    this.client = '',
    this.comment = '',
    this.groups = const [],
    this.id = 0,
    this.date_added = 0,
    this.date_modified = 0,
    this.name = '',
  });

  /// Empty client
  factory ClientModel.empty() => const ClientModel();

  /// Create from JSON
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(ClientModel, json);
    return ClientModel(
      client: json['client'] as String? ?? '',
      comment: json['comment'] as String,
      groups:
          (json['groups'] as List<dynamic>?)?.map((e) => e as int).toList() ??
          const [],
      id: json['id'] as int? ?? 0,
      date_added: json['date_added'] as int? ?? 0,
      date_modified: json['date_modified'] as int? ?? 0,
      name: json['name'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'client': client,
      'comment': comment,
      'groups': groups,
      'id': id,
      'date_added': date_added,
      'date_modified': date_modified,
      'name': name,
    };
  }

  /// Copy with
  ClientModel copyWith({
    String? client,
    String? comment,
    List<int>? groups,
    int? id,
    int? date_added,
    int? date_modified,
    String? name,
  }) {
    return ClientModel(
      client: client ?? this.client,
      comment: comment ?? this.comment,
      groups: groups ?? this.groups,
      id: id ?? this.id,
      date_added: date_added ?? this.date_added,
      date_modified: date_modified ?? this.date_modified,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [
    client,
    comment,
    groups,
    id,
    date_added,
    date_modified,
    name,
  ];
}
