import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:pi_block/models/lists_model.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/widgets/custom_tag.dart';

import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/components/pi_http_client.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  PiHttpClient piHttpClient = PiHttpClient();

  Future<void> onListStateChanged(bool status, dynamic item) async {
    try {
      final queryParameter = <String, dynamic>{'type': item.type};
      var body = jsonEncode(<String, dynamic>{
        "comment": item.comment,
        "groups": item.groups,
        "type": item.type,
        "enabled": status,
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
      // #TODO improve this logic when implementing BLOC
      setState(() {
        log(result.toString());
      });
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "ListsPage.onListStateChanged",
      );
    } catch (e) {
      if (!mounted) return;
      PiUtils.handleGeneralException(context, e);
    }
  }

  Future<Object> getListsData() async {
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
        name: "ListsPage.getListsData",
      );
      List<ListsModel> listsModels = (result['lists'] as List<dynamic>)
          .map((json) => ListsModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return listsModels;
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
      rethrow;
    }
  }

  Widget _listRow(ListsModel item) {
    return ListTileTheme(
      minVerticalPadding: 0,
      child: ExpansionTile(
        showTrailingIcon: false,
        childrenPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // backgroundColor: Theme.of(context).colorScheme.onSurface.withAlpha(40),
        // collapsedBackgroundColor: Theme.of(context).colorScheme.onSurface.withAlpha(15),
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
          width: MediaQuery.sizeOf(context).width * 0.99,
          // height: MediaQuery.sizeOf(context).height * 0.15,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: listHeaderBackground.value,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.55,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.comment,
                            style: KTextStyle.listHeaderTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.address,
                            style: KTextStyle.listHeaderSubTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Updated : ${PiUtils.getTimeAgo(item.date_updated, "milliseconds")}',
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: FlutterSwitch(
                              height: 15.0,
                              width: 35.0,
                              padding: 2.0,
                              toggleSize: 15.0,
                              borderRadius: 10.0,
                              activeColor: Colors.green,
                              value: item.enabled,
                              onToggle: (value) {
                                onListStateChanged(value, item);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomTagWidget(
                            iconData: (item.type == "block")
                                ? Icons.block
                                : FontAwesomeIcons.check,
                            color: (item.type == "block")
                                ? Colors.red
                                : Colors.green,
                            title: (item.type == "block")
                                ? "Blocklist"
                                : "Allowlist",
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomTagWidget(
                            iconData: (item.status == 1)
                                ? FontAwesomeIcons.circleCheck
                                : FontAwesomeIcons.clockRotateLeft,
                            color: Colors.green,
                            title: (item.status == 1)
                                ? "Downloaded"
                                : "Upstream",
                          ),
                        ],
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
                        Text('Comment: ', style: KTextStyle.listExpandedTitle),
                        Text('Address: ', style: KTextStyle.listExpandedTitle),
                        Text(
                          'Database ID: ',
                          style: KTextStyle.listExpandedTitle,
                        ),
                        Text(
                          'Number of entries: ',
                          style: KTextStyle.listExpandedTitle,
                        ),
                        Text(
                          'Number of non-domains: ',
                          style: KTextStyle.listExpandedTitle,
                        ),
                        Text(
                          'Added to Pi-Hole: ',
                          style: KTextStyle.listExpandedTitle,
                        ),
                        Text(
                          'Database last modified: ',
                          style: KTextStyle.listExpandedTitle,
                        ),
                        Text(
                          'Content last updated on: ',
                          style: KTextStyle.listExpandedTitle,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.comment, style: KTextStyle.listExpandedValue),
                        Text(item.address, style: KTextStyle.listExpandedValue),
                        Text(
                          item.id.toString(),
                          style: KTextStyle.listExpandedValue,
                        ),
                        Text(
                          '${item.number}',
                          style: KTextStyle.listExpandedValue,
                        ),
                        Text(
                          '${item.invalid_domains}',
                          style: KTextStyle.listExpandedValue,
                        ),
                        Text(
                          '${PiUtils.getTimeAgo(item.date_added, "milliseconds")} (${PiUtils.getDateFormatter(item.date_added.toDouble())})',
                          style: KTextStyle.listExpandedValue,
                        ),
                        Text(
                          '${PiUtils.getTimeAgo(item.date_modified, "milliseconds")} (${PiUtils.getDateFormatter(item.date_modified.toDouble())})',
                          style: KTextStyle.listExpandedValue,
                        ),
                        Text(
                          '${PiUtils.getTimeAgo(item.date_updated, "milliseconds")} (${PiUtils.getDateFormatter(item.date_updated.toDouble())})',
                          style: KTextStyle.listExpandedValue,
                        ),
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

  Widget getLists(List<ListsModel> listsModels) {
    ListView listView = ListView.separated(
      itemCount: listsModels.length,
      itemBuilder: (context, index) {
        var selectedPageItem = listsModels[index];
        return _listRow(selectedPageItem);
      },
      separatorBuilder: (context, index) {
        return KListStyle.listDivider;
      },
    );
    return listView;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                FutureBuilder(
                  future: getListsData(),
                  builder: (context, AsyncSnapshot snapshot) {
                    Widget widget;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      widget = Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      List<ListsModel> listsModels =
                          snapshot.data as List<ListsModel>;

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
                                ),
                                child: Text(
                                  "Subscribed Lists",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    // color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.8,
                                width: MediaQuery.sizeOf(context).width * 0.98,
                                child: getLists(listsModels),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      widget = ErrorCardWidget(
                        header: "Subscribed Lists",
                        message: "Error loading data",
                      );
                    } else {
                      widget = EmptyCardWidget(
                        header: "Subscribed Lists",
                        message: "No data",
                      );
                    }
                    return widget;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
