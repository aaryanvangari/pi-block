// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:logging/logging.dart';

class ListsModel {
  final String address;
  final String comment;
  final List<int> groups;
  final bool enabled;
  final int id;
  final int date_added;
  final int date_modified;
  final String type;
  final int date_updated;
  final int number;
  final int invalid_domains;
  final int abp_entries;
  final int status;

  ListsModel({
    required this.address,
    required this.comment,
    required this.groups,
    required this.enabled,
    required this.id,
    required this.date_added,
    required this.date_modified,
    required this.type,
    required this.date_updated,
    required this.number,
    required this.invalid_domains,
    required this.abp_entries,
    required this.status,
  });

  factory ListsModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "ListsModel.fromJson",
    );
    return ListsModel(
      address: json["address"] ?? "",
      comment: json["comment"] ?? "",
      groups: (json['groups'] as List).map((e) => (e as int).toInt()).toList(),
      enabled: json["enabled"] ?? false,
      id: json["id"] ?? 0,
      date_added: json["date_added"] ?? 0,
      date_modified: json["date_modified"] ?? 0,
      type: json["type"] ?? "",
      date_updated: json["date_updated"] ?? 0,
      number: json["number"] ?? 0,
      invalid_domains: json["invalid_domains"] ?? 0,
      abp_entries: json["abp_entries"] ?? 0,
      status: json["status"] ?? 0,
    );
  }
}
