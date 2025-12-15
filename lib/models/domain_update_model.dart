// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:pi_block/models/domain_model.dart';

class DomainUpdateModel extends Equatable {
  final List<DomainModel> domains;
  final Processed processed;
  final double took;

  const DomainUpdateModel({
    required this.domains,
    required this.processed,
    required this.took,
  });

  factory DomainUpdateModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "DomainUpdateModel.fromJson",
    );
    return DomainUpdateModel(
      domains: (json["domains"] as List)
          .map((e) => DomainModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      processed: Processed.fromJson(json["processed"]),
      took: json["took"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [domains, processed, took];
}

class Processed extends Equatable {
  final List<SuccessItem> success;

  final List<ErrorItem> errors;

  const Processed({required this.success, required this.errors});

  factory Processed.fromJson(Map<String, dynamic> json) => Processed(
    success: (json['success'] as List)
        .map((e) => SuccessItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    errors: (json['errors'] as List)
        .map((e) => ErrorItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {"success": success, "errors": errors};

  @override
  List<Object?> get props => [success, errors];
}

class SuccessItem extends Equatable {
  final String item;

  const SuccessItem({required this.item});

  factory SuccessItem.fromJson(Map<String, dynamic> json) =>
      SuccessItem(item: json['item'] ?? "");

  Map<String, dynamic> toJson() => {"item": item};

  @override
  List<Object?> get props => [item];
}

class ErrorItem extends Equatable {
  final String item;
  final String error;

  const ErrorItem({required this.item, required this.error});

  factory ErrorItem.fromJson(Map<String, dynamic> json) =>
      ErrorItem(item: json['item'] ?? "", error: json['error'] ?? "");

  Map<String, dynamic> toJson() => {"item": item, "error": error};

  @override
  List<Object?> get props => [item, error];
}
