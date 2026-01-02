// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/models/processed_model.dart';

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
    ModelLog.fromJson(DomainUpdateModel, json);
    return DomainUpdateModel(
      domains: (json["domains"] as List)
          .map((e) => DomainModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      processed: Processed.fromJson(json["processed"]),
      took: json["took"] ?? 0,
    );
  }

  DomainUpdateModel copyWith({
    List<DomainModel>? domains,
    Processed? processed,
    double? took,
  }) => DomainUpdateModel(
    domains: domains ?? this.domains,
    processed: processed ?? this.processed,
    took: took ?? this.took,
  );

  @override
  List<Object?> get props => [domains, processed, took];
}
