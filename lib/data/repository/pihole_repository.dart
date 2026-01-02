import 'package:pi_block/data/data_provider/pihole_data_provider.dart';
import 'package:pi_block/logging/app_logger.dart';
import 'package:pi_block/models/blocking_model.dart';
import 'package:pi_block/models/client_model.dart';
import 'package:pi_block/models/clients_history_model.dart';
import 'package:pi_block/models/clients_stats_model.dart';
import 'package:pi_block/models/clients_suggestion_model.dart';
import 'package:pi_block/models/clients_update_model.dart';
import 'package:pi_block/models/diagnostic_message_model.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/models/domain_update_model.dart';
import 'package:pi_block/models/domains_model.dart';
import 'package:pi_block/models/groups_model.dart';
import 'package:pi_block/models/groups_update_model.dart';
import 'package:pi_block/models/history_model.dart';
import 'package:pi_block/models/host_model.dart';
import 'package:pi_block/models/lists_model.dart';
import 'package:pi_block/models/lists_update_model.dart';
import 'package:pi_block/models/logs_model.dart';
import 'package:pi_block/models/metrics_model.dart';
import 'package:pi_block/models/pihole_config_model.dart';
import 'package:pi_block/models/query_model.dart';
import 'package:pi_block/models/session_model.dart';
import 'package:pi_block/models/summary_model.dart';
import 'package:pi_block/models/system_model.dart';
import 'package:pi_block/models/upstreams_model.dart';
import 'package:pi_block/models/version_model.dart';

class PiholeRepository {
  final PiholeDataProvider piholeDataProvider;

  PiholeRepository(this.piholeDataProvider);

  final _log = AppLogger.get('PiholeRepository');

