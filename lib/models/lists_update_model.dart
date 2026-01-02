// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';
import 'package:pi_block/models/lists_model.dart';
import 'package:pi_block/models/processed_model.dart';

/// Response model for list update operations
class ListUpdateModel extends Equatable {
  /// Lists involved in the update operation
  final List<ListsModel> lists;

  /// Processing results (successes and errors)
  final Processed processed;

  /// Time in seconds it took to process the request
  final double took;

  const ListUpdateModel({
    required this.lists,
    required this.processed,
    required this.took,
  });

  factory ListUpdateModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(ListUpdateModel, json);
    return ListUpdateModel(
      lists: (json["lists"] as List)
          .map((e) => ListsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      processed: Processed.fromJson(json["processed"]),
      took: (json["took"] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "lists": lists.map((e) => e.toJson()).toList(),
    "processed": processed.toJson(),
    "took": took,
  };

  /// Creates a modified copy of this object
  ListUpdateModel copyWith({
    List<ListsModel>? lists,
    Processed? processed,
    double? took,
  }) => ListUpdateModel(
    lists: lists ?? this.lists,
    processed: processed ?? this.processed,
    took: took ?? this.took,
  );

  @override
  List<Object?> get props => [lists, processed, took];
}
