// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:logging/logging.dart';

class DomainModel {
  final String? domain;
  final String? unicode;
  final String? type;
  final String? kind;
  final String? comment;
  final List<dynamic>? groups;
  final bool? enabled;
  final int? id;
  final int? date_added;
  final int? date_modified;

  DomainModel({
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
    log(json.toString(), level: Level.FINEST.value, name: "DomainModel.fromJson");
    return DomainModel(
      domain: json["domain"],
      unicode: json["unicode"],
      type: json["type"],
      kind: json["kind"],
      comment: json["comment"] ?? "",
      groups: json["groups"],
      enabled: json["enabled"],
      id: json["id"],
      date_added: json["date_added"],
      date_modified: json["date_modified"],
    );
  }
}
