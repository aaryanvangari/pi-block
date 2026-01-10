import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/blocs/notifications/notifications_bloc.dart';
import 'package:pi_block/models/diagnostic_message_model.dart';
import 'package:pi_block/router/app_routes.dart';

class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationsListView();
  }
}

class NotificationsListView extends StatelessWidget {
  const NotificationsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: IconButton(
        onPressed: () {
          context.pushNamed(AppRoutes.notifications);
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
