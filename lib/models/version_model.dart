// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

class VersionModel extends Equatable {
  final Version version;

  /// Time in seconds it took to process the request
  final double took;

  const VersionModel({required this.version, required this.took});

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "VersionModel.fromJson",
    );
    return VersionModel(
      version: Version.fromJson(json['version']),
      took: (json['took'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {"version": version.toJson(), "took": took};

  VersionModel copyWith({Version? version, double? took}) =>
      VersionModel(version: version ?? this.version, took: took ?? this.took);

  @override
  List<Object?> get props => [version, took];
}

/// -------------------- Version --------------------
class Version extends Equatable {
  final Component core;
  final Component web;
  final ComponentFtl ftl;
  final Docker docker;

  const Version({
    required this.core,
    required this.web,
    required this.ftl,
    required this.docker,
  });

  factory Version.fromJson(Map<String, dynamic> json) => Version(
    core: Component.fromJson(json['core']),
    web: Component.fromJson(json['web']),
    ftl: ComponentFtl.fromJson(json['ftl']),
    docker: Docker.fromJson(json['docker']),
  );

  Map<String, dynamic> toJson() => {
    "core": core.toJson(),
    "web": web.toJson(),
    "ftl": ftl.toJson(),
    "docker": docker.toJson(),
  };

  Version copyWith({
    Component? core,
    Component? web,
    ComponentFtl? ftl,
    Docker? docker,
  }) => Version(
    core: core ?? this.core,
    web: web ?? this.web,
    ftl: ftl ?? this.ftl,
    docker: docker ?? this.docker,
  );

  @override
  List<Object?> get props => [core, web, ftl, docker];
}

/// -------------------- Component (Core/Web) --------------------
class Component extends Equatable {
  final LocalComponent local;
  final RemoteComponent remote;

  const Component({required this.local, required this.remote});

  factory Component.fromJson(Map<String, dynamic> json) => Component(
    local: LocalComponent.fromJson(json['local']),
    remote: RemoteComponent.fromJson(json['remote']),
  );

  Map<String, dynamic> toJson() => {
    "local": local.toJson(),
    "remote": remote.toJson(),
  };

  Component copyWith({LocalComponent? local, RemoteComponent? remote}) =>
      Component(local: local ?? this.local, remote: remote ?? this.remote);

  @override
  List<Object?> get props => [local, remote];
}

class LocalComponent extends Equatable {
  final String branch;
  final String version;
  final String hash;

  const LocalComponent({
    required this.branch,
    required this.version,
    required this.hash,
  });

  factory LocalComponent.fromJson(Map<String, dynamic> json) => LocalComponent(
    branch: json['branch'] ?? "",
    version: json['version'] ?? "",
    hash: json['hash'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "branch": branch,
    "version": version,
    "hash": hash,
  };

  LocalComponent copyWith({String? branch, String? version, String? hash}) =>
      LocalComponent(
        branch: branch ?? this.branch,
        version: version ?? this.version,
        hash: hash ?? this.hash,
      );

  @override
  List<Object?> get props => [branch, version, hash];
}

class RemoteComponent extends Equatable {
  final String version;
  final String hash;

  const RemoteComponent({required this.version, required this.hash});

  factory RemoteComponent.fromJson(Map<String, dynamic> json) =>
      RemoteComponent(version: json['version'] ?? "", hash: json['hash'] ?? "");

  Map<String, dynamic> toJson() => {"version": version, "hash": hash};

  RemoteComponent copyWith({String? version, String? hash}) => RemoteComponent(
    version: version ?? this.version,
    hash: hash ?? this.hash,
  );

  @override
  List<Object?> get props => [version, hash];
}

/// -------------------- FTL Component --------------------
class ComponentFtl extends Equatable {
  final LocalFtl local;
  final RemoteComponent remote;

  const ComponentFtl({required this.local, required this.remote});

  factory ComponentFtl.fromJson(Map<String, dynamic> json) => ComponentFtl(
    local: LocalFtl.fromJson(json['local']),
    remote: RemoteComponent.fromJson(json['remote']),
  );

  Map<String, dynamic> toJson() => {
    "local": local.toJson(),
    "remote": remote.toJson(),
  };

  ComponentFtl copyWith({LocalFtl? local, RemoteComponent? remote}) =>
      ComponentFtl(local: local ?? this.local, remote: remote ?? this.remote);

  @override
  List<Object?> get props => [local, remote];
}

class LocalFtl extends Equatable {
  final String branch;
  final String version;
  final String hash;
  final String date;

  const LocalFtl({
    required this.branch,
    required this.version,
    required this.hash,
    required this.date,
  });

  factory LocalFtl.fromJson(Map<String, dynamic> json) => LocalFtl(
    branch: json['branch'] ?? "",
    version: json['version'] ?? "",
    hash: json['hash'] ?? "",
    date: json['date'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "branch": branch,
    "version": version,
    "hash": hash,
    "date": date,
  };

  LocalFtl copyWith({
    String? branch,
    String? version,
    String? hash,
    String? date,
  }) => LocalFtl(
    branch: branch ?? this.branch,
    version: version ?? this.version,
    hash: hash ?? this.hash,
    date: date ?? this.date,
  );

  @override
  List<Object?> get props => [branch, version, hash, date];
}

/// -------------------- Docker --------------------
class Docker extends Equatable {
  final String local;
  final String remote;

  const Docker({required this.local, required this.remote});

  factory Docker.fromJson(Map<String, dynamic> json) =>
      Docker(local: json['local'] ?? "", remote: json['remote'] ?? "");

  Map<String, dynamic> toJson() => {"local": local, "remote": remote};

  Docker copyWith({String? local, String? remote}) =>
      Docker(local: local ?? this.local, remote: remote ?? this.remote);

  @override
  List<Object?> get props => [local, remote];
}
