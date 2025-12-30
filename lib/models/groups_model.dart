// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';

/// Root response model
class GroupsModel extends Equatable {
  /// List of groups
  final List<GroupModel> groups;

  /// Time in seconds it took to process the request
  final double took;

  const GroupsModel({required this.groups, required this.took});

  factory GroupsModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(GroupsModel, json);
    return GroupsModel(
      groups: (json['groups'] as List<dynamic>? ?? [])
          .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      took: (json['took'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'groups': groups.map((e) => e.toJson()).toList(),
    'took': took,
  };

  GroupsModel copyWith({List<GroupModel>? groups, double? took}) {
    return GroupsModel(groups: groups ?? this.groups, took: took ?? this.took);
  }

  @override
  List<Object?> get props => [groups, took];
}

/// Group model
class GroupModel extends Equatable {
  /// Group name
  final String name;

  /// User-provided free-text comment for this group
  /// Default: null
  final String comment;

  /// Status of item
  /// Default: true
  final bool enabled;

  /// Database ID
  final int id;

  /// Unix timestamp of item addition
  final int date_added;

  /// Unix timestamp of last item modification
  final int date_modified;

  const GroupModel({
    this.name = "",
    this.comment = "",
    this.enabled = false,
    this.id = 0,
    this.date_added = 0,
    this.date_modified = 0,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      name: json['name'] as String,
      comment: json['comment'] as String,
      enabled: json['enabled'] as bool? ?? true,
      id: json['id'] as int,
      date_added: json['date_added'] as int,
      date_modified: json['date_modified'] as int,
    );
  }

  /// used in group dropdown in domains, lists and other pages
  @override
  String toString() {
    return name;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'comment': comment,
    'enabled': enabled,
    'id': id,
    'date_added': date_added,
    'date_modified': date_modified,
  };

  GroupModel copyWith({
    String? name,
    String? comment,
    bool? enabled,
    int? id,
    int? date_added,
    int? date_modified,
  }) {
    return GroupModel(
      name: name ?? this.name,
      comment: comment ?? this.comment,
      enabled: enabled ?? this.enabled,
      id: id ?? this.id,
      date_added: date_added ?? this.date_added,
      date_modified: date_modified ?? this.date_modified,
    );
  }

  @override
  List<Object?> get props => [
    name,
    comment,
    enabled,
    id,
    date_added,
    date_modified,
  ];
}

