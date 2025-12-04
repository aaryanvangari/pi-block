// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:logging/logging.dart';

class DiagnosticMessage {
  final int? id;
  final double? timestamp;
  final String? type;
  final String? plain;
  final String? html;

  DiagnosticMessage({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.plain,
    required this.html,
  });

  factory DiagnosticMessage.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "DiagnosticMessage.fromJson",
    );
    return DiagnosticMessage(
      id: json["id"],
      timestamp: (json["timestamp"]).toDouble(),
      type: json["type"],
      plain: json["plain"],
      html: json["html"],
    );
  }
}
