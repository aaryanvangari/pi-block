import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/dashboard/metrics_bloc.dart';
import 'package:pi_block/models/metrics_model.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/waiting_card_widget.dart';

class DnsRepliesStats extends StatelessWidget {
  const DnsRepliesStats({super.key});

  @override
  Widget build(BuildContext context) {
    return DnsRepliesStatsView();
  }
}

class DnsRepliesStatsView extends StatelessWidget {
  const DnsRepliesStatsView({super.key});

  static const _title = "DNS Replies";

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MetricsBloc, MetricsState, SectionState<DnsReplies>>(
      selector: (state) => state.replies,
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
            DnsReplies dnsReplies = state.data!;

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
                            const Text("Local/cache replies"),
                            Text(
                              '${dnsReplies.local} (${((dnsReplies.local * 100) / dnsReplies.sum).toStringAsFixed(1)}%)',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Forwarded queries"),
                            Text(
                              '${dnsReplies.forwarded} (${((dnsReplies.forwarded * 100) / dnsReplies.sum).toStringAsFixed(1)}%)',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Cache optimizer replies"),
                            Text(
                              '${dnsReplies.optimized} (${((dnsReplies.optimized * 100) / dnsReplies.sum).toStringAsFixed(1)}%)',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Unanswered queries"),
                            Text(
                              '${dnsReplies.unanswered} (${((dnsReplies.unanswered * 100) / dnsReplies.sum).toStringAsFixed(1)}%)',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Authoritative replies"),
                            Text(
                              '${dnsReplies.auth} (${((dnsReplies.auth * 100) / dnsReplies.sum).toStringAsFixed(1)}%)',
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