  Future<SessionModel> login(Uri uri, String password) async {
    try {
      var result = await piholeDataProvider.login(uri, password);
      SessionModel sessionModel = SessionModel.fromJson(result);

      _log.fine(() => 'login: ${sessionModel.session!.valid.toString()}');

      return sessionModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logout() async {
    try {
      var result = await piholeDataProvider.logout();
      bool isDeleted = false;
      if (result.containsKey("deleted") && result["deleted"]) {
        isDeleted = true;
      }

      _log.fine(() => 'logout: ${result.toString()}');

      return isDeleted;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DiagnosticMessageModel>> getDiagnosticMessages() async {
    try {
      var result = await piholeDataProvider.getDiagnosticMessages();
      List<DiagnosticMessageModel> diagnosticMessagesList =
          (result['messages'] as List<dynamic>)
              .map(
                (json) => DiagnosticMessageModel.fromJson(
                  json as Map<String, dynamic>,
                ),
              )
              .toList();
      _log.fine(
        () => 'getDiagnosticMessages: ${diagnosticMessagesList.toString()}',
      );

      return diagnosticMessagesList;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteDiagnosticMessages(int id) async {
    try {
      var result = await piholeDataProvider.deleteDiagnosticMessages(id);
      bool isDeleted = false;
      if (result.containsKey("deleted") && result["deleted"]) {
        isDeleted = true;
      }

      _log.fine(() => 'deleteDiagnosticMessages: ${result.toString()}');

      return isDeleted;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ListsModel>> getListsData() async {
    try {
      var result = await piholeDataProvider.getListsData();
      List<ListsModel> listsModels = (result['lists'] as List<dynamic>)
          .map((json) => ListsModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _log.fine(() => 'getListsData: ${listsModels.toString()}');

      return listsModels;
    } catch (e) {
      rethrow;
    }
  }

  Future<ListUpdateModel> addListsItem(ListsModel item) async {
    try {
      var result = await piholeDataProvider.addListsItem(item);
      ListUpdateModel listUpdateModel = ListUpdateModel.fromJson(result);

      _log.fine(() => 'addListsItem: ${listUpdateModel.toString()}');

      return listUpdateModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<ListUpdateModel> updateListsItem(ListsModel item) async {
    try {
      var result = await piholeDataProvider.updateListsItem(item);
      ListUpdateModel listUpdateModel = ListUpdateModel.fromJson(result);

      _log.fine(() => 'updateListsItem: ${listUpdateModel.toString()}');

      return listUpdateModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteListsItem(ListsModel item) async {
    try {
      var result = await piholeDataProvider.deleteListsItem(item);
      bool isDeleted = false;
      if (result.containsKey("deleted") && result["deleted"]) {
        isDeleted = true;
      }

      _log.fine(() => 'deleteListsItem: ${result.toString()}');

      return isDeleted;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DomainModel>> getDomainsData() async {
    try {
      var result = await piholeDataProvider.getDomainsData();
      List<DomainModel> domainModels = (result['domains'] as List<dynamic>)
          .map((json) => DomainModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _log.fine(() => 'getDomainsData: ${domainModels.toString()}');

      return domainModels;
    } catch (e) {
      rethrow;
    }
  }

  Future<DomainUpdateModel> updateDomainItem(
    DomainModel item,
    String previousType,
    String previousKind,
  ) async {
    try {
      var result = await piholeDataProvider.updateDomainItem(
        item,
        previousType,
        previousKind,
      );
      DomainUpdateModel domainUpdateModel = DomainUpdateModel.fromJson(result);

      _log.fine(() => 'updateDomainItem: ${domainUpdateModel.toString()}');

      return domainUpdateModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteDomainsItem(DomainModel item) async {
    try {
      var result = await piholeDataProvider.deleteDomainsItem(item);
      bool isDeleted = false;
      if (result.containsKey("deleted") && result["deleted"]) {
        isDeleted = true;
      }

      _log.fine(() => 'deleteDomainsItem: ${result.toString()}');

      return isDeleted;
    } catch (e) {
      rethrow;
    }
  }

  Future<DomainUpdateModel> addDomainsItem(DomainModel item) async {
    try {
      var result = await piholeDataProvider.addDomainsItem(item);
      DomainUpdateModel domainUpdateModel = DomainUpdateModel.fromJson(result);

      _log.fine(() => 'addDomainsItem: ${domainUpdateModel.toString()}');

      return domainUpdateModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ClientSuggestionModel>> getClientsSuggestionsData() async {
    try {
      var result = await piholeDataProvider.getClientsSuggestionsData();
      List<ClientSuggestionModel> clientSuggestionModels =
          (result['clients'] as List<dynamic>)
              .map(
                (json) => ClientSuggestionModel.fromJson(
                  json as Map<String, dynamic>,
                ),
              )
              .toList();

      _log.fine(
        () => 'getClientsSuggestionsData: ${clientSuggestionModels.toString()}',
      );

      return clientSuggestionModels;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ClientModel>> getClientsData() async {
    try {
      var result = await piholeDataProvider.getClientsData();
      List<ClientModel> clientModels = (result['clients'] as List<dynamic>)
          .map((json) => ClientModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _log.fine(() => 'getClientsData: ${clientModels.toString()}');

      return clientModels;
    } catch (e) {
      rethrow;
    }
  }

  Future<ClientsUpdateModel> updateClientItem(ClientModel item) async {
    try {
      var result = await piholeDataProvider.updateClientItem(item);
      ClientsUpdateModel clientsUpdateModel = ClientsUpdateModel.fromJson(
        result,
      );

      _log.fine(() => 'updateDomainItem: ${clientsUpdateModel.toString()}');

      return clientsUpdateModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteClientsItem(ClientModel item) async {
    try {
      var result = await piholeDataProvider.deleteClientsItem(item);
      bool isDeleted = false;
      if (result.containsKey("deleted") && result["deleted"]) {
        isDeleted = true;
      }

      _log.fine(() => 'deleteClientsItem: ${result.toString()}');

      return isDeleted;
    } catch (e) {
      rethrow;
    }
  }

  Future<ClientsUpdateModel> addClientsItem(ClientModel item) async {
    try {
      var result = await piholeDataProvider.addClientsItem(item);
      ClientsUpdateModel clientsUpdateModel = ClientsUpdateModel.fromJson(
        result,
      );

      _log.fine(() => 'addClientsItem: ${clientsUpdateModel.toString()}');

      return clientsUpdateModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GroupModel>> getGroupsData() async {
    try {
      var result = await piholeDataProvider.getGroupsData();
      List<GroupModel> groupModels = (result['groups'] as List<dynamic>)
          .map((json) => GroupModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _log.fine(() => 'getGroupsData: ${groupModels.toString()}');

      return groupModels;
    } catch (e) {
      rethrow;
    }
  }

  Future<GroupUpdateModel> updateGroupItem(
    GroupModel item,
    String previousName,
  ) async {
    try {
      var result = await piholeDataProvider.updateGroupItem(item, previousName);
      GroupUpdateModel groupUpdateModel = GroupUpdateModel.fromJson(result);

      _log.fine(() => 'updateGroupItem: ${groupUpdateModel.toString()}');

      return groupUpdateModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteGroupsItem(GroupModel item) async {
    try {
      var result = await piholeDataProvider.deleteGroupsItem(item);
      bool isDeleted = false;
      if (result.containsKey("deleted") && result["deleted"]) {
        isDeleted = true;
      }

      _log.fine(() => 'deleteGroupsItem: ${result.toString()}');

      return isDeleted;
    } catch (e) {
      rethrow;
    }
  }

  Future<GroupUpdateModel> addGroupsItem(GroupModel item) async {
    try {
      var result = await piholeDataProvider.addGroupsItem(item);
      GroupUpdateModel groupUpdateModel = GroupUpdateModel.fromJson(result);

      _log.fine(() => 'addGroupsItem: ${groupUpdateModel.toString()}');

      return groupUpdateModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<ClientsStatsModel> getTopClients(Map<String, dynamic> blocked) async {
    try {
      var result = await piholeDataProvider.getTopClients(blocked);
      ClientsStatsModel clientsModel = ClientsStatsModel.fromJson(result);

      _log.fine(() => 'getTopClients: ${clientsModel.toString()}');

      return clientsModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<DomainsModel> getTopDomains(Map<String, dynamic> blocked) async {
    try {
      var result = await piholeDataProvider.getTopDomains(blocked);
      DomainsModel domainsModel = DomainsModel.fromJson(result);

      _log.fine(() => 'getTopDomains: ${domainsModel.toString()}');

      return domainsModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<HistoryModel> getQueriesHistory() async {
    try {
      var result = await piholeDataProvider.getQueriesHistory();
      HistoryModel historyModel = HistoryModel.fromJson(result);

      _log.fine(() => 'getQueriesHistory: ${historyModel.toString()}');

      return historyModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<ClientHistoryModel> getClientsHistory() async {
    try {
      var result = await piholeDataProvider.getClientsHistory();
      ClientHistoryModel clientHistoryModel = ClientHistoryModel.fromJson(
        result,
      );
      _log.fine(() => 'getClientsHistory: ${clientHistoryModel.toString()}');
      return clientHistoryModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<StatsQueryTypes> getQueryTypes() async {
    try {
      var result = await piholeDataProvider.getQueryTypes();
      StatsQueryTypes statsQueryTypes = StatsQueryTypes.fromJson(result);
      _log.fine(() => 'getQueryTypes: ${statsQueryTypes.toString()}');
      return statsQueryTypes;
    } catch (e) {
      rethrow;
    }
  }

  Future<UpstreamsModel> getUpstreams() async {
    try {
      var result = await piholeDataProvider.getUpstreams();
      UpstreamsModel upstreamsModel = UpstreamsModel.fromJson(result);
      _log.fine(() => 'getUpstreams: ${upstreamsModel.toString()}');
      return upstreamsModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<SystemModel> getSystemInfo() async {
    try {
      var result = await piholeDataProvider.getSystemInfo();
      SystemModel systemModel = SystemModel.fromJson(result);

      _log.fine(() => 'getSystemInfo: ${systemModel.toString()}');

      return systemModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<HostModel> getHostInfo() async {
    try {
      var result = await piholeDataProvider.getHostInfo();
      HostModel hostModel = HostModel.fromJson(result);

      _log.fine(() => 'getHostInfo: ${hostModel.toString()}');

      return hostModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<VersionModel> getVersion() async {
    try {
      var result = await piholeDataProvider.getVersion();
      VersionModel versionModel = VersionModel.fromJson(result);

      _log.fine(() => 'getVersion: ${versionModel.toString()}');

      return versionModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<SummaryModel> getSummary() async {
    try {
      var result = await piholeDataProvider.getSummary();
      SummaryModel summaryModel = SummaryModel.fromJson(result);

      _log.fine(() => 'getSummary: ${summaryModel.toString()}');

      return summaryModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<MetricsModel> getMetrics() async {
    try {
      var result = await piholeDataProvider.getMetrics();
      MetricsModel metricsModel = MetricsModel.fromJson(result);

      _log.fine(() => 'getMetrics: ${metricsModel.toString()}');

      return metricsModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<BlockingModel> getBlockingStatus() async {
    try {
      var result = await piholeDataProvider.getBlockingStatus();
      BlockingModel blockingModel = BlockingModel.fromJson(result);

      _log.fine(() => 'getBlockingStatus: ${blockingModel.toString()}');

      return blockingModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<BlockingModel> onBlockingChanged(bool status, int? timer) async {
    try {
      var result = await piholeDataProvider.onBlockingChanged(status, timer);
      BlockingModel blockingModel = BlockingModel.fromJson(result);

      _log.fine(() => 'onBlockingChanged: ${blockingModel.toString()}');

      return blockingModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<QueryListModel> getQuerylogPage(
    String searchTerm,
    int start,
    int pageSize,
  ) async {
    try {
      var result = await piholeDataProvider.getQuerylogPage(
        searchTerm,
        start,
        pageSize,
      );
      QueryListModel queryListModel = QueryListModel.fromJson(result);

      _log.fine(() => 'getQuerylogPage: ${queryListModel.toString()}');

      return queryListModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<PiholeConfigModel> getPiholeConfiguration() async {
    try {
      var result = await piholeDataProvider.getPiholeConfiguration();
      PiholeConfigModel piholeConfigModel = PiholeConfigModel.fromJson(result);

      _log.fine(
        () => 'getPiholeConfiguration: ${piholeConfigModel.toString()}',
      );

      return piholeConfigModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<LogsModel> getDnsmasqLogs(int nextID) async {
    try {
      var result = await piholeDataProvider.getDnsmasqLogs(nextID);
      LogsModel logsModel = LogsModel.fromJson(result);

      _log.fine(() => 'getDnsmasqLogs: ${logsModel.toString()}');

      return logsModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<LogsModel> getFtlLogs(int nextID) async {
    try {
      var result = await piholeDataProvider.getFtlLogs(nextID);
      LogsModel logsModel = LogsModel.fromJson(result);

      _log.fine(() => 'getFtlLogs: ${logsModel.toString()}');

      return logsModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<LogsModel> getWebserverLogs(int nextID) async {
    try {
      var result = await piholeDataProvider.getWebserverLogs(nextID);
      LogsModel logsModel = LogsModel.fromJson(result);

      _log.fine(() => 'getWebserverLogs: ${logsModel.toString()}');

      return logsModel;
    } catch (e) {
      rethrow;
    }
  }

  void dispose() => piholeDataProvider.close();
}
