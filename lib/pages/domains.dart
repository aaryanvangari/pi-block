import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/widgets/custom_tag.dart';

import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/components/pi_http_client.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';

class DomainsPage extends StatefulWidget {
  const DomainsPage({super.key});

  @override
  State<DomainsPage> createState() => _DomainsPageState();
}

class _DomainsPageState extends State<DomainsPage> {
  PiHttpClient piHttpClient = PiHttpClient();

  Future<void> onDomainStateChanged(bool status, dynamic item) async {
    try {
      final queryParameter = <String, dynamic>{};
      var body = jsonEncode(<String, dynamic>{
        "comment": item.comment,
        "kind": item.kind,
        "groups": item.groups,
        "type": item.type,
        "enabled": status,
      });
      log(body.toString());
      String domainEncoded = Uri.encodeComponent(item.domain);

      var result = await piHttpClient.put(
        '${KUrls.domains}/${item.type}/${item.kind}/$domainEncoded',
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
        name: "DomainsPage.onDomainStateChanged",
      );
    } catch (e) {
      if (!mounted) return;
      PiUtils.handleGeneralException(context, e);
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
      Map<String, dynamic> listData = {};
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "DomainsPage.getDomainsData",
      );
      listData["domains"] = (result['domains'] as List<dynamic>)
          .map((json) => DomainModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return listData;
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
      rethrow;
    }
  }

  Widget _domainRow(DomainModel item) {
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
            // color: (item.type == "deny")? KListStyle.listHeaderBackgroundColors["red"]?.withAlpha(15): KListStyle.listHeaderBackgroundColors["green"]?.withAlpha(15),
            color: (item.type == "deny")
                ? listHeaderRedBackground.value
                : listHeaderGreenBackground.value,
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
                            item.domain,
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
                            item.comment,
                            style: KTextStyle.listHeaderSubTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Modified : ${PiUtils.getTimeAgo(item.date_modified, "milliseconds")}',
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
                                onDomainStateChanged(value, item);
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
                            iconData: (item.type == "deny")
                                ? Icons.block
                                : FontAwesomeIcons.check,
                            color: (item.type == "deny")
                                ? Colors.red
                                : Colors.green,
                            title: (item.kind == "regex") ? "Regex" : "Exact",
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
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
                        Text('Unicode: ', style: KTextStyle.listExpandedTitle),
                        Text('Comment: ', style: KTextStyle.listExpandedTitle),
                        Text(
                          'Database ID: ',
                          style: KTextStyle.listExpandedTitle,
                        ),
                        Text('Added: ', style: KTextStyle.listExpandedTitle),
                        Text('Modified: ', style: KTextStyle.listExpandedTitle),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.domain, style: KTextStyle.listExpandedValue),
                        Text(item.unicode, style: KTextStyle.listExpandedValue),
                        Text(item.comment, style: KTextStyle.listExpandedValue),
                        Text(
                          item.id.toString(),
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

  Widget getDomains(dynamic data) {
    var items = data?["domains"];
    ListView listView = ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var selectedPageItem = items[index];
        return _domainRow(selectedPageItem);
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
                  future: getDomainsData(),
                  builder: (context, AsyncSnapshot snapshot) {
                    Widget widget;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      widget = Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      var domains = snapshot.data;

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
                                  "Domains",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    // color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.9 - kToolbarHeight - 8 -
                                    kBottomNavigationBarHeight,
                                width: MediaQuery.sizeOf(context).width * 0.98,
                                child: getDomains(domains),
                              )
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      widget = ErrorCardWidget(
                        header: "Domains",
                        message: "Error loading data",
                      );
                    } else {
                      widget = EmptyCardWidget(
                        header: "Domains",
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
