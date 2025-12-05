// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:logging/logging.dart';

class SystemModel {
  final SystemInfo system;

  /// Time in seconds it took to process the request
  final double took;

  SystemModel({required this.system, required this.took});

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
}

// ---------------------------------------------------------------------------
// SYSTEM INFO
// ---------------------------------------------------------------------------

class SystemInfo {
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

  SystemInfo({
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
}

// ---------------------------------------------------------------------------
// MEMORY (RAM + SWAP)
// ---------------------------------------------------------------------------

class Memory {
  final Ram ram;
  final Swap swap;

  Memory({required this.ram, required this.swap});

  factory Memory.fromJson(Map<String, dynamic> json) =>
      Memory(ram: Ram.fromJson(json['ram']), swap: Swap.fromJson(json['swap']));

  Map<String, dynamic> toJson() => {"ram": ram.toJson(), "swap": swap.toJson()};
}

class Ram {
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

  Ram({
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
    percentUsed: (json['%used'] as double).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "free": free,
    "used": used,
    "available": available,
    "%used": percentUsed,
  };
}

class Swap {
  /// Total swap memory in kilobytes
  final int total;

  /// Used swap memory in kilobytes
  final int used;

  /// Free swap memory in kilobytes
  final int free;

  /// Swap usage percentage
  final double percentUsed;

  Swap({
    required this.total,
    required this.used,
    required this.free,
    required this.percentUsed,
  });

  factory Swap.fromJson(Map<String, dynamic> json) => Swap(
    total: json['total'],
    used: json['used'],
    free: json['free'],
    percentUsed: (json['%used'] as double).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "used": used,
    "free": free,
    "%used": percentUsed,
  };
}

// ---------------------------------------------------------------------------
// CPU + LOAD
// ---------------------------------------------------------------------------

class Cpu {
  /// Number of available processors
  final int nprocs;

  /// Total CPU usage (may be >100% on multi-core)
  final double percentCpu;

  /// CPU load values
  final Load load;

  Cpu({required this.nprocs, required this.percentCpu, required this.load});

  factory Cpu.fromJson(Map<String, dynamic> json) => Cpu(
    nprocs: json['nprocs'],
    percentCpu: (json['%cpu'] as double).toDouble(),
    load: Load.fromJson(json['load']),
  );

  Map<String, dynamic> toJson() => {
    "nprocs": nprocs,
    "%cpu": percentCpu,
    "load": load.toJson(),
  };
}

class Load {
  /// Raw load averages (1m, 5m, 15m)
  final List<double> raw;

  /// Load averages in percent of CPU capacity
  final List<double> percent;

  Load({required this.raw, required this.percent});

  factory Load.fromJson(Map<String, dynamic> json) => Load(
    raw: (json['raw'] as List).map((e) => (e as double).toDouble()).toList(),
    percent: (json['percent'] as List)
        .map((e) => (e as double).toDouble())
        .toList(),
  );

  Map<String, dynamic> toJson() => {"raw": raw, "percent": percent};
}

// ---------------------------------------------------------------------------
// FTL PROCESS INFO
// ---------------------------------------------------------------------------

class Ftl {
  /// Percentage of total RAM used by FTL
  final double percentMem;

  /// Percentage of total CPU used by FTL
  final double percentCpu;

  Ftl({required this.percentMem, required this.percentCpu});

  factory Ftl.fromJson(Map<String, dynamic> json) => Ftl(
    percentMem: (json['%mem'] as double).toDouble(),
    percentCpu: (json['%cpu'] as double).toDouble(),
  );

  Map<String, dynamic> toJson() => {"%mem": percentMem, "%cpu": percentCpu};
}
