import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';

/// Represents the result of an import/process operation.
class ImportConfigModel extends Equatable {
  /// List of items that were successfully processed.
  final List<String> processed;

  /// Time in seconds it took to process the request.
  final double took;

  /// Default / empty constructor.
  const ImportConfigModel({
    this.processed = const [],
    this.took = 0.0,
  });

  /// Creates a new instance from JSON.
  factory ImportConfigModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(ImportConfigModel, json);
    return ImportConfigModel(
      processed: (json['processed'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      took: (json['took'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts this model to JSON.
  Map<String, dynamic> toJson() {
    return {
      'processed': processed,
      'took': took,
    };
  }

  /// Creates a copy with updated fields.
  ImportConfigModel copyWith({
    List<String>? processed,
    double? took,
  }) {
    return ImportConfigModel(
      processed: processed ?? this.processed,
      took: took ?? this.took,
    );
  }

  @override
  List<Object?> get props => [processed, took];
}
