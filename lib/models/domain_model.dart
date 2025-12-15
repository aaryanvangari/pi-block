// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

class DomainModel extends Equatable {
  final String domain;
  final String unicode;
  final String type;
  final String kind;
  final String comment;
  final List<int> groups;
  final bool enabled;
  final int id;
  final int date_added;
  final int date_modified;

  const DomainModel({
    required this.domain,
    required this.unicode,
    required this.type,
    required this.kind,
    required this.comment,
    required this.groups,
    required this.enabled,
    required this.id,
    required this.date_added,
    required this.date_modified,
  });

  factory DomainModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "DomainModel.fromJson",
    );
    return DomainModel(
      domain: json["domain"] ?? "",
      unicode: json["unicode"] ?? "",
      type: json["type"] ?? "",
      kind: json["kind"] ?? "",
      comment: json["comment"] ?? "",
      groups: (json['groups'] as List).map((e) => (e as int).toInt()).toList(),
      enabled: json["enabled"] ?? false,
      id: json["id"] ?? 0,
      date_added: json["date_added"] ?? 0,
      date_modified: json["date_modified"] ?? 0,
    );
  }

  /// Returns a copy of this `DomainModel` with the given values updated.
  DomainModel copyWith({
    String? domain,
    String? unicode,
    String? type,
    String? kind,
    String? comment,
    List<int>? groups,
    bool? enabled,
    int? id,
    int? date_added,
    int? date_modified,
  }) {
    return DomainModel(
      domain: domain ?? this.domain,
      unicode: unicode ?? this.unicode,
      type: type ?? this.type,
      kind: kind ?? this.kind,
      comment: comment ?? this.comment,
      groups: groups ?? this.groups,
      enabled: enabled ?? this.enabled,
      id: id ?? this.id,
      date_added: date_added ?? this.date_added,
      date_modified: date_modified ?? this.date_modified,
    );
  }

  @override
  List<Object> get props => [
    domain,
    unicode,
    type,
    kind,
    comment,
    groups,
    enabled,
    id,
    date_added,
    date_modified,
  ];
}
