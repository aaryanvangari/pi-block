import 'package:flutter/material.dart';
import 'package:pi_block/constants/constants.dart';
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
    final widgets = [
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
      BlockedClientStats()
    ];

    return Scaffold(
      // appBar: AppBar(),
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
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 8.0, // Space between columns
                    mainAxisSpacing: 8.0, // Space between rows
                    mainAxisExtent: KGridCardSizes.stats["height"]!.toDouble(),
                    maxCrossAxisExtent: KGridCardSizes.stats["width"]!.toDouble(),
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
