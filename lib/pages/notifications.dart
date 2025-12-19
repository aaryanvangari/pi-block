import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/blocs/notifications/notifications_bloc.dart';
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/models/diagnostic_message_model.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/widgets/empty_widget.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Widget _diagnosticsMessagesRow(DiagnosticMessageModel message) {
    return CustomExpansionTileWidget(
      isHeaderARow: false,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.type,
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PiUtils.getTimeAgo(
                    (message.timestamp).toInt(),
                    "milliseconds",
                  ),
                  style: KTextStyle.listHeaderTimeTitle,
                ),
              ],
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
        return Slidable(
          key: Key(selectedPageItem.id.toString()),
          startActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                onPressed: (context) {
                  context.read<NotificationsBloc>().add(
                    DeleteNotification(selectedPageItem),
                  );
                },
                autoClose: true,
                backgroundColor: slideError.value,
                icon: Icons.delete,
              ),
            ],
          ),
          child: _diagnosticsMessagesRow(selectedPageItem),
        );
      },
      separatorBuilder: (context, index) {
        return KListStyle.listDivider;
      },
    );
    return listView;
  }

  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(NotificationsFetched());
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
                BlocConsumer<NotificationsBloc, NotificationsState>(
                  listener: (context, state) {
                    if (state is NotificationsFailure) {
                      PiUtils.handleGeneralException(context, state.error);
                    } else if (state is NotificationItemOperationSuccess) {
                      GlobalSnackbar.info(context, state.message, "");
                    } else if (state is NotificationItemOperationFailure) {
                      GlobalSnackbar.error(context, state.errorMessage, "");
                    }
                  },
                  builder: (context, state) {
                    Widget widget = SizedBox();
                    if (state is NotificationsFailure) {
                      widget = CustomErrorWidget(message: "Error loading data");
                    }
                    if (state is NotificationsLoading) {
                      widget = Center(child: CircularProgressIndicator());
                    }
                    if (state is NotificationsEmpty) {
                      widget = EmptyWidget(message: "No Messages");
                    }
                    if (state is NotificationsSuccess) {
                      List<DiagnosticMessageModel> diagnosticMessagesList =
                          state.diagnosticMessagesList;
                      widget = SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.9,
                        width: MediaQuery.sizeOf(context).width * 0.99,
                        child: generateDiagnosticsMessages(
                          diagnosticMessagesList,
                        ),
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
