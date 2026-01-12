import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pi_block/blocs/notifications/notifications_bloc.dart';
import 'package:pi_block/models/diagnostic_message_model.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/theme/app_ui_context.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/widgets/empty_widget.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _NotificationsView();
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

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
        const Text('Message ID: ', style: KTextStyle.listExpandedTitle),
        const Text('Time: ', style: KTextStyle.listExpandedTitle),
        const Text('Message: ', style: KTextStyle.listExpandedTitle),
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
                backgroundColor: context.ui.slideError,
                icon: Icons.delete,
              ),
            ],
          ),
          child: _diagnosticsMessagesRow(selectedPageItem),
        );
      },
      separatorBuilder: (context, index) {
        return KDivider.listDivider;
      },
    );
    return listView;
  }

  @override
  Widget build(BuildContext context) {
    context.ui; // updates AppUiTokens when theme changes
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Diagnostic Messages",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    iconSize: 25,
                    padding: EdgeInsets.zero,
                    alignment: Alignment.center,
                    constraints: BoxConstraints(minHeight: 25, minWidth: 25),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Refresh Notifications',
                    onPressed: () {
                      context.read<NotificationsBloc>().add(
                        LoadNotifications(),
                      );
                    },
                    icon: Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
            BlocConsumer<NotificationsBloc, NotificationsState>(
              listener: (context, state) {
                if (state.status == NotificationsStateStatus.failure) {
                  PiUtils.handleGeneralException(context, "An Error Occured");
                } else if (state.itemStatus ==
                    NotificationsItemStateStatus.failure) {
                  PiUtils.handleGeneralException(context, "An Error Occured");
                }
              },
              builder: (context, state) {
                if (state.status == NotificationsStateStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == NotificationsStateStatus.failure) {
                  return const CustomErrorWidget(message: "Error loading data");
                } else if (state.messages.isEmpty) {
                  return const Center(child: EmptyWidget(message: "No data"));
                } else if (state.status == NotificationsStateStatus.success) {
                  List<DiagnosticMessageModel> diagnosticMessagesList =
                      state.messages;
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<NotificationsBloc>().add(
                          LoadNotifications(),
                        );
                      },
                      child: generateDiagnosticsMessages(
                        diagnosticMessagesList,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
