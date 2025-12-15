import 'dart:convert';
import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:pi_block/components/pi_http_client.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/models/lists_model.dart';

class PiholeDataProvider {
  PiHttpClient piHttpClient = PiHttpClient();

  Future<Map<String, dynamic>> getDiagnosticMessages() async {
    try {
      var result = await piHttpClient.get(KUrls.messages);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getDiagnosticMessages",
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteDiagnosticMessages(int id) async {
    try {
      var result = await piHttpClient.delete('${KUrls.messages}/$id', false);
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.deleteDiagnosticMessages",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getListsData() async {
    try {
      final queryParameter = <String, dynamic>{
        '_': DateTime.now().millisecondsSinceEpoch.toString(),
      };
      var result = await piHttpClient.get(
        KUrls.lists,
        queryParams: queryParameter,
      );
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getListsData",
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addListsItem(ListsModel item) async {
    try {
      final queryParameter = <String, dynamic>{'type': item.type};
      var body = jsonEncode(<String, dynamic>{
        "address": [item.address],
        "comment": item.comment,
        "groups": item.groups,
      });
      log(queryParameter.toString());
      log(body.toString());

      var result = await piHttpClient.post(KUrls.lists, queryParameter, body);
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.addListsItem",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateListsItem(ListsModel item) async {
    try {
      final queryParameter = <String, dynamic>{'type': item.type};
      var body = jsonEncode(<String, dynamic>{
        "comment": item.comment,
        "groups": item.groups,
        "type": item.type,
        "enabled": item.enabled,
      });
      log(queryParameter.toString());
      log(body.toString());
      String listEncoded = Uri.encodeComponent(item.address);

      var result = await piHttpClient.put(
        '${KUrls.lists}/$listEncoded',
        queryParameter,
        body,
      );
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.updateListsItem",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteListsItem(ListsModel item) async {
    try {
      List<Map<String, dynamic>> batchDelete = [
        {"item": item.address, "type": item.type},
      ];
      var body = jsonEncode(batchDelete);
      log(body.toString());

      var result = await piHttpClient.post(KUrls.listsDelete, null, body);
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.deleteListsItem",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDomainsData() async {
    try {
      final queryParameter = <String, dynamic>{
        '_': DateTime.now().millisecondsSinceEpoch.toString(),
      };
      var result = await piHttpClient.get(
        KUrls.domains,
        queryParams: queryParameter,
      );
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getDomainsData",
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateDomainItem(
    DomainModel item,
    String previousType,
    String previousKind,
  ) async {
    try {
      final queryParameter = <String, dynamic>{'type': item.type};
      var body = jsonEncode(<String, dynamic>{
        "comment": item.comment,
        "kind": previousKind,
        "groups": item.groups,
        "type": previousType,
        "enabled": item.enabled,
      });
      log(queryParameter.toString());
      log(body.toString());
      String domainEncoded = Uri.encodeComponent(item.domain);

      var result = await piHttpClient.put(
        '${KUrls.domains}/${item.type}/${item.kind}/$domainEncoded',
        null,
        body,
      );
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.updateDomainItem",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteDomainsItem(DomainModel item) async {
    try {
      List<Map<String, dynamic>> batchDelete = [
        {"item": item.domain, "type": item.type, "kind": item.kind},
      ];
      var body = jsonEncode(batchDelete);
      log(body.toString());

      var result = await piHttpClient.post(KUrls.domainsDelete, null, body);
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.deleteDomainsItem",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addDomainsItem(DomainModel item) async {
    try {
      var body = jsonEncode(<String, dynamic>{
        "domain": [item.domain],
        "comment": item.comment,
        "groups": item.groups,
        "type": item.type,
        "kind": item.kind,
      });
      log(body.toString());

      var result = await piHttpClient.post(
        '${KUrls.domains}/${item.type}/${item.kind}',
        null,
        body,
      );
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.addDomainsItem",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getClients(Map<String, dynamic> blocked) async {
    try {
      var result = await piHttpClient.get(KUrls.clients, queryParams: blocked);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getClients",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDomains(Map<String, dynamic> blocked) async {
    try {
      var result = await piHttpClient.get(
        KUrls.topDomains,
        queryParams: blocked,
      );
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getDomains",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getQueriesHistory() async {
    try {
      var result = await piHttpClient.get(KUrls.history);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getQueriesHistory",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getClientsHistory() async {
    try {
      var result = await piHttpClient.get(KUrls.clientsHistory);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getClientsHistory",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getQueryTypes() async {
    try {
      var result = await piHttpClient.get(KUrls.queryTypes);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getQueryTypes",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUpstreams() async {
    try {
      var result = await piHttpClient.get(KUrls.upStreams);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getUpstreams",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSystemInfo() async {
    try {
      var result = await piHttpClient.get(KUrls.system);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getSystemInfo",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getHostInfo() async {
    try {
      var result = await piHttpClient.get(KUrls.hosts);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getHostInfo",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getVersion() async {
    try {
      var result = await piHttpClient.get(KUrls.versions);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getVersion",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSummary() async {
    try {
      var result = await piHttpClient.get(KUrls.summary);
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getSummary",
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBlockingStatus() async {
    try {
      var result = await piHttpClient.get(KUrls.dns);
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getBlockingStatus",
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> onBlockingChanged(
    bool status,
    int? timer,
  ) async {
    try {
      var body = jsonEncode(<String, dynamic>{
        "blocking": status,
        "timer": timer,
      });

      var result = await piHttpClient.post(KUrls.dns, null, body);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.onBlockingChanged",
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getQuerylogPage(int start, int pageSize) async {
    try {
      final queryParameter = <String, dynamic>{
        'start': ((start - 1) * pageSize).toString(),
        'length': pageSize.toString(),
        // 'status': 'GRAVITY_CNAME',
        // 'domain': '*googlevideo*'
      };

      var result = await piHttpClient.get(
        KUrls.queries,
        queryParams: queryParameter,
      );
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getQuerylogPage",
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPiholeConfiguration() async {
    try {
      var result = await piHttpClient.get(KUrls.config);
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeDataProvider.getPiholeConfiguration",
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  void close() {
    piHttpClient.close();
  }
}
