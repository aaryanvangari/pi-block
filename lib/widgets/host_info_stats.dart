import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/dashboard/host_info_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/host_model.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/waiting_card_widget.dart';

class HostInfoStats extends StatelessWidget {
  const HostInfoStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HostInfoBloc(context.read<PiholeRepository>())..add(LoadHostInfo()),
      child: const HostInfoStatsView(),
    );
  }
}

class HostInfoStatsView extends StatelessWidget {
  const HostInfoStatsView({super.key});

  static const _title = "Host";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HostInfoBloc, HostInfoState>(
      listener: (context, state) {
        if (state.status == HostStateStatus.failure) {
          PiUtils.handleGeneralException(context, state.error);
        }
      },
      builder: (context, state) {
        if (state.status == HostStateStatus.failure) {
          return const ErrorCardWidget(
            header: _title,
            message: "Error loading data",
          );
        } else if (state.status == HostStateStatus.loading) {
          return const WaitingCardWidget(header: _title);
        } else if (state.status == HostStateStatus.success) {
          HostModel hostModel = state.hostModel;

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: KCardStyle.dashboardCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    _title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Hostname"),
                          Text(
                            hostModel.host.uname.nodename,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Product"),
                          Text(
                            hostModel.host.dmi.product.version,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Board"),
                          Text(
                            '${hostModel.host.dmi.board.vendor}-${hostModel.host.dmi.board.name}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
