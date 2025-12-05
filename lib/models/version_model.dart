// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:logging/logging.dart';

class VersionModel {
  final Version version;

  /// Time in seconds it took to process the request
  final double took;

  VersionModel({required this.version, required this.took});

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "VersionModel.fromJson",
    );
    return VersionModel(
      version: Version.fromJson(json['version']),
      took: json['took'],
    );
  }

  Map<String, dynamic> toJson() => {"version": version.toJson(), "took": took};
}

/// -------------------- Version --------------------
class Version {
  final Component core;
  final Component web;
  final ComponentFtl ftl;
  final Docker docker;

  Version({
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
}

/// -------------------- Component (Core/Web) --------------------
class Component {
  final LocalComponent local;
  final RemoteComponent remote;

  Component({required this.local, required this.remote});

  factory Component.fromJson(Map<String, dynamic> json) => Component(
    local: LocalComponent.fromJson(json['local']),
    remote: RemoteComponent.fromJson(json['remote']),
  );

  Map<String, dynamic> toJson() => {
    "local": local.toJson(),
    "remote": remote.toJson(),
  };
}

class LocalComponent {
  /// Local branch (null if not available)
  final String branch;

  /// Local version (null if not available)
  final String version;

  /// Local hash (null if not available)
  final String hash;

  LocalComponent({
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
}

class RemoteComponent {
  /// Remote version (null if on custom branch)
  final String version;

  /// Remote hash (null if not available)
  final String hash;

  RemoteComponent({required this.version, required this.hash});

  factory RemoteComponent.fromJson(Map<String, dynamic> json) =>
      RemoteComponent(version: json['version'] ?? "", hash: json['hash'] ?? "");

  Map<String, dynamic> toJson() => {"version": version, "hash": hash};
}

/// -------------------- FTL Component --------------------
class ComponentFtl {
  final LocalFtl local;
  final RemoteComponent remote;

  ComponentFtl({required this.local, required this.remote});

  factory ComponentFtl.fromJson(Map<String, dynamic> json) => ComponentFtl(
    local: LocalFtl.fromJson(json['local']),
    remote: RemoteComponent.fromJson(json['remote']),
  );

  Map<String, dynamic> toJson() => {
    "local": local.toJson(),
    "remote": remote.toJson(),
  };
}

class LocalFtl {
  /// Local Pi-hole FTL branch
  final String branch;

  /// Local Pi-hole FTL version
  final String version;

  /// Local Pi-hole FTL hash
  final String hash;

  /// Build time of your local Pi-hole FTL
  final String date;

  LocalFtl({
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
}

/// -------------------- Docker --------------------
class Docker {
  /// Local Pi-hole Docker image version (null if not running in Docker)
  final String local;

  /// Remote (Docker Hub) Pi-hole Docker image version (null if not running in Docker)
  final String remote;

  Docker({required this.local, required this.remote});

  factory Docker.fromJson(Map<String, dynamic> json) =>
      Docker(local: json['local'] ?? "", remote: json['remote'] ?? "");

  Map<String, dynamic> toJson() => {"local": local, "remote": remote};
}
