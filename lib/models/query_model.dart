// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

class QueryListModel extends Equatable{
  final List<QueryModel> queries;
  final int cursor;
  final int recordsTotal;
  final int recordsFiltered;
  final int draw;
  final double took;

  const QueryListModel({
    required this.queries,
    required this.cursor,
    required this.recordsTotal,
    required this.recordsFiltered,
    required this.draw,
    required this.took,
  });

  factory QueryListModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "QueryListModel.fromJson",
    );
    return QueryListModel(
      queries: (json['queries'] as List<dynamic>)
          .map((e) => QueryModel.fromJson(e))
          .toList(),
      cursor: json["cursor"] ?? 0,
      recordsTotal: json["recordsTotal"] ?? 0,
      recordsFiltered: json["recordsFiltered"] ?? 0,
      draw: json["draw"] ?? 0,
      took: json["took"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [queries, cursor, recordsTotal, recordsFiltered, draw, took];
}

class Reply extends Equatable{
  final String type;
  final double time;
  const Reply({required this.type, required this.time});

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(type: json['type'] ?? "", time: json['time'].toDouble() ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'time': time};
  }

  @override
  List<Object?> get props => [type, time,];
}

class Client extends Equatable{
  final String ip;
  final String name;
  const Client({required this.ip, required this.name});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(ip: json['ip'] ?? "", name: json['name'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {'ip': ip, 'name': name};
  }

  @override
  List<Object?> get props => [ip, name,];
}

class EDE extends Equatable{
  final int code;
  final String text;
  const EDE({required this.code, required this.text});

  factory EDE.fromJson(Map<String, dynamic> json) {
    return EDE(code: json['code'] ?? 0, text: json['text'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'text': text};
  }

  @override
  List<Object?> get props => [code, text,];
}

class QueryModel extends Equatable{
  final int id;
  final double time;
  final String type;
  final String status;
  final String dnssec;
  final String domain;
  final String upstream;
  final Reply reply;
  final Client client;
  final int list_id;
  final EDE ede;
  final String cname;

  const QueryModel({
    required this.id,
    required this.time,
    required this.type,
    required this.status,
    required this.dnssec,
    required this.domain,
    required this.upstream,
    required this.reply,
    required this.client,
    required this.list_id,
    required this.ede,
    required this.cname,
  });

  factory QueryModel.fromJson(Map<String, dynamic> json) {
    return QueryModel(
      id: json["id"] ?? 0,
      time: json["time"].toDouble() ?? 0,
      type: json["type"] ?? "",
      status: json["status"] ?? "",
      dnssec: json["dnssec"] ?? "",
      domain: json["domain"] ?? "",
      upstream: json["upstream"] ?? "",
      reply: Reply.fromJson(json["reply"]),
      client: Client.fromJson(json["client"]),
      list_id: json["list_id"] ?? 0,
      ede: EDE.fromJson(json["ede"]),
      cname: json["cname"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
    id,
    time,
    type,
    status,
    dnssec,
    domain,
    upstream,
    reply,
    client,
    list_id,
    ede,
    cname,
  ];
}
