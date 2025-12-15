// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

class SystemModel extends Equatable {
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
      took: (json['took'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {"system": system.toJson(), "took": took};

  SystemModel copyWith({SystemInfo? system, double? took}) =>
      SystemModel(system: system ?? this.system, took: took ?? this.took);

  @override
  List<Object?> get props => [system, took];
}

// ---------------------------------------------------------------------------
// SYSTEM INFO
// ---------------------------------------------------------------------------

class SystemInfo extends Equatable {
  final int uptime;
  final Memory memory;
  final int procs;
  final Cpu cpu;
  final Ftl ftl;

  const SystemInfo({
    required this.uptime,
    required this.memory,
    required this.procs,
    required this.cpu,
    required this.ftl,
  });

  factory SystemInfo.fromJson(Map<String, dynamic> json) => SystemInfo(
    uptime: json['uptime'] ?? 0,
    memory: Memory.fromJson(json['memory']),
    procs: json['procs'] ?? 0,
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

  SystemInfo copyWith({
    int? uptime,
    Memory? memory,
    int? procs,
    Cpu? cpu,
    Ftl? ftl,
  }) => SystemInfo(
    uptime: uptime ?? this.uptime,
    memory: memory ?? this.memory,
    procs: procs ?? this.procs,
    cpu: cpu ?? this.cpu,
    ftl: ftl ?? this.ftl,
  );

  @override
  List<Object?> get props => [uptime, memory, procs, cpu, ftl];
}

// ---------------------------------------------------------------------------
// MEMORY (RAM + SWAP)
// ---------------------------------------------------------------------------

class Memory extends Equatable {
  final Ram ram;
  final Swap swap;

  const Memory({required this.ram, required this.swap});

  factory Memory.fromJson(Map<String, dynamic> json) =>
      Memory(ram: Ram.fromJson(json['ram']), swap: Swap.fromJson(json['swap']));

  Map<String, dynamic> toJson() => {"ram": ram.toJson(), "swap": swap.toJson()};

  Memory copyWith({Ram? ram, Swap? swap}) =>
      Memory(ram: ram ?? this.ram, swap: swap ?? this.swap);

  @override
  List<Object?> get props => [ram, swap];
}

class Ram extends Equatable {
  final int total;
  final int free;
  final int used;
  final int available;
  final double percentUsed;

  const Ram({
    required this.total,
    required this.free,
    required this.used,
    required this.available,
    required this.percentUsed,
  });

  factory Ram.fromJson(Map<String, dynamic> json) => Ram(
    total: json['total'] ?? 0,
    free: json['free'] ?? 0,
    used: json['used'] ?? 0,
    available: json['available'] ?? 0,
    percentUsed: (json['%used'] as num?)?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "free": free,
    "used": used,
    "available": available,
    "%used": percentUsed,
  };

  Ram copyWith({
    int? total,
    int? free,
    int? used,
    int? available,
    double? percentUsed,
  }) => Ram(
    total: total ?? this.total,
    free: free ?? this.free,
    used: used ?? this.used,
    available: available ?? this.available,
    percentUsed: percentUsed ?? this.percentUsed,
  );

  @override
  List<Object?> get props => [total, free, used, available, percentUsed];
}

class Swap extends Equatable {
  final int total;
  final int used;
  final int free;
  final double percentUsed;

  const Swap({
    required this.total,
    required this.used,
    required this.free,
    required this.percentUsed,
  });

  factory Swap.fromJson(Map<String, dynamic> json) => Swap(
    total: json['total'] ?? 0,
    used: json['used'] ?? 0,
    free: json['free'] ?? 0,
    percentUsed: (json['%used'] as num?)?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "used": used,
    "free": free,
    "%used": percentUsed,
  };

  Swap copyWith({int? total, int? used, int? free, double? percentUsed}) =>
      Swap(
        total: total ?? this.total,
        used: used ?? this.used,
        free: free ?? this.free,
        percentUsed: percentUsed ?? this.percentUsed,
      );

  @override
  List<Object?> get props => [total, used, free, percentUsed];
}

// ---------------------------------------------------------------------------
// CPU + LOAD
// ---------------------------------------------------------------------------

class Cpu extends Equatable {
  final int nprocs;
  final double percentCpu;
  final Load load;

  const Cpu({
    required this.nprocs,
    required this.percentCpu,
    required this.load,
  });

  factory Cpu.fromJson(Map<String, dynamic> json) => Cpu(
    nprocs: json['nprocs'] ?? 0,
    percentCpu: (json['%cpu'] as num?)?.toDouble() ?? 0,
    load: Load.fromJson(json['load']),
  );

  Map<String, dynamic> toJson() => {
    "nprocs": nprocs,
    "%cpu": percentCpu,
    "load": load.toJson(),
  };

  Cpu copyWith({int? nprocs, double? percentCpu, Load? load}) => Cpu(
    nprocs: nprocs ?? this.nprocs,
    percentCpu: percentCpu ?? this.percentCpu,
    load: load ?? this.load,
  );

  @override
  List<Object?> get props => [nprocs, percentCpu, load];
}

class Load extends Equatable {
  final List<double> raw;
  final List<double> percent;

  const Load({required this.raw, required this.percent});

  factory Load.fromJson(Map<String, dynamic> json) => Load(
    raw: (json['raw'] as List).map((e) => (e as num).toDouble()).toList(),
    percent: (json['percent'] as List)
        .map((e) => (e as num).toDouble())
        .toList(),
  );

  Map<String, dynamic> toJson() => {"raw": raw, "percent": percent};

  Load copyWith({List<double>? raw, List<double>? percent}) =>
      Load(raw: raw ?? this.raw, percent: percent ?? this.percent);

  @override
  List<Object?> get props => [raw, percent];
}

// ---------------------------------------------------------------------------
// FTL PROCESS INFO
// ---------------------------------------------------------------------------

class Ftl extends Equatable {
  final double percentMem;
  final double percentCpu;

  const Ftl({required this.percentMem, required this.percentCpu});

  factory Ftl.fromJson(Map<String, dynamic> json) => Ftl(
    percentMem: (json['%mem'] as num?)?.toDouble() ?? 0,
    percentCpu: (json['%cpu'] as num?)?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {"%mem": percentMem, "%cpu": percentCpu};

  Ftl copyWith({double? percentMem, double? percentCpu}) => Ftl(
    percentMem: percentMem ?? this.percentMem,
    percentCpu: percentCpu ?? this.percentCpu,
  );

  @override
  List<Object?> get props => [percentMem, percentCpu];
}
