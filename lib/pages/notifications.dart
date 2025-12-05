import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:pi_block/models/diagnostic_message_model.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/components/pi_http_client.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  PiHttpClient piHttpClient = PiHttpClient();

  Widget _diagnosticsMessagesRow(dynamic message) {
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
          width: MediaQuery.sizeOf(context).width * 0.98,
          // height: MediaQuery.sizeOf(context).width * 0.35,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: listHeaderBackground.value,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${message.plain}',
                          style: TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.type ?? "",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          PiUtils.getTimeAgo(
                            (message.timestamp!).toInt(),
                            "milliseconds",
                          ),
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),
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
                        Text(
                          'Message ID: ',
                          style: KTextStyle.listExpandedTitle,
                        ),
                        Text('Time: ', style: KTextStyle.listExpandedTitle),
                        Text('Message: ', style: KTextStyle.listExpandedTitle),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${message.id}',
                          style: KTextStyle.listExpandedValue,
                        ),
                        Text(
                          PiUtils.getDateFormatter(message.timestamp!),
                          style: KTextStyle.listExpandedValue,
                        ),
                        Text(
                          '${message.plain}',
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

  Widget generateDiagnosticsMessages(dynamic data) {
    var items = data["messages"];
    ListView listView = ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var selectedPageItem = items[index];
        return _diagnosticsMessagesRow(selectedPageItem);
      },
      separatorBuilder: (context, index) {
        return KListStyle.listDivider;
      },
    );
    return listView;
  }

  Future<Map<dynamic, dynamic>> getDiagnosticMessages() async {
    try {
      var result = await piHttpClient.get(KUrls.messages);
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "NotificationsPage.getDiagnosticMessages",
      );

      var diagnosticsData = {};
      diagnosticsData["messages"] = (result['messages'] as List<dynamic>)
          .map(
            (json) =>
                DiagnosticMessageModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      return diagnosticsData;
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go("/home");
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                FutureBuilder(
                  future: getDiagnosticMessages(),
                  builder: (context, AsyncSnapshot snapshot) {
                    Widget widget;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      widget = Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      var messagesResult = snapshot.data;

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
                                  "Pi-hole diagnosis",
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
                                    MediaQuery.sizeOf(context).height * 0.35,
                                width: MediaQuery.sizeOf(context).width * 0.98,
                                child: generateDiagnosticsMessages(
                                  messagesResult,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      widget = ErrorCardWidget(
                        header: "Pi-hole diagnosis",
                        message: "Error loading data",
                      );
                    } else {
                      widget = EmptyCardWidget(
                        header: "Pi-hole diagnosis",
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
