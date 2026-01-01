import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/dashboard/metrics_bloc.dart';
import 'package:pi_block/models/metrics_model.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/waiting_card_widget.dart';

class DnsCacheStats extends StatelessWidget {
  const DnsCacheStats({super.key});

  @override
  Widget build(BuildContext context) {
    return DnsCacheStatsView();
  }
}

class DnsCacheStatsView extends StatelessWidget {
  const DnsCacheStatsView({super.key});

  static const _title = "DNS Cache";

  String getActiveCacheRecords(DnsCache dnsCache) {
    int total = dnsCache.content.fold<int>(
      0,
      (sum, cacheEntry) =>
          sum + cacheEntry.count.stale + cacheEntry.count.valid,
    );
    String percentage = ((total / dnsCache.size) * 100).toStringAsFixed(1);
    return '$total ($percentage%)';
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MetricsBloc, MetricsState, SectionState<DnsCache>>(
      selector: (state) => state.cache,
      builder: (context, state) {
        switch (state.status) {
          case SectionStatus.loading:
            return const WaitingCardWidget(header: _title);
          case SectionStatus.empty:
            return const EmptyCardWidget(header: _title, message: "No Data");
          case SectionStatus.failure:
            return const ErrorCardWidget(
              header: _title,
              message: "Error loading data",
            );
          case SectionStatus.success:
            DnsCache dnsCache = state.data!;

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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("DNS cache size"),
                            Text(
                              dnsCache.size.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Active cache records"),
                            Text(
                              getActiveCacheRecords(dnsCache),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total cache insertions"),
                            Text(
                              dnsCache.inserted.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("DNS cache evictions"),
                            Text(
                              dnsCache.evicted.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Expired DNS cache entries"),
                            Text(
                              dnsCache.expired.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Immortal DNS cache entries"),
                            Text(
                              dnsCache.immortal.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
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
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
