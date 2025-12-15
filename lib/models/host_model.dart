// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

class HostModel extends Equatable{
  /// Host details including uname, model, and DMI info
  final Host host;

  /// Time in seconds it took to process the request
  final double took;

  const HostModel({required this.host, required this.took});

  factory HostModel.fromJson(Map<String, dynamic> json) {
    log(json.toString(), level: Level.FINEST.value, name: "HostModel.fromJson");
    return HostModel(host: Host.fromJson(json['host']), took: json['took']);
  }

  Map<String, dynamic> toJson() => {"host": host.toJson(), "took": took};

  @override
  List<Object?> get props => [
    host,
    took
  ];
}

class Host extends Equatable{
  /// uname information
  final Uname uname;

  /// Device model (if available, null otherwise)
  final String model;

  /// DMI information (BIOS, board, product, system)
  final Dmi dmi;

  const Host({required this.uname, required this.model, required this.dmi});

  factory Host.fromJson(Map<String, dynamic> json) => Host(
    uname: Uname.fromJson(json['uname']),
    model: json['model'] ?? "",
    dmi: Dmi.fromJson(json['dmi']),
  );

  Map<String, dynamic> toJson() => {
    "uname": uname.toJson(),
    "model": model,
    "dmi": dmi.toJson(),
  };

  @override
  List<Object?> get props => [
    uname,
    model,
    dmi
  ];
}

/// -------------------- Uname --------------------
class Uname extends Equatable{
  final String domainname;
  final String machine;
  final String nodename;
  final String release;
  final String sysname;
  final String version;

  const Uname({
    required this.domainname,
    required this.machine,
    required this.nodename,
    required this.release,
    required this.sysname,
    required this.version,
  });

  factory Uname.fromJson(Map<String, dynamic> json) => Uname(
    domainname: json['domainname'] ?? "",
    machine: json['machine'] ?? "",
    nodename: json['nodename'] ?? "",
    release: json['release'] ?? "",
    sysname: json['sysname'] ?? "",
    version: json['version'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "domainname": domainname,
    "machine": machine,
    "nodename": nodename,
    "release": release,
    "sysname": sysname,
    "version": version,
  };

  @override
  List<Object?> get props => [
    domainname,
    machine,
    nodename,
    release,
    sysname,
    version,
  ];
}

/// -------------------- DMI --------------------
class Dmi extends Equatable{
  final Bios bios;
  final Board board;
  final Product product;
  final Sys sys;

  const Dmi({
    required this.bios,
    required this.board,
    required this.product,
    required this.sys,
  });

  factory Dmi.fromJson(Map<String, dynamic> json) => Dmi(
    bios: Bios.fromJson(json['bios']),
    board: Board.fromJson(json['board']),
    product: Product.fromJson(json['product']),
    sys: Sys.fromJson(json['sys']),
  );

  Map<String, dynamic> toJson() => {
    "bios": bios.toJson(),
    "board": board.toJson(),
    "product": product.toJson(),
    "sys": sys.toJson(),
  };

  @override
  List<Object?> get props => [
    bios,
    board,
    product,
    sys,
  ];
}

class Bios extends Equatable{
  /// BIOS vendor (if available, null otherwise)
  final String vendor;

  const Bios({required this.vendor});

  factory Bios.fromJson(Map<String, dynamic> json) =>
      Bios(vendor: json['vendor'] ?? "");

  Map<String, dynamic> toJson() => {"vendor": vendor};

  @override
  List<Object?> get props => [
    vendor,
  ];
}

class Board extends Equatable{
  /// Board name (if available)
  final String name;

  /// Board vendor (if available)
  final String vendor;

  /// Board version (if available)
  final String version;

  const Board({required this.name, required this.vendor, required this.version});

  factory Board.fromJson(Map<String, dynamic> json) => Board(
    name: json['name'] ?? "",
    vendor: json['vendor'] ?? "",
    version: json['version'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "vendor": vendor,
    "version": version,
  };

  @override
  List<Object?> get props => [
    name,
    vendor,
    version,
  ];
}

class Product extends Equatable{
  /// Product name (if available)
  final String name;

  /// Product version (if available)
  final String version;

  /// Product family (if available)
  final String family;

  const Product({required this.name, required this.version, required this.family});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    name: json['name'] ?? "",
    version: json['version'] ?? "",
    family: json['family'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "version": version,
    "family": family,
  };

  @override
  List<Object?> get props => [
    name,
    version,
    family,
  ];
}

class Sys extends Equatable{
  /// System vendor (if available)
  final String vendor;

  const Sys({required this.vendor});

  factory Sys.fromJson(Map<String, dynamic> json) =>
      Sys(vendor: json['vendor'] ?? "");

  Map<String, dynamic> toJson() => {"vendor": vendor};

  @override
  List<Object?> get props => [
    vendor,
  ];
}
