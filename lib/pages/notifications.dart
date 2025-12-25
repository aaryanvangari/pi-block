import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/blocs/notifications/notifications_bloc.dart';
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/diagnostic_message_model.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/theme/app_ui_tokens.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/widgets/empty_widget.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          NotificationsBloc(context.read<PiholeRepository>())
            ..add(NotificationsFetched()),
      child: _NotificationsView(),
    );
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
                backgroundColor: Theme.of(
                  context,
                ).extension<AppUiTokens>()!.slideError,
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go("/home");
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
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
                  if (state is NotificationsFailure) {
                    return const CustomErrorWidget(
                      message: "Error loading data",
                    );
                  } else if (state is NotificationsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotificationsEmpty) {
                    return const EmptyWidget(message: "No Messages");
                  } else if (state is NotificationsSuccess) {
                    List<DiagnosticMessageModel> diagnosticMessagesList =
                        state.diagnosticMessagesList;
                    return Expanded(
                      child: generateDiagnosticsMessages(
                        diagnosticMessagesList,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
