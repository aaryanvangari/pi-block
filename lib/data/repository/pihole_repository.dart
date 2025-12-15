import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:pi_block/data/data_provider/pihole_data_provider.dart';
import 'package:pi_block/models/blocking_model.dart';
import 'package:pi_block/models/clients_history_model.dart';
import 'package:pi_block/models/clients_model.dart';
import 'package:pi_block/models/diagnostic_message_model.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/models/domain_update_model.dart';
import 'package:pi_block/models/domains_model.dart';
import 'package:pi_block/models/history_model.dart';
import 'package:pi_block/models/host_model.dart';
import 'package:pi_block/models/lists_model.dart';
import 'package:pi_block/models/lists_update_model.dart';
import 'package:pi_block/models/pihole_config_model.dart';
import 'package:pi_block/models/query_model.dart';
import 'package:pi_block/models/summary_model.dart';
import 'package:pi_block/models/system_model.dart';
import 'package:pi_block/models/upstreams_model.dart';
import 'package:pi_block/models/version_model.dart';

class PiholeRepository {
  final PiholeDataProvider piholeDataProvider;

  PiholeRepository(this.piholeDataProvider);

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
      log(
        diagnosticMessagesList.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getDiagnosticMessages",
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

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.deleteDiagnosticMessages",
      );

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

      log(
        listsModels.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getListsData",
      );

      return listsModels;
    } catch (e) {
      rethrow;
    }
  }

  Future<ListUpdateModel> addListsItem(ListsModel item) async {
    try {
      var result = await piholeDataProvider.addListsItem(item);
      ListUpdateModel listUpdateModel = ListUpdateModel.fromJson(result);

      log(
        listUpdateModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.addListsItem",
      );

      return listUpdateModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<ListUpdateModel> updateListsItem(ListsModel item) async {
    try {
      var result = await piholeDataProvider.updateListsItem(item);
      ListUpdateModel listUpdateModel = ListUpdateModel.fromJson(result);

      log(
        listUpdateModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.updateListsItem",
      );

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

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.deleteListsItem",
      );

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

      log(
        domainModels.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getDomainsData",
      );

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

      log(
        domainUpdateModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.updateDomainItem",
      );

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

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.deleteDomainsItem",
      );

      return isDeleted;
    } catch (e) {
      rethrow;
    }
  }

  Future<DomainUpdateModel> addDomainsItem(DomainModel item) async {
    try {
      var result = await piholeDataProvider.addDomainsItem(item);
      DomainUpdateModel domainUpdateModel = DomainUpdateModel.fromJson(result);

      log(
        domainUpdateModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.addDomainsItem",
      );

      return domainUpdateModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<ClientsModel> getClients(Map<String, dynamic> blocked) async {
    try {
      var result = await piholeDataProvider.getClients(blocked);
      ClientsModel clientsModel = ClientsModel.fromJson(result);
      
      log(
        clientsModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getClients",
      );

      return clientsModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<DomainsModel> getDomains(Map<String, dynamic> blocked) async {
    try {
      var result = await piholeDataProvider.getDomains(blocked);
      DomainsModel domainsModel = DomainsModel.fromJson(result);
      
      log(
        domainsModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getDomains",
      );

      return domainsModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<HistoryModel> getQueriesHistory() async {
    try {
      var result = await piholeDataProvider.getQueriesHistory();
      HistoryModel historyModel = HistoryModel.fromJson(result);
      
      log(
        historyModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getQueriesHistory",
      );

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
      log(
        clientHistoryModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getClientsHistory",
      );
      return clientHistoryModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<StatsQueryTypes> getQueryTypes() async {
    try {
      var result = await piholeDataProvider.getQueryTypes();
      StatsQueryTypes statsQueryTypes = StatsQueryTypes.fromJson(result);
      log(
        statsQueryTypes.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getQueryTypes",
      );
      return statsQueryTypes;
    } catch (e) {
      rethrow;
    }
  }

  Future<UpstreamsModel> getUpstreams() async {
    try {
      var result = await piholeDataProvider.getUpstreams();
      UpstreamsModel upstreamsModel = UpstreamsModel.fromJson(result);
      log(
        upstreamsModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getUpstreams",
      );
      return upstreamsModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<SystemModel> getSystemInfo() async {
    try {
      var result = await piholeDataProvider.getSystemInfo();
      SystemModel systemModel = SystemModel.fromJson(result);
      
      log(
        systemModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getSystemInfo",
      );

      return systemModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<HostModel> getHostInfo() async {
    try {
      var result = await piholeDataProvider.getHostInfo();
      HostModel hostModel = HostModel.fromJson(result);

      log(
        hostModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getHostInfo",
      );

      return hostModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<VersionModel> getVersion() async {
    try {
      var result = await piholeDataProvider.getVersion();
      VersionModel versionModel = VersionModel.fromJson(result);

      log(
        versionModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getVersion",
      );

      return versionModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<SummaryModel> getSummary() async {
    try {
      var result = await piholeDataProvider.getSummary();
      SummaryModel summaryModel = SummaryModel.fromJson(result);

      log(
        summaryModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getSummary",
      );

      return summaryModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<BlockingModel> getBlockingStatus() async {
    try {
      var result = await piholeDataProvider.getBlockingStatus();
      BlockingModel blockingModel = BlockingModel.fromJson(result);

      log(
        blockingModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getBlockingStatus",
      );

      return blockingModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<BlockingModel> onBlockingChanged(bool status, int? timer) async {
    try {
      var result = await piholeDataProvider.onBlockingChanged(status, timer);
      BlockingModel blockingModel = BlockingModel.fromJson(result);

      log(
        blockingModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.onBlockingChanged",
      );

      return blockingModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<QueryListModel> getQuerylogPage(int start, int pageSize) async {
    try {
      var result = await piholeDataProvider.getQuerylogPage(start, pageSize);
      QueryListModel queryListModel = QueryListModel.fromJson(result);

      log(
        queryListModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getQuerylogPage",
      );

      return queryListModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<PiholeConfigModel> getPiholeConfiguration() async {
    try {
      var result = await piholeDataProvider.getPiholeConfiguration();
      PiholeConfigModel piholeConfigModel = PiholeConfigModel.fromJson(result);
      
      log(
        piholeConfigModel.toString(),
        level: Level.FINE.value,
        name: "PiholeRepository.getPiholeConfiguration",
      );

      return piholeConfigModel;
    } catch (e) {
      rethrow;
    }
  }

  void dispose() => piholeDataProvider.close();
}
