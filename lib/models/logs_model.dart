import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';
import 'package:pi_block/models/log_model.dart';

class LogsModel extends Equatable {
  final List<LogModel> log;
  final int nextID;
  final int pid;
  final String file;
  final double took;

  const LogsModel({
    required this.log,
    required this.nextID,
    required this.pid,
    required this.file,
    required this.took,
  });

  factory LogsModel.empty() {
    return const LogsModel(
      log: [],
      nextID: 0,
      pid: 0,
      file: '',
      took: 0.0,
    );
  }

  bool get isEmpty =>
      log.isEmpty &&
      nextID == 0 &&
      pid == 0 &&
      file.isEmpty &&
      took == 0.0;

  factory LogsModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(LogsModel, json);
    return LogsModel(
      log: (json['log'] as List<dynamic>? ?? [])
          .map((e) => LogModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextID: json['nextID'] as int? ?? 0,
      pid: json['pid'] as int? ?? 0,
      file: json['file'] as String? ?? '',
      took: (json['took'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'log': log.map((e) => e.toJson()).toList(),
      'nextID': nextID,
      'pid': pid,
      'file': file,
      'took': took,
    };
  }

  LogsModel copyWith({
    List<LogModel>? log,
    int? nextID,
    int? pid,
    String? file,
    double? took,
  }) {
    return LogsModel(
      log: log ?? this.log,
      nextID: nextID ?? this.nextID,
      pid: pid ?? this.pid,
      file: file ?? this.file,
      took: took ?? this.took,
    );
  }

  @override
  List<Object?> get props => [log, nextID, pid, file, took];
}
