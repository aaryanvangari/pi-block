import 'dart:convert';

import 'package:pi_block/components/pi_http_client.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/constants/api_urls.dart';
import 'package:pi_block/logging/app_logger.dart';
import 'package:pi_block/models/client_model.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/models/gravity_log_model.dart';
import 'package:pi_block/models/groups_model.dart';
import 'package:pi_block/models/lists_model.dart';

class PiholeDataProvider {
  PiHttpClient piHttpClient = PiHttpClient();

  final _log = AppLogger.get('PiholeDataProvider');

  Future<Map<String, dynamic>> login(Uri uri, String password) async {
    try {
      var body = jsonEncode(<String, String>{'password': password});
      var result = await piHttpClient.post(
        ApiUrls.auth,
        null,
        body,
        uri.scheme,
        uri.host,
        uri.port,
        password,
      );

      PiUtils.handleAPIException(result, true);

      _log.fine(() => 'login: ${result["session"]["valid"].toString()}');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      var result = await piHttpClient.delete(ApiUrls.auth);

      PiUtils.handleAPIException(result, true);

      _log.fine(() => 'logout: ${result.toString()}');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDiagnosticMessages() async {
    try {
      var result = await piHttpClient.get(ApiUrls.messages);
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getDiagnosticMessages: ${result.toString()}');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteDiagnosticMessages(int id) async {
    try {
      var result = await piHttpClient.delete('${ApiUrls.messages}/$id');
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'deleteDiagnosticMessages: ${result.toString()}');
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
        ApiUrls.lists,
        queryParams: queryParameter,
      );
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'getListsData: ${result.toString()}');

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
      _log.fine(() => 'addListsItem: ${queryParameter.toString()}');
      _log.fine(() => 'addListsItem: ${body.toString()}');

      var result = await piHttpClient.post(ApiUrls.lists, queryParameter, body);
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'addListsItem: ${result.toString()}');
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
      _log.fine(() => 'updateListsItem: ${queryParameter.toString()}');
      _log.fine(() => 'updateListsItem: ${body.toString()}');
      String listEncoded = Uri.encodeComponent(item.address);

      var result = await piHttpClient.put(
        '${ApiUrls.lists}/$listEncoded',
        queryParameter,
        body,
      );
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'updateListsItem: ${result.toString()}');
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
      _log.fine(() => 'deleteListsItem: ${body.toString()}');

