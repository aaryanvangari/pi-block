import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:pager/pager.dart';
import 'package:pi_block/models/query_model.dart';
import 'package:pi_block/components/pi_http_client.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/widgets/custom_tag.dart';

class QueryLogPage extends StatefulWidget {
  const QueryLogPage({super.key});

  @override
  State<QueryLogPage> createState() => _QueryLogPageState();
}

class _QueryLogPageState extends State<QueryLogPage> {
  int pageSize = 5;
  late int _totalPages = 1;
  int _currentPage = 1;
  dynamic _selectedPageData;
  bool loading = false;
  PiHttpClient piHttpClient = PiHttpClient();

  @override
  void initState() {
    super.initState();
    getFirstPage();
  }

  String getDomainName(query) {
    String domainName = "";
    var queryStatusConstant = KConstants.queryStatus[query.status];
    if (queryStatusConstant?.containsKey("isCNAME")) {
      var isCNAME = queryStatusConstant["isCNAME"];
      domainName = isCNAME
          ? '${query.domain} (blocked ${query.cname})'
          : query.domain;
      return domainName;
    }
    domainName = query.domain;
    return domainName;
  }

  dynamic getFirstPage() async {
    loading = true;
    try {
      final result = await getNextPage(1, pageSize);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "QueryLogPage.getFirstPage",
      );
      setState(() {
        loading = false;
        _selectedPageData = result;
        _totalPages = (result["recordsFiltered"] / pageSize).ceil();
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
    }
    return {};
  }

  Widget getStatusHumanReadableText(Query query) {
    String status = "";
    var queryStatusConstant = KConstants.queryStatus[query.status];
    var isCNAME =
        (queryStatusConstant?.containsKey("isCNAME") &&
        queryStatusConstant["isCNAME"]);
    var customStatusTypes = ["FORWARDED", "SPECIAL_DOMAIN", "default"];
    if (customStatusTypes.contains(query.status)) {
      switch (query.status) {
        case "FORWARDED":
          status =
              (query.reply.type != "UNKNOWN"
                  ? "Forwarded, reply from "
                  : "Forwarded to ") +
              query.upstream!;
          break;
        case "SPECIAL_DOMAIN":
          status = query.status;
          break;
        default:
          status = query.status;
      }
    } else {
      status = KConstants.queryStatus[query.status]["fieldtext"];
      status = isCNAME
          ? '$status Query was blocked during CNAME inspection of ${query.cname}'
          : status;
    }
    Widget statusWidget = Text(
      status,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: KConstants.queryStatus[query.status]?["color"],
      ),
    );

    return statusWidget;
  }

  Widget buildStatusCell(Query row) {
    var queryStatusConstant = KConstants.queryStatus[row.status];
    return Icon(
      queryStatusConstant["icon"],
      size: 12,
      color: queryStatusConstant["color"],
    );
  }

