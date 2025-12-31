class ApiUrls {
  static const String base = "/api";
  static const String auth = '$base/auth';
  static const String queryTypes = '$base/stats/query_types';
  static const String upStreams = '$base/stats/upstreams';
  static const String topDomains = '$base/stats/top_domains';
  static const String domains = '$base/domains';
  static const String domainsDelete = '$base/domains:batchDelete';
  static const String groups = '$base/groups';
  static const String groupsDelete = '$base/groups:batchDelete';
  static const String topClients = '$base/stats/top_clients';
  static const String queries = '$base/queries';
  static const String config = '$base/config';
  static const String messages = '$base/info/messages';
  static const String messagesCount = '$base/info/messages/count';
  static const String lists = '$base/lists';
  static const String listsDelete = '$base/lists:batchDelete';
  static const String clients = '$base/clients';
  static const String clientsDelete = '$base/clients:batchDelete';
  static const String dns = '$base/dns/blocking';
  static const String summary = '$base/stats/summary';
  static const String system = '$base/info/system';
  static const String hosts = '$base/info/host';
  static const String versions = '$base/info/version';
  static const String history = '$base/history';
  static const String clientsHistory = '$base/history/clients';
}
