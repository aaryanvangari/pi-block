import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/dashboard/system_info_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/system_model.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/load_text.dart';
import 'package:pi_block/widgets/waiting_card_widget.dart';

class SystemInfoStats extends StatelessWidget {
  const SystemInfoStats({super.key});

  @override
  Widget build(BuildContext context) {
    return const SystemInfoStatsView();
  }
}

enum MemoryType { ram, swap }

class SystemInfoStatsView extends StatelessWidget {
  const SystemInfoStatsView({super.key});

  static const _title = "System";

  String getMemoryInfo(MemoryType type, SystemModel systemModel) {
    String memoryInfo = "";
    const int bytesToGb = 1024 * 1024;
    final dynamic memory;

    if (type == MemoryType.ram) {
      memory = systemModel.system.memory.ram;
    } else {
      memory = systemModel.system.memory.swap;
    }

    String toGb(int value) => (value / bytesToGb).toStringAsFixed(1);
    final usedGb = toGb(memory.used);
    final totalGb = toGb(memory.total);
    memoryInfo =
        "${usedGb}GB / ${totalGb}GB (${memory.percentUsed.toStringAsFixed(2)}%)";
    return memoryInfo;
  }

  List<Widget> getSystemLoad(List<double> loads) {
    return loads.map((load) {
      final Color color;

      if (load < 1) {
        color = KColors.systemLoadLow;
      } else if (load < 2) {
        color = KColors.systemLoadMedium;
      } else {
        color = KColors.systemLoadHigh;
      }

      return LoadTextWidget(title: load, color: color);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SystemInfoBloc, SystemInfoState>(
      listener: (context, state) {
        if (state.status == SystemStateStatus.failure) {
          PiUtils.handleGeneralException(context, state.error);
        }
      },
      builder: (context, state) {
        if (state.status == SystemStateStatus.failure) {
          return const ErrorCardWidget(
            header: _title,
            message: "Error loading data",
          );
        } else if (state.status == SystemStateStatus.loading) {
          return const WaitingCardWidget(header: _title);
        } else if (state.status == SystemStateStatus.success) {
          SystemModel systemModel = state.systemModel;

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
                          const Text("Uptime"),
                          Text(
                            PiUtils.getTimeAgo(
                              systemModel.system.uptime,
                              "seconds",
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Ram"),
                          Text(
                            getMemoryInfo(MemoryType.ram, systemModel),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Swap"),
                          Text(
                            getMemoryInfo(MemoryType.swap, systemModel),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Cpu"),
                          Text(
                            "${systemModel.system.cpu.nprocs} cores (${systemModel.system.cpu.percentCpu.toStringAsFixed(2)}%)",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Load"),
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
        return const SizedBox.shrink();
      },
    );
  }
}
