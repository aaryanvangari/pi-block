import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/dashboard/dashboard_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/models/host_model.dart';
import 'package:pi_block/widgets/error_card_widget.dart';

class HostInfoStats extends StatefulWidget {
  const HostInfoStats({super.key});

  @override
  State<HostInfoStats> createState() => _HostInfoStatsState();
}

class _HostInfoStatsState extends State<HostInfoStats> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadHostInfo());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) {
        if ((current is HostInfoInitial ||
                current is HostInfoLoaded ||
                current is HostInfoLoading ||
                current is HostInfoError) &&
            previous != current) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is HostInfoError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is HostInfoError) {
          widget = ErrorCardWidget(
            header: "Host",
            message: "Error loading data",
          );
        } else if (state is HostInfoLoading) {
          widget = Center(child: CircularProgressIndicator());
        } else if (state is HostInfoLoaded) {
          HostModel hostModel = state.hostModel;

          widget = Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: KCardStyle.dashboardCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Host",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Hostname"),
                          Text(
                            hostModel.host.uname.nodename,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Product"),
                          Text(
                            hostModel.host.dmi.product.version,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Board"),
                          Text(
                            '${hostModel.host.dmi.board.vendor}-${hostModel.host.dmi.board.name}',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
        return widget;
      },
    );
  }
}
