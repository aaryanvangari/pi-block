import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:pi_block/widgets/custom_pie_chart.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/components/pi_http_client.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  PiHttpClient piHttpClient = PiHttpClient();
  Future<Map<String, dynamic>> getQueryTypes() async {
    try {
      var result = await piHttpClient.get(KUrls.queryTypes);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "StatsPage.getQueryTypes",
      );
      return result;
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
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
        name: "StatsPage.getUpstreams",
      );
      return result;
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDomains(bool blocked) async {
    try {
      var result = await piHttpClient.get(
        KUrls.topDomains,
        queryParams: blocked ? {"blocked": "true"} : {},
      );
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "StatsPage.getDomains",
      );
      return result;
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getClients(bool blocked) async {
    try {
      var result = await piHttpClient.get(
        KUrls.clients,
        queryParams: blocked ? {"blocked": "true"} : {},
      );
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "StatsPage.getClients",
      );
      return result;
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
      rethrow;
    }
  }

  List<PieData> generateTypesPieData(Map<String, dynamic> types) {
    List<PieData> pieDataList = [];
    double total = 0;
    types.forEach((key, value) {
      total = total + value.toDouble();
    });
    types.forEach((key, value) {
      if (value > 0) {
        double pieValue = PiUtils.roundDouble(
          (value.toDouble() / total) * 100,
          1,
        );
        PieData pieData = PieData(
          key,
          pieValue,
          PiUtils.getRandomColor(context),
        );
        pieDataList.add(pieData);
      }
    });
    return pieDataList;
  }

  List<PieData> generateUpstreamsPieData(
    List<dynamic> upstreams,
    int totalQueries,
  ) {
    List<PieData> pieDataList = [];
    for (var upstreamItem in upstreams) {
      String name = upstreamItem["name"];
      int count = upstreamItem["count"];
      if (count > 0) {
        double pieValue = PiUtils.roundDouble(
          (count.toDouble() / totalQueries) * 100,
          1,
        );
        PieData pieData = PieData(
          name,
          pieValue,
          PiUtils.getRandomColor(context),
        );
        pieDataList.add(pieData);
      }
    }
    return pieDataList;
  }

  Widget generateTopDomainsData(
    List<dynamic> upstreams,
    int totalQueries,
    Color progressBarColor,
    bool isBlocked,
  ) {
    ListView listView = ListView.builder(
      itemCount: upstreams.length,
      itemBuilder: (context, index) {
        String name = upstreams[index]["domain"];
        int count = upstreams[index]["count"];
        return _rowWithProgressBar(
          title: name,
          count: count,
          total: totalQueries,
          isBlocked: isBlocked,
          progressBarColor: progressBarColor,
        );
      },
    );
    return listView;
  }

  Widget generateTopClientsData(
    List<dynamic> clients,
    int totalQueries,
    Color progressBarColor,
    bool isBlocked,
  ) {
    ListView listView = ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, index) {
        String name = clients[index]["name"];
        int count = clients[index]["count"];
        return _rowWithProgressBar(
          title: name,
          count: count,
          total: totalQueries,
          isBlocked: isBlocked,
          progressBarColor: progressBarColor,
        );
      },
    );

    return listView;
  }

  Widget _rowWithProgressBar({
    required String title,
    required int count,
    required int total,
    required bool isBlocked,
    required Color progressBarColor,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tooltip(
                    message:
                        '${((count / total) * 100).toInt()}% - $count of $total',
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(20),
                    verticalOffset: 5,
                    preferBelow: false,
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.75,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 2,
                      left: 2,
                      right: 2,
                      bottom: 4,
                    ),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey.withAlpha(40),
                      borderRadius: BorderRadius.circular(25),
                      color: progressBarColor,
                      minHeight: 2,
                      value: (count / total),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Divider(height: 2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            // ----------------
            // Pie Charts
            // ----------------
            // Query Types
            FutureBuilder(
              future: getQueryTypes(),
              builder: (context, AsyncSnapshot snapshot) {
                Widget widget;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  widget = Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  var typesResult = snapshot.data;
                  var types = typesResult["types"];
                  var pieDataList = generateTypesPieData(types);

                  widget = Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: KCardStyle.cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2,
                            ),
                            child: Text(
                              "Query Types",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                // color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomPieChart(
                            space: 2,
                            horizontalLine: 10,
                            outerMargin: 20,
                            data: pieDataList,
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  widget = ErrorCardWidget(
                    header: "Query Types",
                    message: "Error loading data",
                  );
                } else {
                  widget = EmptyCardWidget(
                    header: "Query Types",
                    message: "No data",
                  );
                }
                return widget;
              },
            ),

            // Upstreams
            FutureBuilder(
              future: getUpstreams(),
              builder: (context, AsyncSnapshot snapshot) {
                Widget widget;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  widget = Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  var upstreamsResult = snapshot.data;
                  var upstreams = upstreamsResult["upstreams"];
                  int totalQueries = upstreamsResult["total_queries"];
                  var pieDataList = generateUpstreamsPieData(
                    upstreams,
                    totalQueries,
                  );

                  widget = Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: KCardStyle.cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2,
                            ),
                            child: Text(
                              "Upstreams",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                // color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomPieChart(
                            space: 2,
                            horizontalLine: 10,
                            outerMargin: 20,
                            data: pieDataList,
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  widget = ErrorCardWidget(
                    header: "Upstreams",
                    message: "Error loading data",
                  );
                } else {
                  widget = EmptyCardWidget(
                    header: "Upstreams",
                    message: "No data",
                  );
                }
                return widget;
              },
            ),

            // ----------------
            // Stats Lists
            // ----------------
            // Top Domains
            FutureBuilder(
              future: getDomains(false),
              builder: (context, AsyncSnapshot snapshot) {
                Widget widget;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  widget = Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  var domainsResult = snapshot.data;
                  var domains = domainsResult["domains"];
                  int totalQueries = domainsResult["total_queries"];
                  var topDomainsList = generateTopDomainsData(
                    domains,
                    totalQueries,
                    Color(0xFF00a65a),
                    false,
                  );

                  widget = Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: KCardStyle.cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2,
                            ),
                            child: Text(
                              "Top Permitted Domains",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                // color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.3,
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: topDomainsList,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  widget = ErrorCardWidget(
                    header: "Top Permitted Domains",
                    message: "Error loading data",
                  );
                } else {
                  widget = EmptyCardWidget(
                    header: "Top Permitted Domains",
                    message: "No data",
                  );
                }
                return widget;
              },
            ),

            // Top Domains - Blocked
            FutureBuilder(
              future: getDomains(true),
              builder: (context, AsyncSnapshot snapshot) {
                Widget widget;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  widget = Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  var domainsResult = snapshot.data;
                  var domains = domainsResult["domains"];
                  int totalQueries = domainsResult["blocked_queries"];
                  var topDomainsList = generateTopDomainsData(
                    domains,
                    totalQueries,
                    Color(0xFFb00000),
                    true,
                  );

                  widget = Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: KCardStyle.cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2,
                            ),
                            child: Text(
                              "Top Blocked Domains",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                // color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.3,
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: topDomainsList,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  widget = ErrorCardWidget(
                    header: "Top Blocked Domains",
                    message: "Error loading data",
                  );
                } else {
                  widget = EmptyCardWidget(
                    header: "Top Blocked Domains",
                    message: "No data",
                  );
                }
                return widget;
              },
            ),

            // Top Clients
            FutureBuilder(
              future: getClients(false),
              builder: (context, AsyncSnapshot snapshot) {
                Widget widget;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  widget = Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  var clientsResult = snapshot.data;
                  var clients = clientsResult["clients"];
                  int totalQueries = clientsResult["total_queries"];
                  var topClientsList = generateTopClientsData(
                    clients,
                    totalQueries,
                    Color(0xFF00a65a),
                    false,
                  );

                  widget = Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: KCardStyle.cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2,
                            ),
                            child: Text(
                              "Top Clients (Total)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                // color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.3,
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: topClientsList,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  widget = ErrorCardWidget(
                    header: "Top Clients (Total)",
                    message: "Error loading data",
                  );
                } else {
                  widget = EmptyCardWidget(
                    header: "Top Clients (Total)",
                    message: "No data",
                  );
                }
                return widget;
              },
            ),

            // Top Clients - Blocked
            FutureBuilder(
              future: getClients(true),
              builder: (context, AsyncSnapshot snapshot) {
                Widget widget;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  widget = Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  var clientsResult = snapshot.data;
                  var clients = clientsResult["clients"];
                  int totalQueries = clientsResult["blocked_queries"];
                  var topClientsList = generateTopClientsData(
                    clients,
                    totalQueries,
                    Color(0xFFb00000),
                    true,
                  );

                  widget = Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: KCardStyle.cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2,
                            ),
                            child: Text(
                              "Top Clients (Blocked only)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                // color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.3,
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: topClientsList,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  widget = ErrorCardWidget(
                    header: "Top Clients (Blocked only)",
                    message: "Error loading data",
                  );
                } else {
                  widget = EmptyCardWidget(
                    header: "Top Clients (Blocked only)",
                    message: "No data",
                  );
                }
                return widget;
              },
            ),
          ],
        ),
      ),
    );
  }
}
