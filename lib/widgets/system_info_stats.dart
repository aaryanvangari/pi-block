import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/dashboard/dashboard_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/models/system_model.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/load_text.dart';

class SystemInfoStats extends StatefulWidget {
  const SystemInfoStats({super.key});

  @override
  State<SystemInfoStats> createState() => _SystemInfoStatsState();
}

class _SystemInfoStatsState extends State<SystemInfoStats> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadSystemInfo());
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
      // log('timer ${t.tick}');
      context.read<DashboardBloc>().add(LoadSummaryInfo());
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String getMemoryInfo(String type, SystemModel systemModel) {
    String memoryInfo = "";
    int free = 0;
    int total = 0;
    double usedPercentage = 0.0;
    if (type == "ram") {
      free = systemModel.system.memory.ram.used;
      total = systemModel.system.memory.ram.total;
      usedPercentage = systemModel.system.memory.ram.percentUsed;
    } else if (type == "swap") {
      free = systemModel.system.memory.swap.used;
      total = systemModel.system.memory.swap.total;
      usedPercentage = systemModel.system.memory.swap.percentUsed;
    }
    String freeString = (free / (1024 * 1024)).toStringAsFixed(1);
    String totalString = (total / (1024 * 1024)).toStringAsFixed(1);
    memoryInfo =
        "${freeString}GB / ${totalString}GB (${usedPercentage.toStringAsFixed(2)}%)";
    return memoryInfo;
  }

  List<Widget> getSystemLoad(List<double> loads) {
    List<Widget> loadList = [];
    for (var load in loads) {
      if (load > 1 && load < 2) {
        loadList.add(LoadTextWidget(title: load, color: Colors.orange));
      } else if (load < 1) {
        loadList.add(LoadTextWidget(title: load, color: Colors.green));
      } else if (load > 2) {
        loadList.add(LoadTextWidget(title: load, color: Colors.red));
      }
    }
    return loadList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) {
        if ((current is SystemInfoInitial ||
                current is SystemInfoLoaded ||
                current is SystemInfoLoading ||
                current is SystemInfoError) &&
            previous != current) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is SystemInfoError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is SystemInfoError) {
          widget = ErrorCardWidget(
            header: "System",
            message: "Error loading data",
          );
        } else if (state is SystemInfoLoading) {
          widget = Center(child: CircularProgressIndicator());
        } else if (state is SystemInfoLoaded) {
          SystemModel systemModel = state.systemModel;

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
                    "System",
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
                          Text("Uptime"),
                          Text(
                            PiUtils.getTimeAgo(
                              systemModel.system.uptime,
                              "seconds",
                            ),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Ram"),
                          Text(
                            getMemoryInfo("ram", systemModel),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Swap"),
                          Text(
                            getMemoryInfo("swap", systemModel),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Cpu"),
                          Text(
                            "${systemModel.system.cpu.nprocs} cores (${systemModel.system.cpu.percentCpu.toStringAsFixed(2)}%)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Load"),
                          Row(
                            children: getSystemLoad(
                              systemModel.system.cpu.load.raw,
                            ),
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
