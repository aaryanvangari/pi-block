import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/blocs/notifications/notifications_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/diagnostic_message_model.dart';

class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          NotificationsBloc(context.read<PiholeRepository>())
            ..add(NotificationsFetched()),
      child: const NotificationsListView(),
    );
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
          context.go("/notifications");
        },
        icon: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsFailure) {
              return const Icon(Icons.notifications_paused);
            } else if (state is NotificationsLoading) {
              return const Icon(Icons.notifications_paused);
            } else if (state is NotificationsEmpty) {
              return const Icon(Icons.notifications_none);
            } else if (state is NotificationsSuccess) {
              List<DiagnosticMessageModel> diagnosticMessagesList =
                  state.diagnosticMessagesList;
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
