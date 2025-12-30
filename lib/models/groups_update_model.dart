import 'package:equatable/equatable.dart';
import 'package:pi_block/models/groups_model.dart';
import 'package:pi_block/models/processed_model.dart';

/// ===============================
/// Root response model
/// ===============================
class GroupUpdateModel extends Equatable {
  /// List of groups
  final List<GroupModel> groups;

  /// Processing result (nullable)
  final Processed? processed;

  /// Time in seconds it took to process the request
  final double took;

  const GroupUpdateModel({
    required this.groups,
    required this.processed,
    required this.took,
  });

  factory GroupUpdateModel.fromJson(Map<String, dynamic> json) {
    return GroupUpdateModel(
      groups: (json['groups'] as List<dynamic>? ?? [])
          .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      processed: json['processed'] != null
          ? Processed.fromJson(json['processed'] as Map<String, dynamic>)
          : null,
      took: (json['took'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'groups': groups.map((e) => e.toJson()).toList(),
    'processed': processed?.toJson(),
    'took': took,
  };

  GroupUpdateModel copyWith({
    List<GroupModel>? groups,
    Processed? processed,
    double? took,
  }) {
    return GroupUpdateModel(
      groups: groups ?? this.groups,
      processed: processed ?? this.processed,
      took: took ?? this.took,
    );
  }

  @override
  List<Object?> get props => [groups, processed, took];
}

