import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:pi_block/models/diagnostic_message_model.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/components/pi_http_client.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/widgets/empty_widget.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  PiHttpClient piHttpClient = PiHttpClient();

  Widget _diagnosticsMessagesRow(DiagnosticMessageModel message) {
    return CustomExpansionTileWidget(
      headerItems: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.plain,
              style: TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.type, style: TextStyle(fontWeight: FontWeight.normal)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              PiUtils.getTimeAgo((message.timestamp).toInt(), "milliseconds"),
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ],
      contentTitleItems: [
        Text('Message ID: ', style: KTextStyle.listExpandedTitle),
        Text('Time: ', style: KTextStyle.listExpandedTitle),
        Text('Message: ', style: KTextStyle.listExpandedTitle),
      ],
      contentValueItems: [
        Text('${message.id}', style: KTextStyle.listExpandedValue),
        Text(
          PiUtils.getDateFormatter(message.timestamp),
          style: KTextStyle.listExpandedValue,
        ),
        Text(message.plain, style: KTextStyle.listExpandedValue),
      ],
    );
  }

  Widget generateDiagnosticsMessages(
    List<DiagnosticMessageModel> diagnosticMessagesList,
  ) {
    var items = diagnosticMessagesList;
    ListView listView = ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var selectedPageItem = items[index];
        return _diagnosticsMessagesRow(selectedPageItem);
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 1,
          thickness: 1,
          indent: 10,
          endIndent: 10,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
        );
      },
    );
    return listView;
  }

  Future<Object> getDiagnosticMessages() async {
    try {
      var result = await piHttpClient.get(KUrls.messages);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "NotificationsPage.getDiagnosticMessages",
      );

      List<DiagnosticMessageModel> diagnosticMessagesList =
          (result['messages'] as List<dynamic>)
              .map(
                (json) => DiagnosticMessageModel.fromJson(
                  json as Map<String, dynamic>,
                ),
              )
              .toList();

      return diagnosticMessagesList;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Diagnostic Messages",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                FutureBuilder(
                  future: getDiagnosticMessages(),
                  builder: (context, AsyncSnapshot snapshot) {
                    Widget widget;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      widget = Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      List<DiagnosticMessageModel> diagnosticMessagesList =
                          snapshot.data as List<DiagnosticMessageModel>;
                      if (diagnosticMessagesList.isNotEmpty) {
                        widget = SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.9,
                          width: MediaQuery.sizeOf(context).width * 0.98,
                          child: generateDiagnosticsMessages(
                            diagnosticMessagesList,
                          ),
                        );
                      } else {
                        widget = EmptyWidget(message: "No Messages");
                      }
                    } else if (snapshot.hasError) {
                      widget = CustomErrorWidget(message: "Error loading data");
                    } else {
                      widget = EmptyWidget(message: "No Messages");
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
