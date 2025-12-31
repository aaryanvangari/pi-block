import 'package:flutter/material.dart';
import 'package:pi_block/widgets/blocking_info_stats.dart';
import 'package:pi_block/widgets/host_info_stats.dart';
import 'package:pi_block/widgets/session_info_stats.dart';
import 'package:pi_block/widgets/summary_info_stats.dart';
import 'package:pi_block/widgets/system_info_stats.dart';
import 'package:pi_block/widgets/version_info_stats.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final widgets = const [
      // DNS Blocking
      BlockingInfoStats(),

      // Pi-Hole Stats Overview
      SummaryInfoStats(),

      // Pi-Hole Session Info
      SessionInfoStats(),

      // Host Information
      HostInfoStats(),

      // System information
      SystemInfoStats(),

      // Versions
      VersionInfoStats(),
    ];

    int crossAxisCount(double width) {
      int minimumWidthOfWidget = 350;
      return (width / minimumWidthOfWidget).toInt();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            if (width < 500) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: widgets,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount(width),
                    crossAxisSpacing: 8.0, // Space between columns
                    mainAxisSpacing: 8.0, // Space between rows
                    childAspectRatio: 1.0,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widgets.length,
                  itemBuilder: (context, index) {
                    return widgets[index];
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
