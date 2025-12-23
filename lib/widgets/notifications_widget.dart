import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/blocs/notifications/notifications_bloc.dart';
import 'package:pi_block/models/diagnostic_message_model.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({super.key});

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {

  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(NotificationsFetched());
  }
  
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
            Widget widget = SizedBox();
            if (state is NotificationsLoading) {
              widget = Icon(Icons.notifications_paused);
            } else if (state is NotificationsEmpty) {
              widget = Icon(Icons.notifications_none);
            } else if (state is NotificationsSuccess) {
              List<DiagnosticMessageModel> diagnosticMessagesList =
                  state.diagnosticMessagesList;
              widget = Badge.count(
                count: diagnosticMessagesList.length,
                child: Icon(Icons.notifications_on),
              );
            }
            return widget;
          },
        ),
      ),
    );
  }
}
