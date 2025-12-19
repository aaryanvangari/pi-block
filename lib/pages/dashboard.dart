import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/dashboard/dashboard_bloc.dart';
import 'package:pi_block/widgets/blocking_info_stats.dart';

import 'package:pi_block/widgets/host_info_stats.dart';
import 'package:pi_block/widgets/session_info_stats.dart';
import 'package:pi_block/widgets/summary_info_stats.dart';
import 'package:pi_block/widgets/system_info_stats.dart';
import 'package:pi_block/widgets/version_info_stats.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
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
