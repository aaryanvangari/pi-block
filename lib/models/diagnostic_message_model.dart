// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

class DiagnosticMessageModel extends Equatable{
  final int id;
  final double timestamp;
  final String type;
  final String plain;
  final String html;

  const DiagnosticMessageModel({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.plain,
    required this.html,
  });

  factory DiagnosticMessageModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "DiagnosticMessageModel.fromJson",
    );
    return DiagnosticMessageModel(
      id: json["id"] ?? 0,
      timestamp: json["timestamp"].toDouble() ?? 0,
      type: json["type"] ?? "",
      plain: json["plain"] ?? "",
      html: json["html"] ?? "",
    );
  }

  DiagnosticMessageModel copyWith({
    int? id,
    double? timestamp,
    String? type,
    String? plain,
    String? html,
  }) => DiagnosticMessageModel(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    type: type ?? this.type,
    plain: plain ?? this.plain,
    html: html ?? this.html,
  );

  @override
  List<Object> get props => [id, timestamp, type, plain, html];
}
