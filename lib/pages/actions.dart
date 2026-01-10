import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/actions/actions_bloc.dart';
import 'package:pi_block/components/global_banner.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/gravity_log_model.dart';
import 'package:pi_block/theme/app_colors.dart';

class ActionsPage extends StatelessWidget {
  const ActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ActionsBloc(context.read<PiholeRepository>()),
        ),
      ],
      child: _ActionsView(),
    );
  }
}

class _ActionsView extends StatefulWidget {
  const _ActionsView();
  @override
  State<_ActionsView> createState() => _ActionsViewState();
}

class _ActionsViewState extends State<_ActionsView> {
  String streamedData = "";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text('Actions')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      context.read<ActionsBloc>().add(UpdateGravity());
                    },
                    child: Text('Update Gravity'),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: BlocConsumer<ActionsBloc, ActionsState>(
                  listener: (context, state) {
                    if (state.gravityStatus == GravityStateStatus.failure) {
                      PiUtils.handleGeneralException(context, state.error);
                    } else if (state.gravityStatus ==
                        GravityStateStatus.success) {
                      GlobalBanner.info(context, state.message, "");
                    }
                  },
                  builder: (context, state) {
                    if (state.gravityStatus == GravityStateStatus.loading ||
                        state.gravityStatus == GravityStateStatus.success) {
                      return ListView(
                        children: state.gravityOutput.map((log) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (log.type == GravityLogType.success)
                                const Text(
                                  ' [✓] ',
                                  style: TextStyle(
                                    color: KGravityLogsColors.success,
                                  ),
                                ),
                              if (log.type == GravityLogType.info &&
                                  log.message.isNotEmpty)
                                const Text(' [i] '),
                              if (log.type == GravityLogType.error)
                                const Text(
                                  ' [✗] ',
                                  style: TextStyle(
                                    color: KGravityLogsColors.error,
                                  ),
                                ),
                              if (log.type == GravityLogType.none)
                                const Text('     '),
                              Expanded(child: Text(log.message)),
                            ],
                          );
                        }).toList(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
