// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:logging/logging.dart';

class Reply {
  String? type;
  double? time;
  Reply({required this.type, required this.time});

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(type: json['type'] ?? "", time: double.tryParse(json['time'].toString()));
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'time': time};
  }
}

class Client {
  String? ip;
  String? name;
  Client({required this.ip, required this.name});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(ip: json['ip'] ?? "", name: json['name'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {'ip': ip, 'name': name};
  }
}

class EDE {
  int? code;
  String? text;
  EDE({required this.code, required this.text});

  factory EDE.fromJson(Map<String, dynamic> json) {
    return EDE(code: json['code'], text: json['text']);
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'text': text};
  }
}

class Query {
  final int? id;
  final double? time;
  final String? type;
  final String status;
  final String? dnssec;
  final String? domain;
  final String? upstream;
  final Reply reply;
  final Client client;
  final int? list_id;
  final EDE ede;
  final String? cname;

  Query({
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

  factory Query.fromJson(Map<String, dynamic> json) {
    log(json.toString(), level: Level.FINEST.value, name: "Query.fromJson");
    return Query(
      id: json["id"],
      time: json["time"],
      type: json["type"],
      status: json["status"] ?? "",
      dnssec: json["dnssec"],
      domain: json["domain"],
      upstream: json["upstream"],
      reply: Reply.fromJson(json["reply"]),
      client: Client.fromJson(json["client"]),
      list_id: json["list_id"],
      ede: EDE.fromJson(json["ede"]),
      cname: json["cname"],
    );
  }
}
