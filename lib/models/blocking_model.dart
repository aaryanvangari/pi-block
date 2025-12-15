// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

class BlockingModel extends Equatable{
  /// The current blocking status
  final BlockingStatus blocking;

  /// The remaining seconds until blocking mode is automatically changed
  final double timer;

  /// Time in seconds it took to process the request
  final double took;

  const BlockingModel({
    required this.blocking,
    required this.timer,
    required this.took,
  });

  factory BlockingModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "BlockingModel.fromJson",
    );
    log(json["timer"].runtimeType.toString());
    return BlockingModel(
      blocking: BlockingStatusExtension.fromJson(json['blocking']),
      // casting timer into int and double based on result otherwise dart throws error of wrong datatype
      timer: (json['timer'] != null) ? json['timer'].toDouble() : 0.0,
      took: json['took'],
    );
  }

  Map<String, dynamic> toJson() => {
    "blocking": blocking.toJson(),
    "timer": timer,
    "took": took,
  };

  @override
  List<Object?> get props => [blocking, timer, took,];
}

// Enum for blocking status
enum BlockingStatus { enabled, disabled, failed, unknown }

extension BlockingStatusExtension on BlockingStatus {
  // Convert enum to string for serialization
  String get value {
    switch (this) {
      case BlockingStatus.enabled:
        return 'enabled';
      case BlockingStatus.disabled:
        return 'disabled';
      case BlockingStatus.failed:
        return 'failed';
      case BlockingStatus.unknown:
        return 'unknown';
    }
  }

  // Convert string to enum for deserialization
  static BlockingStatus fromString(String value) {
    switch (value) {
      case 'enabled':
        return BlockingStatus.enabled;
      case 'disabled':
        return BlockingStatus.disabled;
      case 'failed':
        return BlockingStatus.failed;
      case 'unknown':
        return BlockingStatus.unknown;
      default:
        throw Exception('Unknown BlockingStatus value: $value');
    }
  }

  // Convert enum to JSON string
  String toJson() => value;

  // Convert JSON string to enum
  static BlockingStatus fromJson(String json) => fromString(json);
}
