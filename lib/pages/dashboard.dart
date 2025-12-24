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
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
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
          ],
        ),
      ),
    );
  }
}