      var result = await piHttpClient.post(ApiUrls.listsDelete, null, body);
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'deleteListsItem: ${result.toString()}');
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
        ApiUrls.domains,
        queryParams: queryParameter,
      );
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getDomainsData: ${result.toString()}');

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
      _log.fine(() => 'updateDomainItem: ${queryParameter.toString()}');
      _log.fine(() => 'updateDomainItem: ${body.toString()}');
      String domainEncoded = Uri.encodeComponent(item.domain);

      var result = await piHttpClient.put(
        '${ApiUrls.domains}/${item.type}/${item.kind}/$domainEncoded',
        null,
        body,
      );
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'updateDomainItem: ${result.toString()}');
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
      _log.fine(() => 'deleteDomainsItem: ${body.toString()}');

      var result = await piHttpClient.post(ApiUrls.domainsDelete, null, body);
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'deleteDomainsItem: ${result.toString()}');
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
      _log.fine(() => 'addDomainsItem: ${body.toString()}');

      var result = await piHttpClient.post(
        '${ApiUrls.domains}/${item.type}/${item.kind}',
        null,
        body,
      );
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'addDomainsItem: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getClientsSuggestionsData() async {
    try {
      var result = await piHttpClient.get(ApiUrls.clientsSuggestions);
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getClientsSuggestionsData: ${result.toString()}');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getClientsData() async {
    try {
      final queryParameter = <String, dynamic>{
        '_': DateTime.now().millisecondsSinceEpoch.toString(),
      };
      var result = await piHttpClient.get(
        ApiUrls.clients,
        queryParams: queryParameter,
      );
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getClientsData: ${result.toString()}');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateClientItem(ClientModel item) async {
    try {
      var body = jsonEncode(<String, dynamic>{
        "comment": item.comment,
        "groups": item.groups,
      });
      _log.fine(() => 'updateClientItem: ${body.toString()}');
      String clientEncoded = Uri.encodeComponent(item.client);

      var result = await piHttpClient.put(
        '${ApiUrls.clients}/$clientEncoded',
        null,
        body,
      );
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'updateClientItem: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteClientsItem(ClientModel item) async {
    try {
      List<Map<String, dynamic>> batchDelete = [
        {"item": item.client},
      ];
      var body = jsonEncode(batchDelete);
      _log.fine(() => 'deleteClientsItem: ${body.toString()}');

      var result = await piHttpClient.post(ApiUrls.clientsDelete, null, body);
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'deleteClientsItem: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addClientsItem(ClientModel item) async {
    try {
      var body = jsonEncode(<String, dynamic>{
        "client": [item.client],
        "comment": item.comment,
        "groups": item.groups,
      });
      _log.fine(() => 'addClientsItem: ${body.toString()}');

      var result = await piHttpClient.post(ApiUrls.clients, null, body);
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'addClientsItem: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getGroupsData() async {
    try {
      final queryParameter = <String, dynamic>{
        '_': DateTime.now().millisecondsSinceEpoch.toString(),
      };
      var result = await piHttpClient.get(
        ApiUrls.groups,
        queryParams: queryParameter,
      );
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getGroupsData: ${result.toString()}');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateGroupItem(
    GroupModel item,
    String previousName,
  ) async {
    try {
      var body = jsonEncode(<String, dynamic>{
        "name": item.name,
        "comment": item.comment,
        "enabled": item.enabled,
      });
      _log.fine(() => 'updateGroupItem: ${body.toString()}');
      String groupEncoded = Uri.encodeComponent(previousName);

      var result = await piHttpClient.put(
        '${ApiUrls.groups}/$groupEncoded',
        null,
        body,
      );
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'updateGroupItem: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteGroupsItem(GroupModel item) async {
    try {
      List<Map<String, dynamic>> batchDelete = [
        {"item": item.name},
      ];
      var body = jsonEncode(batchDelete);
      _log.fine(() => 'deleteGroupsItem: ${body.toString()}');

      var result = await piHttpClient.post(ApiUrls.groupsDelete, null, body);
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'deleteGroupsItem: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addGroupsItem(GroupModel item) async {
    try {
      var body = jsonEncode(<String, dynamic>{
        "name": [item.name],
        "comment": item.comment,
        "enabled": item.enabled,
      });
      _log.fine(() => 'addGroupsItem: ${body.toString()}');

      var result = await piHttpClient.post(ApiUrls.groups, null, body);
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'addGroupsItem: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTopClients(
    Map<String, dynamic> blocked,
  ) async {
    try {
      var result = await piHttpClient.get(
        ApiUrls.topClients,
        queryParams: blocked,
      );
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getTopClients: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTopDomains(
    Map<String, dynamic> blocked,
  ) async {
    try {
      var result = await piHttpClient.get(
        ApiUrls.topDomains,
        queryParams: blocked,
      );
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getTopDomains: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getQueriesHistory() async {
    try {
      var result = await piHttpClient.get(ApiUrls.history);
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getQueriesHistory: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getClientsHistory() async {
    try {
      var result = await piHttpClient.get(ApiUrls.clientsHistory);
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getClientsHistory: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getQueryTypes() async {
    try {
      var result = await piHttpClient.get(ApiUrls.queryTypes);
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getQueryTypes: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUpstreams() async {
    try {
      var result = await piHttpClient.get(ApiUrls.upStreams);
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getUpstreams: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSystemInfo() async {
    try {
      var result = await piHttpClient.get(ApiUrls.system);
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getSystemInfo: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getHostInfo() async {
    try {
      var result = await piHttpClient.get(ApiUrls.hosts);
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getHostInfo: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getVersion() async {
    try {
      var result = await piHttpClient.get(ApiUrls.versions);
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getVersion: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSummary() async {
    try {
      var result = await piHttpClient.get(ApiUrls.summary);
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'getSummary: ${result.toString()}');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMetrics() async {
    try {
      var result = await piHttpClient.get(ApiUrls.metrics);
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'getMetrics: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBlockingStatus() async {
    try {
      var result = await piHttpClient.get(ApiUrls.dns);
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'getBlockingStatus: ${result.toString()}');

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

      var result = await piHttpClient.post(ApiUrls.dns, null, body);
      PiUtils.handleAPIException(result, false);
      _log.fine(() => 'onBlockingChanged: ${result.toString()}');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getQuerylogPage(
    String searchTerm,
    int start,
    int pageSize,
  ) async {
    try {
      final queryParameter = <String, dynamic>{
        'start': ((start - 1) * pageSize).toString(),
        'length': pageSize.toString(),
        // 'status': 'GRAVITY_CNAME',
        if (searchTerm.trim().isNotEmpty) 'domain': '*${searchTerm.trim()}*',
      };

      var result = await piHttpClient.get(
        ApiUrls.queries,
        queryParams: queryParameter,
      );
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'getQuerylogPage: ${result.toString()}');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPiholeConfiguration() async {
    try {
      var result = await piHttpClient.get(ApiUrls.config);
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'getPiholeConfiguration: ${result.toString()}');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDnsmasqLogs(int nextID) async {
    try {
      final queryParameter = <String, dynamic>{'nextID': nextID.toString()};

      var result = await piHttpClient.get(
        ApiUrls.dnsmasqLogs,
        queryParams: queryParameter,
      );
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'getDnsmasqLogs: ${result.toString()}');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getFtlLogs(int nextID) async {
    try {
      final queryParameter = <String, dynamic>{'nextID': nextID.toString()};
      var result = await piHttpClient.get(
        ApiUrls.ftlLogs,
        queryParams: queryParameter,
      );
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'getFtlLogs: ${result.toString()}');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getWebserverLogs(int nextID) async {
    try {
      final queryParameter = <String, dynamic>{'nextID': nextID.toString()};
      var result = await piHttpClient.get(
        ApiUrls.webserverLogs,
        queryParams: queryParameter,
      );
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'getWebserverLogs: ${result.toString()}');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Stream<GravityLog> getGravityLogs() {
    try {
      var result = piHttpClient.postStream(ApiUrls.gravityLogs, null, null);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getNetworkGateway() async {
    try {
      final queryParameter = <String, dynamic>{'detailed': 'true'};
      var result = await piHttpClient.get(
        ApiUrls.networkGateway,
        queryParams: queryParameter,
      );
      PiUtils.handleAPIException(result, false);

      _log.fine(() => 'getNetworkGateway: ${result.toString()}');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  void close() => piHttpClient.close();
}
