import 'package:flutter/material.dart';
import 'package:pi_block/widgets/blocked_client_stats.dart';
import 'package:pi_block/widgets/blocked_domain_stats.dart';
import 'package:pi_block/widgets/clients_barchart_stats.dart';
import 'package:pi_block/widgets/permitted_client_stats.dart';
import 'package:pi_block/widgets/permitted_domain_stats.dart';
import 'package:pi_block/widgets/queries_barchart_stats.dart';
import 'package:pi_block/widgets/query_types_stats.dart';
import 'package:pi_block/widgets/upstreams_stats.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            /// Total Queries
            QueriesBarchartStats(),

            /// Client Activity
            ClientsBarchartStats(),

            // ----------------
            // Pie Charts
            // ----------------
            /// Query Types
            QueryTypesStats(),

            /// Upstreams
            UpstreamsStats(),

            // ----------------
            // Stats Lists
            // ----------------

            /// Top Permitted Domains
            PermittedDomainStats(),

            /// Top Blocked Domains
            BlockedDomainStats(),

            /// Top Clients
            PermittedClientStats(),

            /// Top Clients (Blocked only)
            BlockedClientStats(),
          ],
        ),
      ),
    );
  }
}
