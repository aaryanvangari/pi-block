import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/stats_bloc.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/widgets/blocked_client_stats.dart';
import 'package:pi_block/widgets/blocked_domain_stats.dart';
import 'package:pi_block/widgets/clients_barchart_stats.dart';
import 'package:pi_block/widgets/dns_cache_stats_piechart.dart';
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

      // DNS Cache Piechart
      // (no need to listen when pull to refresh)
      // as its updating with a timer
      DnsCacheStatsPiechart(),

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
    ];

    return Scaffold(
      // appBar: AppBar(),
      body: BlocProvider(
        create: (context) => StatsBloc(),
        child: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        const Text(
                          'Statistics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          iconSize: 25,
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          constraints: BoxConstraints(
                            minHeight: 25,
                            minWidth: 25,
                          ),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Refresh Statistics',
                          onPressed: () {
                            context.read<StatsBloc>().add(RefreshStats());
                          },
                          icon: Icon(Icons.refresh),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        if (width < 500) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              context.read<StatsBloc>().add(RefreshStats());
                            },
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
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
                                mainAxisExtent: KGridCardSizes.stats["height"]!
                                    .toDouble(),
                                maxCrossAxisExtent: KGridCardSizes.stats["width"]!
                                    .toDouble(),
                              ),
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
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
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
