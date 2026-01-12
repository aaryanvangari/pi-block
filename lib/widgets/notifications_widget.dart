import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/blocs/notifications/notifications_bloc.dart';
import 'package:pi_block/models/diagnostic_message_model.dart';
import 'package:pi_block/router/app_routes.dart';

class NotificationsWidget extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const NotificationsWidget({super.key, required this.navigationShell});

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: IconButton(
        onPressed: () {
          widget.navigationShell.goBranch(AppDestination.notifications.branchIndex);
        },
        icon: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state.status == NotificationsStateStatus.loading) {
              return const Icon(Icons.notifications_paused);
            } else if (state.status == NotificationsStateStatus.failure) {
              return const Icon(Icons.notifications_paused);
            } else if (state.messages.isEmpty) {
              return const Icon(Icons.notifications_none);
            } else if (state.status == NotificationsStateStatus.success) {
              List<DiagnosticMessageModel> diagnosticMessagesList =
                  state.messages;
              return Badge.count(
                count: diagnosticMessagesList.length,
                child: Icon(Icons.notifications_on),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
