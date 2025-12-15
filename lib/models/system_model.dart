// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

class SystemModel extends Equatable{
  final SystemInfo system;

  /// Time in seconds it took to process the request
  final double took;

  const SystemModel({required this.system, required this.took});

  factory SystemModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "SystemModel.fromJson",
    );
    return SystemModel(
      system: SystemInfo.fromJson(json['system']),
      took: json['took'],
    );
  }

  Map<String, dynamic> toJson() => {"system": system.toJson(), "took": took};

  @override
  List<Object?> get props => [system, took,];
}

// ---------------------------------------------------------------------------
// SYSTEM INFO
// ---------------------------------------------------------------------------

class SystemInfo extends Equatable{
  /// How long the system has been running (seconds)
  final int uptime;

  /// Memory information (RAM + Swap)
  final Memory memory;

  /// Number of current processes
  final int procs;

  /// CPU information
  final Cpu cpu;

  /// FTL process information
  final Ftl ftl;

  const SystemInfo({
    required this.uptime,
    required this.memory,
    required this.procs,
    required this.cpu,
    required this.ftl,
  });

  factory SystemInfo.fromJson(Map<String, dynamic> json) => SystemInfo(
    uptime: json['uptime'],
    memory: Memory.fromJson(json['memory']),
    procs: json['procs'],
    cpu: Cpu.fromJson(json['cpu']),
    ftl: Ftl.fromJson(json['ftl']),
  );

  Map<String, dynamic> toJson() => {
    "uptime": uptime,
    "memory": memory.toJson(),
    "procs": procs,
    "cpu": cpu.toJson(),
    "ftl": ftl.toJson(),
  };

  @override
  List<Object?> get props => [uptime, memory, procs, cpu, ftl];
}

// ---------------------------------------------------------------------------
// MEMORY (RAM + SWAP)
// ---------------------------------------------------------------------------

class Memory extends Equatable{
  final Ram ram;
  final Swap swap;

  const Memory({required this.ram, required this.swap});

  factory Memory.fromJson(Map<String, dynamic> json) =>
      Memory(ram: Ram.fromJson(json['ram']), swap: Swap.fromJson(json['swap']));

  Map<String, dynamic> toJson() => {"ram": ram.toJson(), "swap": swap.toJson()};

  @override
  List<Object?> get props => [ram, swap,];
}

class Ram extends Equatable{
  /// Total RAM in kilobytes
  final int total;

  /// Total free RAM in kilobytes
  final int free;

  /// Used RAM in kilobytes
  final int used;

  /// Total available RAM in kilobytes
  final int available;

  /// Used RAM percentage
  final double percentUsed;

  const Ram({
    required this.total,
    required this.free,
    required this.used,
    required this.available,
    required this.percentUsed,
  });

  factory Ram.fromJson(Map<String, dynamic> json) => Ram(
    total: json['total'],
    free: json['free'],
    used: json['used'],
    available: json['available'],
    percentUsed: json['%used'].toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "free": free,
    "used": used,
    "available": available,
    "%used": percentUsed,
  };

  @override
  List<Object?> get props => [total, free, used, available, percentUsed];
}

class Swap extends Equatable{
  /// Total swap memory in kilobytes
  final int total;

  /// Used swap memory in kilobytes
  final int used;

  /// Free swap memory in kilobytes
  final int free;

  /// Swap usage percentage
  final double percentUsed;

  const Swap({
    required this.total,
    required this.used,
    required this.free,
    required this.percentUsed,
  });

  factory Swap.fromJson(Map<String, dynamic> json) => Swap(
    total: json['total'],
    used: json['used'],
    free: json['free'],
    percentUsed: json['%used'].toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "used": used,
    "free": free,
    "%used": percentUsed,
  };

  @override
  List<Object?> get props => [total, free, used, percentUsed];
}

// ---------------------------------------------------------------------------
// CPU + LOAD
// ---------------------------------------------------------------------------

class Cpu extends Equatable{
  /// Number of available processors
  final int nprocs;

  /// Total CPU usage (may be >100% on multi-core)
  final double percentCpu;

  /// CPU load values
  final Load load;

  const Cpu({required this.nprocs, required this.percentCpu, required this.load});

  factory Cpu.fromJson(Map<String, dynamic> json) => Cpu(
    nprocs: json['nprocs'],
    percentCpu: json['%cpu'].toDouble() ?? 0,
    load: Load.fromJson(json['load']),
  );

  Map<String, dynamic> toJson() => {
    "nprocs": nprocs,
    "%cpu": percentCpu,
    "load": load.toJson(),
  };

  @override
  List<Object?> get props => [nprocs, percentCpu, load,];
}

class Load extends Equatable{
  /// Raw load averages (1m, 5m, 15m)
  final List<double> raw;

  /// Load averages in percent of CPU capacity
  final List<double> percent;

  const Load({required this.raw, required this.percent});

  factory Load.fromJson(Map<String, dynamic> json) => Load(
    raw: (json['raw'] as List).map((e) => (e as double).toDouble()).toList(),
    percent: (json['percent'] as List)
        .map((e) => (e as double).toDouble())
        .toList(),
  );

  Map<String, dynamic> toJson() => {"raw": raw, "percent": percent};

  @override
  List<Object?> get props => [raw, percent,];
}

// ---------------------------------------------------------------------------
// FTL PROCESS INFO
// ---------------------------------------------------------------------------

class Ftl extends Equatable{
  /// Percentage of total RAM used by FTL
  final double percentMem;

  /// Percentage of total CPU used by FTL
  final double percentCpu;

  const Ftl({required this.percentMem, required this.percentCpu});

  factory Ftl.fromJson(Map<String, dynamic> json) => Ftl(
    percentMem: json['%mem'].toDouble() ?? 0,
    percentCpu: json['%cpu'].toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {"%mem": percentMem, "%cpu": percentCpu};

  @override
  List<Object?> get props => [percentMem, percentCpu,];
}