  Widget _queryLogRow(Query query) {
    var queryStatusConstant = KConstants.queryStatus[query.status];
    bool isDarkMode = PiUtils.getDarkMode(context);
    Color queryStatusColor = queryStatusConstant["color"];
    Color queryStatusColorWithAlpha = queryStatusColor.withAlpha(
      isDarkMode
          ? KListStyle.darkAlphaIntensity
          : KListStyle.lightAlphaIntensity,
    );

    return ListTileTheme(
      minVerticalPadding: 0,
      child: ExpansionTile(
        showTrailingIcon: false,
        childrenPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        tilePadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.compact,
        expandedAlignment: Alignment.topLeft,
        collapsedShape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        title: Container(
          width: MediaQuery.sizeOf(context).width * 0.8,
          // height: MediaQuery.sizeOf(context).height * 0.15,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: queryStatusColorWithAlpha,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${query.domain}',
                            style: KTextStyle.listHeaderTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${query.client.name}',
                            style: KTextStyle.listHeaderSubTitle,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            PiUtils.getDateFormatter(query.time!),
                            style: KTextStyle.listHeaderSubTitle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2.0,
                          vertical: 2,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [CustomTagWidget(title: '${query.type}')],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 3,
                        ),
                        child: buildStatusCell(query),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 3,
                        ),
                        child: Text(PiUtils.calculateTime(query.reply.time!)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Domain: ', style: KTextStyle.listExpandedTitle),
                        Text(
                          'Received on: ',
                          style: KTextStyle.listExpandedTitle,
                        ),
                        Text('Client: ', style: KTextStyle.listExpandedTitle),
                        Text('Reply: ', style: KTextStyle.listExpandedTitle),
                        Text(
                          'Database ID: ',
                          style: KTextStyle.listExpandedTitle,
                        ),
                        Text(
                          'Query Status: ',
                          style: KTextStyle.listExpandedTitle,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getDomainName(query),
                          style: KTextStyle.listExpandedValue,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        Text(
                          PiUtils.getDateFormatter(query.time!),
                          style: KTextStyle.listExpandedValue,
                        ),
                        Text(
                          '${query.client.name} (${query.client.ip})',
                          style: KTextStyle.listExpandedValue,
                        ),
                        Text(
                          '${query.reply.type}',
                          style: KTextStyle.listExpandedValue,
                        ),
                        Text(
                          '${query.id}',
                          style: KTextStyle.listExpandedValue,
                        ),
                        getStatusHumanReadableText(query),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget generateQueryLogData(dynamic data) {
    var items = data?["queries"];
    ListView listView = ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var selectedPageItem = items[index];
        return _queryLogRow(selectedPageItem);
      },
      separatorBuilder: (context, index) {
        return KListStyle.listDivider;
      },
    );
    return listView;
  }

  Widget getQueryLog() {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (_selectedPageData != null &&
          _selectedPageData?["queries"]?.length > 0) {
        return generateQueryLogData(_selectedPageData);
      } else if (_selectedPageData?["queries"]?.length == 0) {
        return Center(
          child: Text(
            "No Data",
            style: TextStyle(
              // color: Theme.of(context).colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      } else {
        return Center(
          child: Text(
            "Error loading data",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }
    }
  }

  Future<Map<String, dynamic>> onPageChanged(int page) async {
    Map<String, dynamic> data = {};
    try {
      data = await getNextPage(page, pageSize);
      setState(() {
        _currentPage = page;
        _selectedPageData = data;
      });
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
    }
    return {};
  }

  Future<Map<String, dynamic>> getNextPage(int start, int length) async {
    try {
      final queryParameter = <String, dynamic>{
        'start': ((start - 1) * pageSize).toString(),
        'length': length.toString(),
        // 'status': 'GRAVITY_CNAME',
        // 'domain': '*googlevideo*'
      };

      var result = await piHttpClient.get(
        KUrls.queries,
        queryParams: queryParameter,
      );
      PiUtils.handleAPIException(result, false);
      Map<String, dynamic> queryData = {};

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "QueryLogPage.getNextPage",
      );
      queryData["queries"] = (result['queries'] as List<dynamic>)
          .map((json) => Query.fromJson(json as Map<String, dynamic>))
          .toList();
      queryData["recordsFiltered"] = result["recordsFiltered"];

      return queryData;
    } catch (e) {
      log(
        e.toString(),
        level: Level.SEVERE.value,
        name: "QueryLogPage.getNextPage",
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Query Log",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            // color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.63,
                        width: MediaQuery.sizeOf(context).width * 0.98,
                        child: getQueryLog(),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: (_totalPages > 0)
                    ? Pager(
                        currentItemsPerPage: pageSize,
                        currentPage: _currentPage,
                        totalPages: _totalPages,
                        onPageChanged: (page) => onPageChanged(page),
                        pagesView:
                            2, // #TODO have 3 pages when having bigger devices
                        numberButtonSelectedColor: Theme.of(
                          context,
                        ).colorScheme.primary,
                        numberTextUnselectedColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
